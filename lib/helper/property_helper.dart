import 'package:money_formatter/money_formatter.dart';

class PropertyHelper {
  String get generateId {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final millisecond = now.millisecond.toString().padLeft(3, '0');
    return "$year$month$day$hour$minute$second$millisecond";
  }

  static String toIDR(String input) {
    String numericString = input.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numericString.isEmpty) return '';

    final double value = double.parse(numericString);
    MoneyFormatter fmf = MoneyFormatter(
        amount: value,
        settings: MoneyFormatterSettings(
          symbol: 'Rp',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 0,
        ));
    return fmf.output.symbolOnLeft;
  }

  static int fromIDR(String value) {
    String numericString =
        value.replaceAll('Rp', '').replaceAll(' ', '').replaceAll('.', '').trim();
    return int.tryParse(numericString) ?? 0;
  }
}
