import 'package:flutter/material.dart';
import 'transaction_utils.dart';

class PayMobilePage extends StatefulWidget {
  const PayMobilePage({super.key});

  @override
  State<PayMobilePage> createState() => _PayMobilePageState();
}

class _PayMobilePageState extends State<PayMobilePage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Future<bool> _confirmAboveThousand(double amount) async {
    if (amount <= 1000) return true;
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Confirm Payment'),
            content: Text('This transaction is above ₹1000. Do you want to continue?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _verifyPinIfNeeded(double amount) async {
    final settings = await TransactionUtils.loadSettings();
    final total = await TransactionUtils.totalForCurrentPeriod(settings.period);
    if (settings.limitAmount <= 0) return true;
    if (total + amount <= settings.limitAmount) return true;
    final pinController = TextEditingController();
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Enter Emergency PIN'),
            content: TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Emergency PIN'),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.pop(context, pinController.text == settings.emergencyPin && pinController.text.isNotEmpty),
                child: const Text('Continue'),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect PIN or cancelled')));
    }
    return ok;
  }

  Future<void> _proceed() async {
    final mobile = _mobileController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    if (mobile.length != 10 || int.tryParse(mobile) == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid 10-digit mobile number')));
      return;
    }
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }
    if (!await _confirmAboveThousand(amount)) return;
    if (!await _verifyPinIfNeeded(amount)) return;
    await TransactionUtils.saveTransaction(amount: amount, mobile: mobile);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          Text('Payment of ₹${amount.toStringAsFixed(2)} to +91-$mobile succeeded!'),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
    _mobileController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay by Mobile Number')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mobile Number', hintText: '10-digit number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (₹)', hintText: 'e.g. 1500'),
            ),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _proceed, child: const Text('Proceed to Pay'))),
          ],
        ),
      ),
    );
  }
}


