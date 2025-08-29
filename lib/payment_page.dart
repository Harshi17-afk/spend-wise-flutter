import 'package:expenditure_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaymentPage extends StatelessWidget {
  final String qrData;

  const PaymentPage({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController passcodeController = TextEditingController();

    // Save transaction to SharedPreferences
    void saveTransaction(double amount) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> transactions = prefs.getStringList('transactions') ?? [];

      Map<String, dynamic> transaction = {
        'amount': amount,
        'date': DateTime.now().toIso8601String(),
        'qrData': qrData,
      };

      transactions.add(jsonEncode(transaction));

      await prefs.setStringList('transactions', transactions);
    }

    // Show incorrect passcode dialog
    void showIncorrectPasscodeDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Incorrect Passcode"),
          content: const Text("The passcode you entered is incorrect. Please try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    // Show payment success dialog
    void showPaymentSuccessDialog(double amount) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              Text("Payment of ₹$amount succeeded!",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                saveTransaction(amount); 

                Navigator.of(context).popUntil((route) => route.isFirst); 
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    // Show confirmation dialog when threshold is crossed
    void showThresholdConfirmationDialog(double amount) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Payment"),
          content: const Text("You have already exceeded your threshold. Do you still want to proceed with this payment?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close threshold confirmation dialog
                showPaymentSuccessDialog(amount); // Show the success dialog if confirmed
              },
              child: const Text("Yes, Proceed"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without payment
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      );
    }

    void showPasscodeDialog(double amount) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> transactionsList = prefs.getStringList('transactions') ?? [];
      double totalAmount = 0.0;

      // Calculate total spending
      for (var transactionString in transactionsList) {
        Map<String, dynamic> transaction = jsonDecode(transactionString);
        totalAmount += transaction['amount'];
      }

      // Check if the spending exceeds the threshold
      bool isAboveThreshold = totalAmount > Constants.spendlimit;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enter Passcode"),
          content: TextField(
            controller: passcodeController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Passcode',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String enteredPasscode = passcodeController.text;
                if (enteredPasscode == Constants.passcode) {
                  Navigator.of(context).pop(); // Close passcode dialog
                  
                  if (isAboveThreshold) {
                    // Show confirmation dialog if threshold is crossed
                    showThresholdConfirmationDialog(amount);
                  } else {
                    // Show success dialog if no threshold issue
                    showPaymentSuccessDialog(amount);
                  }
                } else {
                  showIncorrectPasscodeDialog(); 
                }
              },
              child: const Text("Confirm Payment"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without confirming payment
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          "Payment Page",
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
              colors: [Colors.pink, Colors.red],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("QR Code Data:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(qrData,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text("Enter Amount to Pay:", style: TextStyle(fontSize: 16)),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String amountText = amountController.text;
                  double? amount = double.tryParse(amountText);

                  if (amount != null && amount > 0) {
                    showPasscodeDialog(amount); 
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid amount")),
                    );
                  }
                },
                child: const Text("Confirm Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
