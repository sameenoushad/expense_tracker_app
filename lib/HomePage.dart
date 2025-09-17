// home_page.dart
import 'package:expence_tracker_app/TransactionController%20.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePage extends StatelessWidget {
  final TransactionController c = Get.put(TransactionController());

  final amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text( "Expense Tracker app")),
      body: Column(
        children: [
          Obx(() => Column(
                children: [
                  Text("Income: ${c.income}"),
                  Text("Expense: ${c.expense}"),
                  Text("Balance: ${c.balance}"),
                ],
              )),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: c.transactions.length,
                  itemBuilder: (_, i) {
                    final tx = c.transactions[i];
                    return ListTile(
                      title: Text("${tx.type} - ${tx.amount}"),
                      subtitle: Text(tx.date.toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => c.deleteTransaction(i),
                      ),
                    );
                  },
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("Add Transaction"),
                    content: TextField(
                      controller: amountCtrl,
                      decoration: const InputDecoration(
                        hintText: "Enter Amount",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            c.addTransaction("income",
                                double.parse(amountCtrl.text));
                            amountCtrl.clear();
                            Navigator.pop(context);
                          },
                          child: const Text("Add Income")),
                      TextButton(
                          onPressed: () {
                            c.addTransaction("expense",
                                double.parse(amountCtrl.text));
                            amountCtrl.clear();
                            Navigator.pop(context);
                          },
                          child: const Text("Add Expense")),
                    ],
                  ));
        },
      ),
    );
  }
}
