enum Status {
  occupied,
  free,
  billed,
}
class TableData {
  final int number;
  late Status status;
  TableData({
    required this.number,
    required this.status,
  });
}