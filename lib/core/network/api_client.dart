import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/secure_storage.dart';
import 'api_exceptions.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  bool _isRefreshing = false;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));
  }

  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  Future<void> _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  Future<void> _onError(
      DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          final token = await secureStorage.getAccessToken();
          error.requestOptions.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(error.requestOptions);
          handler.resolve(response);
          return;
        }
      } catch (_) {
        await secureStorage.clearTokens();
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(error);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await secureStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)).post(
        ApiConfig.refreshPath,
        data: {'refreshToken': refreshToken},
      );
      final data = response.data['data'] ?? response.data;
      await secureStorage.saveAccessToken(data['accessToken'] as String);
      await secureStorage.saveRefreshToken(data['refreshToken'] as String);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<T> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<T> post<T>(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  T _handleResponse<T>(Response response) {
    final body = response.data;
    if (body is Map && body['data'] != null) {
      return body['data'] as T;
    }
    return body as T;
  }

  ApiException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException(message: 'Connection timed out.');
      case DioExceptionType.connectionError:
        return const NetworkException();
      default:
        final statusCode = e.response?.statusCode;
        final body = e.response?.data;
        final message = (body is Map ? body['message'] : null) ??
            e.message ??
            'Unknown error';
        if (statusCode == 401) {
          return UnauthorizedException(message: message.toString());
        }
        if (statusCode == 404) {
          return NotFoundException(message: message.toString());
        }
        if (statusCode != null && statusCode >= 500) {
          return const ServerException();
        }
        return ApiException(
            message: message.toString(), statusCode: statusCode);
    }
  }
}

final apiClient = ApiClient.instance;
