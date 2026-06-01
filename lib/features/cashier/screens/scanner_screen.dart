import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/config/app_constants.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  Timer? _debounce;
  bool _processing = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_processing) return;
    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(AppConstants.scannerDebounce, () {
      _lookupBarcode(barcode);
    });
  }

  Future<void> _lookupBarcode(String barcode) async {
    if (_processing) return;
    setState(() => _processing = true);

    final product =
        await ref.read(productsProvider.notifier).lookupBarcode(barcode);
    if (!mounted) return;

    if (product != null) {
      if (product.isOutOfStock) {
        HapticFeedback.heavyImpact();
        _showMessage(
            '${product.name} — ${Translations.of(context).products.outOfStock}',
            isError: true);
      } else {
        HapticFeedback.mediumImpact(); // success feedback
        ref.read(cartProvider.notifier).addItem(product);
        _showMessage('${product.name} ditambahkan ke keranjang');
      }
    } else {
      HapticFeedback.heavyImpact(); // error feedback
      _showMessage(Translations.of(context).cashier.productNotFound,
          isError: true);
    }

    setState(() => _processing = false);
  }

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(t.cashier.scanBarcode),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onBarcodeDetected,
          ),
          _ScannerOverlay(),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  t.cashier.scanBarcode,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (_processing)
                  const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Consumer(builder: (context, ref, _) {
              final cart = ref.watch(cartProvider);
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return FloatingActionButton.small(
                backgroundColor: Colors.white,
                onPressed: () {
                  context.pop();
                  context.push('/cashier/cart');
                },
                child: Stack(
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.black),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverlayPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    const cutoutSize = 250.0;
    final left = (size.width - cutoutSize) / 2;
    final top = (size.height - cutoutSize) / 2;
    final cutout = Rect.fromLTWH(left, top, cutoutSize, cutoutSize);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
              RRect.fromRectAndRadius(cutout, const Radius.circular(12))),
      ),
      paint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
        RRect.fromRectAndRadius(cutout, const Radius.circular(12)),
        borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
