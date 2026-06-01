import 'package:intl/intl.dart';

final _idrFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

final _dateFormatter = DateFormat('dd MMM yyyy', 'id_ID');
final _timeFormatter = DateFormat('HH:mm', 'id_ID');
final _dateTimeFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

String formatCurrency(double amount) => _idrFormatter.format(amount);

String formatDate(DateTime date) => _dateFormatter.format(date);

String formatTime(DateTime date) => _timeFormatter.format(date);

String formatDateTime(DateTime date) => _dateTimeFormatter.format(date);

String formatDateShort(DateTime date) =>
    DateFormat('dd/MM/yyyy').format(date);
