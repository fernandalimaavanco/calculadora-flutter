import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '';
      } else if (value == '=') {
        try {
          _display = calculate(_display);
        } catch (e) {
          _display = 'Erro ao calcular';
        }
      } else {
        _display += value;
      }
    });
  }

  String calculate(String expression) {
    expression = expression.replaceAll('÷', '/').replaceAll('×', '*');

    try {
      final result = evaluate(expression);
      return result.toString();
    } catch (e) {
      return 'Erro';
    }
  }

  double evaluate(String expression) {
    try {
      final result = _parseExpression(expression);
      return result;
    } catch (e) {
      throw FormatException('Expressão inválida');
    }
  }

  double _parseExpression(String expression) {
    final exp = parseMultiplicationDivision(expression);
    return parseAdditionSubtraction(exp);
  }

  String parseMultiplicationDivision(String expression) {
    final exp = RegExp(r'(\d+(\.\d+)?)\s*([*/])\s*(\d+(\.\d+)?)');
    String result = expression;
    while (exp.hasMatch(result)) {
      result = result.replaceAllMapped(exp, (match) {
        final left = double.parse(match.group(1)!);
        final op = match.group(3)!;
        final right = double.parse(match.group(4)!);

        if (op == '*') {
          return (left * right).toString();
        } else if (op == '/') {
          return (left / right).toString();
        } else {
          return match.group(0)!;
        }
      });
    }
    return result;
  }

  double parseAdditionSubtraction(String expression) {
    final exp = RegExp(r'(\d+(\.\d+)?)\s*([+-])\s*(\d+(\.\d+)?)');
    String result = expression;
    while (exp.hasMatch(result)) {
      result = result.replaceAllMapped(exp, (match) {
        final left = double.parse(match.group(1)!);
        final op = match.group(3)!;
        final right = double.parse(match.group(4)!);

        if (op == '+') {
          return (left + right).toString();
        } else if (op == '-') {
          return (left - right).toString();
        } else {
          return match.group(0)!;
        }
      });
    }
    return double.parse(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _display,
                  style: TextStyle(
                      fontSize: 48.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('÷'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('×'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton('C'),
                    _buildButton('0'),
                    _buildButton('='),
                    _buildButton('+'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(value),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20.0)),
          child: Text(
            value,
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
