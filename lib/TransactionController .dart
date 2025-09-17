import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'transaction_model.dart';

class TransactionController extends GetxController {
  var transactions = <TransactionModel>[].obs;
  late Box box;

  @override
  void onInit() {
    super.onInit();
    box = Hive.box("transactions");
    loadTransactions();
  }

  void loadTransactions() {
    transactions.value = box.values
        .map((e) => TransactionModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  
  void addTransaction(String type, double amount, {DateTime? date,String? note}) {
    final tx = TransactionModel(
      type: type,
      amount: amount,
      date: date ?? DateTime.now(), 
      note: note,
    );
    box.add(tx.toMap());
    transactions.add(tx);
  }

  void deleteTransaction(int index) {
    box.deleteAt(index);
    transactions.removeAt(index);
  }

  double get income => transactions
      .where((t) => t.type == "income")
      .fold(0.0, (s, t) => s + t.amount);

  double get expense => transactions
      .where((t) => t.type == "expense")
      .fold(0.0, (s, t) => s + t.amount);

  double get balance => income - expense;

  
  double monthIncome(int month, int year) => transactions
      .where((t) => t.type == "income" && t.date.month == month && t.date.year == year)
      .fold(0.0, (s, t) => s + t.amount);

  double monthExpense(int month, int year) => transactions
      .where((t) => t.type == "expense" && t.date.month == month && t.date.year == year)
      .fold(0.0, (s, t) => s + t.amount);
}
