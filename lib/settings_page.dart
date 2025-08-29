import 'package:flutter/material.dart';
import 'transaction_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  LimitPeriod _period = LimitPeriod.day;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await TransactionUtils.loadSettings();
    setState(() {
      _period = s.period;
      _limitController.text = s.limitAmount == 0 ? '' : s.limitAmount.toStringAsFixed(0);
      _pinController.text = s.emergencyPin;
    });
  }

  Future<void> _save() async {
    final limit = double.tryParse(_limitController.text) ?? 0.0;
    await TransactionUtils.saveSettings(SpendSettings(period: _period, limitAmount: limit, emergencyPin: _pinController.text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Spending Limit Period'),
            const SizedBox(height: 8),
            SegmentedButton<LimitPeriod>(
              segments: const [
                ButtonSegment(value: LimitPeriod.day, label: Text('Daily')),
                ButtonSegment(value: LimitPeriod.week, label: Text('Weekly')),
                ButtonSegment(value: LimitPeriod.month, label: Text('Monthly')),
              ],
              selected: <LimitPeriod>{_period},
              onSelectionChanged: (s) => setState(() => _period = s.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Limit Amount (₹)', hintText: 'e.g. 2000'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Emergency PIN', hintText: '4-6 digits'),
              obscureText: true,
            ),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _save, child: const Text('Save Settings'))),
          ],
        ),
      ),
    );
  }
}


