///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'WarungPOS'
	String get appName => 'WarungPOS';

	late final Translations$common$en common = Translations$common$en._(_root);
	late final Translations$auth$en auth = Translations$auth$en._(_root);
	late final Translations$cashier$en cashier = Translations$cashier$en._(_root);
	late final Translations$products$en products = Translations$products$en._(_root);
	late final Translations$inventory$en inventory = Translations$inventory$en._(_root);
	late final Translations$history$en history = Translations$history$en._(_root);
	late final Translations$customer$en customer = Translations$customer$en._(_root);
	late final Translations$settings$en settings = Translations$settings$en._(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Search...'
	String get search => 'Search...';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'No results found'
	String get noResults => 'No results found';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'OK'
	String get ok => 'OK';
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Sign In'
	String get loginButton => 'Sign In';

	/// en: 'Invalid email or password'
	String get loginFailed => 'Invalid email or password';

	/// en: 'Select Store'
	String get selectStore => 'Select Store';

	/// en: 'Choose which store to work with'
	String get selectStoreSub => 'Choose which store to work with';
}

// Path: cashier
class Translations$cashier$en {
	Translations$cashier$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cashier'
	String get title => 'Cashier';

	/// en: 'Scan Barcode'
	String get scanBarcode => 'Scan Barcode';

	/// en: 'Search product...'
	String get manualSearch => 'Search product...';

	/// en: 'Cart'
	String get cart => 'Cart';

	/// en: 'Cart is empty'
	String get cartEmpty => 'Cart is empty';

	/// en: 'Scan a product or search to add items'
	String get cartEmptySub => 'Scan a product or search to add items';

	/// en: 'Add to Cart'
	String get addToCart => 'Add to Cart';

	/// en: 'Subtotal'
	String get subtotal => 'Subtotal';

	/// en: 'Discount'
	String get discount => 'Discount';

	/// en: 'Tax'
	String get tax => 'Tax';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Checkout'
	String get checkout => 'Checkout';

	/// en: 'Amount Paid'
	String get amountPaid => 'Amount Paid';

	/// en: 'Change'
	String get change => 'Change';

	/// en: 'Payment Method'
	String get paymentMethod => 'Payment Method';

	/// en: 'Cash'
	String get cash => 'Cash';

	/// en: 'Bank Transfer'
	String get bankTransfer => 'Bank Transfer';

	/// en: 'E-Wallet'
	String get eWallet => 'E-Wallet';

	/// en: 'QRIS'
	String get qris => 'QRIS';

	/// en: 'Exact'
	String get exactAmount => 'Exact';

	/// en: 'Complete Transaction'
	String get completeTransaction => 'Complete Transaction';

	/// en: 'Transaction completed!'
	String get transactionSuccess => 'Transaction completed!';

	/// en: 'Invoice: {invoice}'
	String get invoiceNumber => 'Invoice: {invoice}';

	/// en: 'New Transaction'
	String get newTransaction => 'New Transaction';

	/// en: 'Insufficient stock. Available: {available}'
	String get insufficientStock => 'Insufficient stock. Available: {available}';

	/// en: 'Product not found'
	String get productNotFound => 'Product not found';
}

// Path: products
class Translations$products$en {
	Translations$products$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Products'
	String get title => 'Products';

	/// en: 'All'
	String get allCategories => 'All';

	/// en: 'Price'
	String get price => 'Price';

	/// en: 'Stock'
	String get stock => 'Stock';

	/// en: 'Out of Stock'
	String get outOfStock => 'Out of Stock';

	/// en: 'Low Stock'
	String get lowStock => 'Low Stock';
}

// Path: inventory
class Translations$inventory$en {
	Translations$inventory$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Inventory'
	String get title => 'Inventory';

	/// en: 'Adjust Stock'
	String get adjustStock => 'Adjust Stock';

	/// en: 'Current: {stock} {unit}'
	String get currentStock => 'Current: {stock} {unit}';

	/// en: 'Quantity'
	String get quantity => 'Quantity';

	/// en: 'Reason'
	String get reason => 'Reason';

	/// en: 'Restock'
	String get restock => 'Restock';

	/// en: 'Damaged'
	String get damaged => 'Damaged';

	/// en: 'Correction'
	String get correction => 'Correction';

	/// en: 'Returned'
	String get returned => 'Returned';

	/// en: 'Low Stock Alerts'
	String get lowStockAlerts => 'Low Stock Alerts';
}

// Path: history
class Translations$history$en {
	Translations$history$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'History'
	String get title => 'History';

	/// en: 'Today's Sales'
	String get todaySales => 'Today\'s Sales';

	/// en: 'Revenue'
	String get totalRevenue => 'Revenue';

	/// en: 'Transactions'
	String get totalTransactions => 'Transactions';

	/// en: 'Avg. Transaction'
	String get averageTransaction => 'Avg. Transaction';

	/// en: 'Daily Summary'
	String get dailySummary => 'Daily Summary';

	/// en: 'Transaction Detail'
	String get transactionDetail => 'Transaction Detail';

	/// en: 'No transactions yet'
	String get noTransactions => 'No transactions yet';
}

// Path: customer
class Translations$customer$en {
	Translations$customer$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Browse Products'
	String get title => 'Browse Products';

	/// en: 'Store Info'
	String get storeInfo => 'Store Info';

	/// en: 'Open: {open} - {close}'
	String get openHours => 'Open: {open} - {close}';

	/// en: 'Address'
	String get address => 'Address';

	/// en: 'Price Check'
	String get priceCheck => 'Price Check';

	/// en: 'Scan barcode to check price & stock'
	String get scanToCheck => 'Scan barcode to check price & stock';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Bahasa Indonesia'
	String get indonesian => 'Bahasa Indonesia';

	/// en: 'Current Store'
	String get store => 'Current Store';

	/// en: 'Switch Store'
	String get switchStore => 'Switch Store';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'Logout'
	String get logout => 'Logout';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'WarungPOS',
			'common.loading' => 'Loading...',
			'common.save' => 'Save',
			'common.cancel' => 'Cancel',
			'common.delete' => 'Delete',
			'common.edit' => 'Edit',
			'common.search' => 'Search...',
			'common.retry' => 'Retry',
			'common.noResults' => 'No results found',
			'common.confirm' => 'Confirm',
			'common.success' => 'Success',
			'common.error' => 'Error',
			'common.ok' => 'OK',
			'auth.login' => 'Login',
			'auth.logout' => 'Logout',
			'auth.email' => 'Email',
			'auth.password' => 'Password',
			'auth.loginButton' => 'Sign In',
			'auth.loginFailed' => 'Invalid email or password',
			'auth.selectStore' => 'Select Store',
			'auth.selectStoreSub' => 'Choose which store to work with',
			'cashier.title' => 'Cashier',
			'cashier.scanBarcode' => 'Scan Barcode',
			'cashier.manualSearch' => 'Search product...',
			'cashier.cart' => 'Cart',
			'cashier.cartEmpty' => 'Cart is empty',
			'cashier.cartEmptySub' => 'Scan a product or search to add items',
			'cashier.addToCart' => 'Add to Cart',
			'cashier.subtotal' => 'Subtotal',
			'cashier.discount' => 'Discount',
			'cashier.tax' => 'Tax',
			'cashier.total' => 'Total',
			'cashier.checkout' => 'Checkout',
			'cashier.amountPaid' => 'Amount Paid',
			'cashier.change' => 'Change',
			'cashier.paymentMethod' => 'Payment Method',
			'cashier.cash' => 'Cash',
			'cashier.bankTransfer' => 'Bank Transfer',
			'cashier.eWallet' => 'E-Wallet',
			'cashier.qris' => 'QRIS',
			'cashier.exactAmount' => 'Exact',
			'cashier.completeTransaction' => 'Complete Transaction',
			'cashier.transactionSuccess' => 'Transaction completed!',
			'cashier.invoiceNumber' => 'Invoice: {invoice}',
			'cashier.newTransaction' => 'New Transaction',
			'cashier.insufficientStock' => 'Insufficient stock. Available: {available}',
			'cashier.productNotFound' => 'Product not found',
			'products.title' => 'Products',
			'products.allCategories' => 'All',
			'products.price' => 'Price',
			'products.stock' => 'Stock',
			'products.outOfStock' => 'Out of Stock',
			'products.lowStock' => 'Low Stock',
			'inventory.title' => 'Inventory',
			'inventory.adjustStock' => 'Adjust Stock',
			'inventory.currentStock' => 'Current: {stock} {unit}',
			'inventory.quantity' => 'Quantity',
			'inventory.reason' => 'Reason',
			'inventory.restock' => 'Restock',
			'inventory.damaged' => 'Damaged',
			'inventory.correction' => 'Correction',
			'inventory.returned' => 'Returned',
			'inventory.lowStockAlerts' => 'Low Stock Alerts',
			'history.title' => 'History',
			'history.todaySales' => 'Today\'s Sales',
			'history.totalRevenue' => 'Revenue',
			'history.totalTransactions' => 'Transactions',
			'history.averageTransaction' => 'Avg. Transaction',
			'history.dailySummary' => 'Daily Summary',
			'history.transactionDetail' => 'Transaction Detail',
			'history.noTransactions' => 'No transactions yet',
			'customer.title' => 'Browse Products',
			'customer.storeInfo' => 'Store Info',
			'customer.openHours' => 'Open: {open} - {close}',
			'customer.address' => 'Address',
			'customer.priceCheck' => 'Price Check',
			'customer.scanToCheck' => 'Scan barcode to check price & stock',
			'settings.title' => 'Settings',
			'settings.language' => 'Language',
			'settings.english' => 'English',
			'settings.indonesian' => 'Bahasa Indonesia',
			'settings.store' => 'Current Store',
			'settings.switchStore' => 'Switch Store',
			'settings.about' => 'About',
			'settings.version' => 'Version',
			'settings.logout' => 'Logout',
			_ => null,
		};
	}
}
