import 'package:expence_tracker_app/TransactionController%20.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final c = Get.put(TransactionController());
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController(); 

  int? selectedMonth;
  int selectedYear = 2025;

  final months = const {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Month Selector
          DropdownButton<int>(
            value: selectedMonth,
            hint: const Text("Select Month"),
            items: months.entries
                .map(
                  (m) => DropdownMenuItem(value: m.key, child: Text(m.value)),
                )
                .toList(),
            onChanged: (val) => setState(() => selectedMonth = val),
          ),

          const SizedBox(height: 10),

          // Monthly Summary
          Obx(() {
            if (selectedMonth == null) {
              return const Text(
                "Please select a month",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              );
            }
            final income = c.monthIncome(selectedMonth!, selectedYear);
            final expense = c.monthExpense(selectedMonth!, selectedYear);
            return Column(
              children: [
                Text("Income: $income"),
                Text("Expense: $expense"),
                Text(
                  "Balance: ${income - expense}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            );
          }),

          const Divider(),

          // Transaction List
          Expanded(
            child: Obx(() {
              if (selectedMonth == null) {
                return const Center(
                  child: Text("Select a month to view transactions"),
                );
              }

              final monthTx = c.transactions
                  .where(
                    (tx) =>
                        tx.date.month == selectedMonth &&
                        tx.date.year == selectedYear,
                  )
                  .toList();

              if (monthTx.isEmpty)
                return const Center(child: Text("No transactions found"));

              return ListView.builder(
                itemCount: monthTx.length,
                itemBuilder: (_, i) {
                  final tx = monthTx[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        tx.type == "income"
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: tx.type == "income" ? Colors.green : Colors.red,
                      ),
                      title: Text("${tx.type} - ${tx.amount}"),
                      subtitle: Text(
                        "${tx.date.toString().split(" ")[0]} | ${tx.note ?? ''}",
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            c.deleteTransaction(c.transactions.indexOf(tx)),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // Floating button
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (selectedMonth == null) {
            Get.snackbar("Select Month", "Please select a month first!");
            return;
          }
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Add Transaction"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountCtrl,
                    decoration: const InputDecoration(hintText: "Enter Amount"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteCtrl,
                    decoration: const InputDecoration(hintText: "Enter Note"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (amountCtrl.text.isNotEmpty) {
                      c.addTransaction(
                        "income",
                        double.tryParse(amountCtrl.text) ?? 0.0,
                        date: DateTime(
                          selectedYear,
                          selectedMonth!,
                          DateTime.now().day,
                        ),
                        note: noteCtrl.text,
                      );
                      amountCtrl.clear();
                      noteCtrl.clear();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Add Income"),
                ),
                TextButton(
                  onPressed: () {
                    if (amountCtrl.text.isNotEmpty) {
                      c.addTransaction(
                        "expense",
                        double.tryParse(amountCtrl.text) ?? 0.0,
                        date: DateTime(
                          selectedYear,
                          selectedMonth!,
                          DateTime.now().day,
                        ),
                        note: noteCtrl.text,
                      );
                      amountCtrl.clear();
                      noteCtrl.clear();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Add Expense"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
