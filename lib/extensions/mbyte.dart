extension Mbyte on int {
  String mb() {
    return (this / 1024 / 1024).toStringAsFixed(2);
  }
}
