/// Utilitários de data sem dependências externas.
class AppDateUtils {
  AppDateUtils._();

  static DateTime onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static String format(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  /// Diferença em dias entre [d] e hoje (negativo = passado).
  static int daysFromToday(DateTime d) {
    final today = onlyDate(DateTime.now());
    return onlyDate(d).difference(today).inDays;
  }

  static String relativeLabel(DateTime d) {
    final diff = daysFromToday(d);
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Amanhã';
    if (diff == -1) return 'Ontem';
    if (diff < 0) return 'Atrasada ${-diff} dias';
    if (diff <= 7) return 'Em $diff dias';
    return format(d);
  }
}

