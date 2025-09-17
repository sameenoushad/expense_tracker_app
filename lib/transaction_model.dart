class TransactionModel {
  final String type;
  final double amount;
  final DateTime date;
  final String? note;   

  TransactionModel({
    required this.type,
    required this.amount,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() => {
        "type": type,
        "amount": amount,
        "date": date.toIso8601String(),
        "note": note,
      };

  factory TransactionModel.fromMap(Map map) {
    return TransactionModel(
      type: map["type"],
      amount: map["amount"],
      date: DateTime.parse(map["date"]),
      note: map["note"],
    );
  }
}
