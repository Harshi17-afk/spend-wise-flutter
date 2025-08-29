import 'package:flutter/material.dart';
import 'qr_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'qr_view.dart';
import 'pay_mobile_page.dart';
import 'settings_page.dart';
import 'payment_page.dart';
import 'transaction_history_page.dart';
import 'spending_visualization_page.dart';
import 'threshold_dialog.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _openQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(onQRViewCreated: _onQRViewCreated),
      ),
    );
  }

  void _showThresholdDialog(String scanData, QRViewController controller) {
    showDialog(
      context: context,
      builder: (context) => ThresholdDialog(
        scanData: scanData,
        controller: controller,
        onConfirm: () => _navigateToPaymentPage(scanData),
      ),
    );
  }

  void _navigateToPaymentPage(String scanData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(qrData: scanData),
      ),
    );

    if (result != null && result is double) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> transactionsList = prefs.getStringList('transactions') ?? [];
      Map<String, dynamic> newTransaction = {
        'amount': result,
        'date': DateTime.now().toIso8601String(),
      };
      transactionsList.add(jsonEncode(newTransaction));
      await prefs.setStringList('transactions', transactionsList);
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      _showThresholdDialog(scanData.code!, controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    String copyright = "\u00a9 Group10";

    final buttonPrimary = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          "SPEND WISE",
          textScaleFactor: 1.0,
        ),
        backgroundColor: Colors.lightBlue,
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
      body: Stack(
        children: [
          // Background and main content
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue,
                  Colors.blueGrey,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: buttonPrimary,
                        onPressed: _openQRScanner,
                        child: const Text("Scan to Pay"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: buttonPrimary,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PayMobilePage()),
                        ),
                        child: const Text("Pay by Mobile"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: buttonPrimary,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransactionHistoryPage(),
                      ),
                    ),
                    child: const Text("Transaction History"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: buttonPrimary,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpendingVisualizationPage(),
                      ),
                    ),
                    child: const Text("Visualize Spending"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: buttonPrimary,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    ),
                    child: const Text("Settings"),
                  ),
                ],
              ),
            ),
          ),
          // Copyright text positioned at the bottom-left corner
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                copyright,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
