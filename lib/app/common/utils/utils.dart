class Utils {
  static final List<String> _abbreviatedMonths = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"];
 

  static String formatSeconds(int seconds) {
    int hours = (seconds / 3600).floor();
    int minutes = ((seconds % 3600) / 60).floor();
    int remainingSeconds = seconds % 60;
    return '${seconds >= 3600 ? "${hours.toString().padLeft(2, '0')}:" : ''}${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  static String monthFromIndex(int index) => _abbreviatedMonths[index-1];
}
