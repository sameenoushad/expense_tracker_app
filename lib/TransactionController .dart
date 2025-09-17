// transaction_controller.dart
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

  void addTransaction(String type, double amount) {
    final tx = TransactionModel(
      type: type,
      amount: amount,
      date: DateTime.now(),
    );
    box.add(tx.toMap());
    transactions.add(tx);
  }

  void deleteTransaction(int index) {
    box.deleteAt(index);
    transactions.removeAt(index);
  }

  double get income =>
      transactions.where((t) => t.type == "income").fold(0.0, (s, t) => s + t.amount);

  double get expense =>
      transactions.where((t) => t.type == "expense").fold(0.0, (s, t) => s + t.amount);

  double get balance => income - expense;
}
