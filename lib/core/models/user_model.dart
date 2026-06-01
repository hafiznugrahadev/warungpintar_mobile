class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> permissions;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.permissions = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'CASHIER',
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'permissions': permissions,
      };
}

class Store {
  final String id;
  final String name;
  final String slug;
  final String? address;
  final String? phone;
  final String? logoUrl;
  final String? openTime;
  final String? closeTime;
  final bool isActive;

  const Store({
    required this.id,
    required this.name,
    required this.slug,
    this.address,
    this.phone,
    this.logoUrl,
    this.openTime,
    this.closeTime,
    this.isActive = true,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      logoUrl: json['logoUrl'] as String? ?? json['logo_url'] as String?,
      openTime: json['openTime'] as String? ?? json['open_time'] as String?,
      closeTime: json['closeTime'] as String? ?? json['close_time'] as String?,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
