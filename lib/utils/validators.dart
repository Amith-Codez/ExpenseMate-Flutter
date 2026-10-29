/// Form validators used by the add / edit expense screen.
class Validators {
  Validators._();

  static String? title(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter a title';
    if (v.length > 40) return 'Keep the title under 40 characters';
    return null;
  }

  static String? amount(String? value) {
    final v = double.tryParse((value ?? '').trim());
    if (v == null) return 'Enter a valid amount';
    if (v <= 0) return 'Amount must be greater than zero';
    if (v > 1000000) return 'Amount looks too large';
    return null;
  }
}
