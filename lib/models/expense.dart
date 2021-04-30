class Expense {
  final String category;
  final int day;
  final int month;
  final double value;
  final int year;

  Expense({
    this.category,
    this.day,
    this.month,
    this.value,
    this.year,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      category: json['category'] as String,
      day: json['day'] as int,
      month: json['month'] as int,
      value: json['value'] as double,
      year: json['year'] as int,
    );
  }
}
