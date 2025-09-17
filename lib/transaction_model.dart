
class TransactionModel {
  final String type; 
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.type,
    required this.amount,
    required this.date,
  });

  
  Map<String, dynamic> toMap() =>
      {"type": type, "amount": amount, "date": date.toIso8601String()};

  
  factory TransactionModel.fromMap(Map map) {
    return TransactionModel(
      type: map["type"],
      amount: map["amount"],
      date: DateTime.parse(map["date"]),
    );
  }
}
