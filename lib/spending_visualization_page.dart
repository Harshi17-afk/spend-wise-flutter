import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';

class SpendingVisualizationPage extends StatefulWidget {
  const SpendingVisualizationPage({super.key});

  @override
  _SpendingVisualizationPageState createState() =>
      _SpendingVisualizationPageState();
}

class _SpendingVisualizationPageState extends State<SpendingVisualizationPage> {
  double transactionTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTransactions(); 
  }

  void _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> transactionsList = prefs.getStringList('transactions') ?? [];

    double totalAmount = 0.0;

    DateTime currentDate = DateTime.now();
    int currentMonth = currentDate.month;
    int currentYear = currentDate.year;

    for (var transactionString in transactionsList) {
      Map<String, dynamic> transaction = jsonDecode(transactionString);
      String transactionDateStr =
          transaction['date']; 
      DateTime transactionDate = DateTime.parse(transactionDateStr);

      if (transactionDate.month == currentMonth &&
          transactionDate.year == currentYear) {
        totalAmount += transaction['amount'];
      }
    }

    setState(() {
      transactionTotal = totalAmount; 
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAverage = Constants.spendlimit;
    double spending = transactionTotal;

    double remainingLimit = totalAverage - spending;
    if (remainingLimit < 0) {
      remainingLimit = 0;
    }

    double overSpending = spending - totalAverage;
    if (overSpending < 0) {
      overSpending = 0;
    }

    // Prepare the data for the pie chart
    Map<String, double> dataMap = {
      "Spent": spending,
      "Remaining Limit": remainingLimit,
    };

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          "Spending Visualization",
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your Spending vs Average",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              PieChart(
                dataMap: dataMap,
                chartType: ChartType.ring,
                chartRadius: MediaQuery.of(context).size.width / 3,
                colorList: const [Colors.green, Colors.red],
                legendOptions:
                    const LegendOptions(legendPosition: LegendPosition.left),
              ),
              const SizedBox(height: 30),
              Text(
                "Total Spending: ₹${transactionTotal.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Spending Limit: ₹${Constants.spendlimit.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Over Spending: ₹${overSpending.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
