class Expense {
  final String descpription;
  final double amount;
  final String category;
  final DateTime date;

  const Expense({
    required this.descpription,
    required this.amount,
    required this.category,
    required this.date,
  });

  Expense.fromJson(Map<String, dynamic> json)
      : descpription = json['descripcion'],
        amount = json['monto'],
        category = json['categoria'],
        date = DateTime.parse(json['fecha']);

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descpription,
      'monto': amount,
      'categoria': category,
      'fecha': date.toIso8601String(),
    };
  }
}
