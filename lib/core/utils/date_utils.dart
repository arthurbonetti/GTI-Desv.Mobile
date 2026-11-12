/// Utilitários de data sem dependências externas.
class AppDateUtils {
  AppDateUtils._();

  static DateTime onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static String format(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  /// Diferença em dias calendário entre [d] e hoje (negativo = passado).
  ///
  /// Usa UTC para evitar truncamento incorreto de `inDays` em transições de
  /// horário de verão (dias com 23h ou 25h).
  static int daysFromToday(DateTime d) {
    final now = DateTime.now();
    final todayUtc = DateTime.utc(now.year, now.month, now.day);
    final targetUtc = DateTime.utc(d.year, d.month, d.day);
    return targetUtc.difference(todayUtc).inDays;
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

