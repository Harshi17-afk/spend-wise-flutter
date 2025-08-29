import 'package:flutter/material.dart';
import 'qr_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';

class ThresholdDialog extends StatefulWidget {
  final String scanData;
  final QRViewController controller;
  final VoidCallback onConfirm;

  const ThresholdDialog({
    super.key,
    required this.scanData,
    required this.controller,
    required this.onConfirm,
  });

  @override
  _ThresholdDialogState createState() => _ThresholdDialogState();
}

class _ThresholdDialogState extends State<ThresholdDialog> {
  double transactionTotal = 0.0;
  bool isAboveThreshold = false;

  @override
  void initState() {
    super.initState();
    _calculateTransactionTotal();
  }

  Future<void> _calculateTransactionTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> transactionsList = prefs.getStringList('transactions') ?? [];

    double totalAmount = 0.0;
    for (var transactionString in transactionsList) {
      Map<String, dynamic> transaction = jsonDecode(transactionString);
      totalAmount += transaction['amount'];
    }

    setState(() {
      transactionTotal = totalAmount;
      isAboveThreshold = transactionTotal > Constants.spendlimit;
    });
  }

  @override
  Widget build(BuildContext context) {
    String message = isAboveThreshold
        ? "Above Threshold Expenditure"
        : "Below Threshold Expenditure";

    return AlertDialog(
      title: const Text("Expenditure Check"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            widget.controller.dispose();
            Navigator.pop(context);
            widget.onConfirm();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}