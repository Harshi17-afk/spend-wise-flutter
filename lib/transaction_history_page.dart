import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  _TransactionHistoryPageState createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  Map<String, List<Map<String, dynamic>>> monthlyTransactions = {};
  double transactionTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> transactionsList = prefs.getStringList('transactions') ?? [];

    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    double totalAmount = 0.0;

    DateTime currentDate = DateTime.now();
    int currentMonth = currentDate.month;
    int currentYear = currentDate.year;

    for (var transactionString in transactionsList) {
      Map<String, dynamic> transaction = jsonDecode(transactionString);
      DateTime date = DateTime.parse(transaction['date']);
      String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";

      if (groupedTransactions[monthKey] == null) {
        groupedTransactions[monthKey] = [];
      }
      groupedTransactions[monthKey]!.add(transaction);

      String transactionDateStr = transaction['date'];
      DateTime transactionDate = DateTime.parse(transactionDateStr);
      if (transactionDate.month == currentMonth &&
          transactionDate.year == currentYear) {
        totalAmount += transaction['amount'];
      }
    }

    setState(() {
      monthlyTransactions = groupedTransactions;
      transactionTotal = totalAmount;
    });
  }

  String formatMonthName(String month) {
    List<String> parts = month.split('-');
    String year = parts[0];
    String monthNumber = parts[1];

    DateTime date = DateTime(int.parse(year), int.parse(monthNumber));
    return DateFormat('MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          "Transaction History",
          textScaleFactor: 1.0,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.redAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: monthlyTransactions.isEmpty
          ? const Center(child: Text("No transactions available"))
          : ListView(
              children: monthlyTransactions.entries.map((entry) {
                String month = entry.key;
                List<Map<String, dynamic>> transactions = entry.value;

                return ExpansionTile(
                  title: Text("Month: ${formatMonthName(month)}"),
                  subtitle: Text(
                      "Amount Spent: ₹${transactionTotal.toStringAsFixed(2)}"),
                  children: transactions.map((transaction) {
                    return ListTile(
                      title: Text("Amount: ₹${transaction['amount']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: ${transaction['date']}"),
                          const SizedBox(height: 5),
                          Text(
                              "Merchant: ${transaction['qrData'] ?? 'No QR Data'}"),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
    );
  }
}
