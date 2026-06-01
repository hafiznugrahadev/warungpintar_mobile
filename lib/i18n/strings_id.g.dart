///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsId with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.id,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <id>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsId _root = this; // ignore: unused_field

	@override 
	TranslationsId $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsId(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'WarungPOS';
	@override late final _Translations$common$id common = _Translations$common$id._(_root);
	@override late final _Translations$auth$id auth = _Translations$auth$id._(_root);
	@override late final _Translations$cashier$id cashier = _Translations$cashier$id._(_root);
	@override late final _Translations$products$id products = _Translations$products$id._(_root);
	@override late final _Translations$inventory$id inventory = _Translations$inventory$id._(_root);
	@override late final _Translations$history$id history = _Translations$history$id._(_root);
	@override late final _Translations$customer$id customer = _Translations$customer$id._(_root);
	@override late final _Translations$settings$id settings = _Translations$settings$id._(_root);
}

// Path: common
class _Translations$common$id implements Translations$common$en {
	_Translations$common$id._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Memuat...';
	@override String get save => 'Simpan';
	@override String get cancel => 'Batal';
	@override String get delete => 'Hapus';
	@override String get edit => 'Ubah';
	@override String get search => 'Cari...';
	@override String get retry => 'Coba Lagi';
	@override String get noResults => 'Tidak ada hasil';
	@override String get confirm => 'Konfirmasi';
	@override String get success => 'Berhasil';
	@override String get error => 'Kesalahan';
	@override String get ok => 'OK';
}

// Path: auth
class _Translations$auth$id implements Translations$auth$en {
	_Translations$auth$id._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get login => 'Masuk';
	@override String get logout => 'Keluar';
	@override String get email => 'Email';
	@override String get password => 'Kata Sandi';
	@override String get loginButton => 'Masuk';
	@override String get loginFailed => 'Email atau kata sandi salah';
	@override String get selectStore => 'Pilih Toko';
	@override String get selectStoreSub => 'Pilih toko yang ingin dikelola';
}

// Path: cashier
class _Translations$cashier$id implements Translations$cashier$en {
	_Translations$cashier$id._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kasir';
	@override String get scanBarcode => 'Pindai Barcode';
	@override String get manualSearch => 'Cari produk...';
	@override String get cart => 'Keranjang';
	@override String get cartEmpty => 'Keranjang kosong';
	@override String get cartEmptySub => 'Pindai produk atau cari untuk menambahkan';
	@override String get addToCart => 'Tambah';
	@override String get subtotal => 'Subtotal';
	@override String get discount => 'Diskon';
	@override String get tax => 'Pajak';
	@override String get total => 'Total';
	@override String get checkout => 'Bayar';
	@override String get amountPaid => 'Jumlah Bayar';
	@override String get change => 'Kembalian';
	@override String get paymentMethod => 'Metode Pembayaran';
	@override String get cash => 'Tunai';
	@override String get bankTransfer => 'Transfer Bank';
	@override String get eWallet => 'E-Wallet';
	@override String get qris => 'QRIS';
	@override String get exactAmount => 'Uang Pas';
	@override String get completeTransaction => 'Selesaikan Transaksi';
	@override String get transactionSuccess => 'Transaksi berhasil!';
	@override String get invoiceNumber => 'Invoice: {invoice}';
	@override String get newTransaction => 'Transaksi Baru';
	@override String get insufficientStock => 'Stok tidak cukup. Tersedia: {available}';
	@override String get productNotFound => 'Produk tidak ditemukan';
}

// Path: products
class _Translations$products$id implements Translations$products$en {
	_Translations$products$id._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Produk';
	@override String get allCategories => 'Semua';
	@override String get price => 'Harga';
	@override String get stock => 'Stok';
	@override String get outOfStock => 'Stok Habis';
	@override String get lowStock => 'Stok Menipis';
}

// Path: inventory
class _Translations$inventory$id implements Translations$inventory$en {
	_Translations$inventory$id._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inventaris';
	@override String get adjustStock => 'Sesuaikan Stok';
	@override String get currentStock => 'Saat ini: {stock} {unit}';
	@override String get quantity => 'Jumlah';
	@override String get reason => 'Alasan';
	@override String get restock => 'Restok';
	@override String get damaged => 'Rusak';
	@override String get correction => 'Koreksi';
	@override String get returned => 'Retur';
	@override String get lowStockAlerts => 'Peringatan Stok Menipis';
}

// Path: history
class _Translations$history$id implements Translations$history$en {
	_Translations$history$id._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Riwayat';
	@override String get todaySales => 'Penjualan Hari Ini';
	@override String get totalRevenue => 'Pendapatan';
	@override String get totalTransactions => 'Transaksi';
	@override String get averageTransaction => 'Rata-rata Transaksi';
	@override String get dailySummary => 'Ringkasan Harian';
	@override String get transactionDetail => 'Detail Transaksi';
	@override String get noTransactions => 'Belum ada transaksi';
}

// Path: customer
class _Translations$customer$id implements Translations$customer$en {
	_Translations$customer$id._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Lihat Produk';
	@override String get storeInfo => 'Info Toko';
	@override String get openHours => 'Buka: {open} - {close}';
	@override String get address => 'Alamat';
	@override String get priceCheck => 'Cek Harga';
	@override String get scanToCheck => 'Pindai barcode untuk cek harga & stok';
}

// Path: settings
class _Translations$settings$id implements Translations$settings$en {
	_Translations$settings$id._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pengaturan';
	@override String get language => 'Bahasa';
	@override String get english => 'English';
	@override String get indonesian => 'Bahasa Indonesia';
	@override String get store => 'Toko Saat Ini';
	@override String get switchStore => 'Ganti Toko';
	@override String get about => 'Tentang';
	@override String get version => 'Versi';
	@override String get logout => 'Keluar';
}

/// The flat map containing all translations for locale <id>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsId {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'WarungPOS',
			'common.loading' => 'Memuat...',
			'common.save' => 'Simpan',
			'common.cancel' => 'Batal',
			'common.delete' => 'Hapus',
			'common.edit' => 'Ubah',
			'common.search' => 'Cari...',
			'common.retry' => 'Coba Lagi',
			'common.noResults' => 'Tidak ada hasil',
			'common.confirm' => 'Konfirmasi',
			'common.success' => 'Berhasil',
			'common.error' => 'Kesalahan',
			'common.ok' => 'OK',
			'auth.login' => 'Masuk',
			'auth.logout' => 'Keluar',
			'auth.email' => 'Email',
			'auth.password' => 'Kata Sandi',
			'auth.loginButton' => 'Masuk',
			'auth.loginFailed' => 'Email atau kata sandi salah',
			'auth.selectStore' => 'Pilih Toko',
			'auth.selectStoreSub' => 'Pilih toko yang ingin dikelola',
			'cashier.title' => 'Kasir',
			'cashier.scanBarcode' => 'Pindai Barcode',
			'cashier.manualSearch' => 'Cari produk...',
			'cashier.cart' => 'Keranjang',
			'cashier.cartEmpty' => 'Keranjang kosong',
			'cashier.cartEmptySub' => 'Pindai produk atau cari untuk menambahkan',
			'cashier.addToCart' => 'Tambah',
			'cashier.subtotal' => 'Subtotal',
			'cashier.discount' => 'Diskon',
			'cashier.tax' => 'Pajak',
			'cashier.total' => 'Total',
			'cashier.checkout' => 'Bayar',
			'cashier.amountPaid' => 'Jumlah Bayar',
			'cashier.change' => 'Kembalian',
			'cashier.paymentMethod' => 'Metode Pembayaran',
			'cashier.cash' => 'Tunai',
			'cashier.bankTransfer' => 'Transfer Bank',
			'cashier.eWallet' => 'E-Wallet',
			'cashier.qris' => 'QRIS',
			'cashier.exactAmount' => 'Uang Pas',
			'cashier.completeTransaction' => 'Selesaikan Transaksi',
			'cashier.transactionSuccess' => 'Transaksi berhasil!',
			'cashier.invoiceNumber' => 'Invoice: {invoice}',
			'cashier.newTransaction' => 'Transaksi Baru',
			'cashier.insufficientStock' => 'Stok tidak cukup. Tersedia: {available}',
			'cashier.productNotFound' => 'Produk tidak ditemukan',
			'products.title' => 'Produk',
			'products.allCategories' => 'Semua',
			'products.price' => 'Harga',
			'products.stock' => 'Stok',
			'products.outOfStock' => 'Stok Habis',
			'products.lowStock' => 'Stok Menipis',
			'inventory.title' => 'Inventaris',
			'inventory.adjustStock' => 'Sesuaikan Stok',
			'inventory.currentStock' => 'Saat ini: {stock} {unit}',
			'inventory.quantity' => 'Jumlah',
			'inventory.reason' => 'Alasan',
			'inventory.restock' => 'Restok',
			'inventory.damaged' => 'Rusak',
			'inventory.correction' => 'Koreksi',
			'inventory.returned' => 'Retur',
			'inventory.lowStockAlerts' => 'Peringatan Stok Menipis',
			'history.title' => 'Riwayat',
			'history.todaySales' => 'Penjualan Hari Ini',
			'history.totalRevenue' => 'Pendapatan',
			'history.totalTransactions' => 'Transaksi',
			'history.averageTransaction' => 'Rata-rata Transaksi',
			'history.dailySummary' => 'Ringkasan Harian',
			'history.transactionDetail' => 'Detail Transaksi',
			'history.noTransactions' => 'Belum ada transaksi',
			'customer.title' => 'Lihat Produk',
			'customer.storeInfo' => 'Info Toko',
			'customer.openHours' => 'Buka: {open} - {close}',
			'customer.address' => 'Alamat',
			'customer.priceCheck' => 'Cek Harga',
			'customer.scanToCheck' => 'Pindai barcode untuk cek harga & stok',
			'settings.title' => 'Pengaturan',
			'settings.language' => 'Bahasa',
			'settings.english' => 'English',
			'settings.indonesian' => 'Bahasa Indonesia',
			'settings.store' => 'Toko Saat Ini',
			'settings.switchStore' => 'Ganti Toko',
			'settings.about' => 'Tentang',
			'settings.version' => 'Versi',
			'settings.logout' => 'Keluar',
			_ => null,
		};
	}
}
