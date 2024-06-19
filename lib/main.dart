import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:intl/intl.dart';

void main() {
  runApp(Calc());
}

class Calc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TipCalculatorScreen(),
    );
  }
}

class TipCalculatorScreen extends StatefulWidget {
  @override
  _TipCalculatorScreenState createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final TextEditingController _costController = TextEditingController();
  double _tipPercentage = 0.15;
  bool _roundUp = false;
  String _tipAmount = '';

  void _calculateTip() {
    final String text = _costController.text;
    final double? cost = double.tryParse(text);

    if (cost == null || cost <= 0) {
      setState(() {
        _tipAmount = '\$0.00';
      });
      return;
    }

    double tip = cost * _tipPercentage;
    if (_roundUp) {
      tip = tip.ceilToDouble();
    }

    setState(() {
      _tipAmount = NumberFormat.currency(symbol: '\$').format(tip);
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _costController,
              decoration: InputDecoration(
                labelText: 'Cost of Service',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (String value) => _calculateTip(),
              onEditingComplete: () {
                _calculateTip();
                FocusScope.of(context).unfocus();
              },
            ),
            SizedBox(height: 16),
            Text(
              'Tip Percentage:',
              style: TextStyle(fontSize: 18),
            ),
            ListTile(
              title: const Text('10%'),
              leading: Radio<double>(
                value: 0.10,
                groupValue: _tipPercentage,
                onChanged: (double? value) {
                  setState(() {
                    _tipPercentage = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('15%'),
              leading: Radio<double>(
                value: 0.15,
                groupValue: _tipPercentage,
                onChanged: (double? value) {
                  setState(() {
                    _tipPercentage = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('20%'),
              leading: Radio<double>(
                value: 0.20,
                groupValue: _tipPercentage,
                onChanged: (double? value) {
                  setState(() {
                    _tipPercentage = value!;
                  });
                },
              ),
            ),
            SwitchListTile(
              title: const Text('Round Up Tip'),
              value: _roundUp,
              onChanged: (bool value) {
                setState(() {
                  _roundUp = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateTip,
              child: Text('Calculate Tip'),
            ),
            SizedBox(height: 16),
            Text(
              'Tip Amount: $_tipAmount',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

