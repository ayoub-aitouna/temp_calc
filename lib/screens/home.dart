import 'dart:math';

import 'package:flutter/material.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Calculator(),
      ),
    );
  }
}

class HistoryItem {
  final String expression;
  final String result;

  HistoryItem(this.expression, this.result);
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentNumber = "";
  String _currentExpression = "";
  double _firstNumber = 0;
  String _operation = "";
  bool _isNewNumber = true;
  bool _isScientificMode = false;
  bool _isRadianMode = true;
  List<HistoryItem> _history = [];
  bool _showHistory = false;

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void _addToHistory(String expression, String result) {
    setState(() {
      _history.insert(0, HistoryItem(expression, result));
      // Keep last 100 calculations
      if (_history.length > 100) {
        _history.removeLast();
      }
    });
  }

  void _useHistoryItem(HistoryItem item) {
    setState(() {
      _currentNumber = item.result;
      _output = item.result;
      _showHistory = false;
      _isNewNumber = true;
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  void _scientificOperation(String operation) {
    if (_currentNumber.isEmpty) return;

    double number = double.parse(_currentNumber);
    double result = 0;
    String expression = "";

    try {
      switch (operation) {
        case "sin":
          result = _isRadianMode ? sin(number) : sin(_toRadians(number));
          expression = "sin($number)";
          break;
        case "cos":
          result = _isRadianMode ? cos(number) : cos(_toRadians(number));
          expression = "cos($number)";
          break;
        case "tan":
          result = _isRadianMode ? tan(number) : tan(_toRadians(number));
          expression = "tan($number)";
          break;
        case "log":
          result = log(number) / ln10;
          expression = "log($number)";
          break;
        case "ln":
          result = log(number);
          expression = "ln($number)";
          break;
        case "√":
          result = sqrt(number);
          expression = "√($number)";
          break;
        case "x²":
          result = pow(number, 2).toDouble();
          expression = "($number)²";
          break;
        case "x³":
          result = pow(number, 3).toDouble();
          expression = "($number)³";
          break;
        case "1/x":
          if (number == 0) {
            _output = "Error";
            return;
          }
          result = 1 / number;
          expression = "1/($number)";
          break;
        case "e^x":
          result = exp(number);
          expression = "e^($number)";
          break;
      }

      _output = result.toString();
      if (_output.endsWith(".0")) {
        _output = _output.substring(0, _output.length - 2);
      }
      _addToHistory(expression, _output);
      _currentNumber = _output;
      _isNewNumber = true;
    } catch (e) {
      _output = "Error";
    }
    setState(() {});
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentNumber = "";
        _currentExpression = "";
        _firstNumber = 0;
        _operation = "";
        _isNewNumber = true;
      } else if (buttonText == "±") {
        if (_currentNumber.isNotEmpty) {
          if (_currentNumber.startsWith("-")) {
            _currentNumber = _currentNumber.substring(1);
          } else {
            _currentNumber = "-$_currentNumber";
          }
          _output = _currentNumber;
        }
      } else if (buttonText == ".") {
        if (!_currentNumber.contains(".")) {
          _currentNumber = _currentNumber.isEmpty ? "0." : "$_currentNumber.";
          _output = _currentNumber;
        }
      } else if (buttonText == "π") {
        _currentNumber = pi.toString();
        _output = _currentNumber;
        _isNewNumber = true;
      } else if (buttonText == "e") {
        _currentNumber = e.toString();
        _output = _currentNumber;
        _isNewNumber = true;
      } else if (buttonText == "Rad|Deg") {
        _isRadianMode = !_isRadianMode;
      } else if (["+", "-", "×", "÷", "^"].contains(buttonText)) {
        if (_currentNumber.isNotEmpty) {
          _firstNumber = double.parse(_currentNumber);
          _operation = buttonText;
          _currentExpression = "$_firstNumber $_operation";
          _isNewNumber = true;
        }
      } else if (buttonText == "=") {
        if (_operation.isNotEmpty && _currentNumber.isNotEmpty) {
          double secondNumber = double.parse(_currentNumber);
          double result = 0;
          _currentExpression += " $secondNumber =";

          switch (_operation) {
            case "+":
              result = _firstNumber + secondNumber;
              break;
            case "-":
              result = _firstNumber - secondNumber;
              break;
            case "×":
              result = _firstNumber * secondNumber;
              break;
            case "÷":
              if (secondNumber != 0) {
                result = _firstNumber / secondNumber;
              } else {
                _output = "Error";
                return;
              }
              break;
            case "^":
              result = pow(_firstNumber, secondNumber).toDouble();
              break;
          }

          _output = result.toString();
          if (_output.endsWith(".0")) {
            _output = _output.substring(0, _output.length - 2);
          }
          _addToHistory(_currentExpression, _output);
          _currentNumber = _output;
          _currentExpression = "";
          _operation = "";
        }
      } else if ([
        "sin",
        "cos",
        "tan",
        "log",
        "ln",
        "√",
        "x²",
        "x³",
        "1/x",
        "e^x"
      ].contains(buttonText)) {
        _scientificOperation(buttonText);
      } else {
        if (_isNewNumber) {
          _currentNumber = buttonText;
          _isNewNumber = false;
        } else {
          _currentNumber += buttonText;
        }
        _output = _currentNumber;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? color, double? flex}) {
    return Expanded(
      flex: (flex ?? 1).toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[850],
            padding: const EdgeInsets.all(12.0),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryView() {
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _clearHistory,
                  child: const Text('Clear History'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _history.isEmpty
                ? const Center(child: Text('No history yet'))
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_history[index].expression),
                        subtitle: Text(
                          _history[index].result,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => _useHistoryItem(_history[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        actions: [
          IconButton(
            icon: Icon(_isScientificMode ? Icons.science : Icons.calculate),
            onPressed: () {
              setState(() {
                _isScientificMode = !_isScientificMode;
                _showHistory = false;
              });
            },
          ),
          IconButton(
            icon: Icon(_showHistory ? Icons.keyboard : Icons.history),
            onPressed: () {
              setState(() {
                _showHistory = !_showHistory;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_currentExpression.isNotEmpty)
                  Text(
                    _currentExpression,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.grey[400],
                    ),
                  ),
                Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.0),
          Expanded(
            child: _showHistory
                ? _buildHistoryView()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_isScientificMode) ...[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              _buildButton("sin", color: Colors.blue[700]),
                              _buildButton("cos", color: Colors.blue[700]),
                              _buildButton("tan", color: Colors.blue[700]),
                              _buildButton("Rad|Deg", color: Colors.blue[700]),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              _buildButton("log", color: Colors.blue[700]),
                              _buildButton("ln", color: Colors.blue[700]),
                              _buildButton("e^x", color: Colors.blue[700]),
                              _buildButton("^", color: Colors.orange),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              _buildButton("√", color: Colors.blue[700]),
                              _buildButton("x²", color: Colors.blue[700]),
                              _buildButton("x³", color: Colors.blue[700]),
                              _buildButton("1/x", color: Colors.blue[700]),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              _buildButton("π", color: Colors.blue[700]),
                              _buildButton("e", color: Colors.blue[700]),
                              _buildButton("±", color: Colors.blue[700]),
                              _buildButton(".", color: Colors.blue[700]),
                            ],
                          ),
                        ),
                      ],
                      Column(
                        children: [
                          Row(
                            children: <Widget>[
                              _buildButton("7"),
                              _buildButton("8"),
                              _buildButton("9"),
                              _buildButton("÷", color: Colors.blue),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _buildButton("4"),
                              _buildButton("5"),
                              _buildButton("6"),
                              _buildButton("×", color: Colors.blue),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _buildButton("1"),
                              _buildButton("2"),
                              _buildButton("3"),
                              _buildButton("-", color: Colors.blue),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _buildButton("C", color: Colors.green),
                              _buildButton("0"),
                              _buildButton("=", color: Colors.green),
                              _buildButton("+", color: Colors.blue),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
