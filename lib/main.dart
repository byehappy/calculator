import 'package:calc/theme.dart';
import 'package:calc/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pr2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final List<String> buttonText = [
  "+/-",
  '0',
  '.',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9'
];
final List<String> znakiFirst = ['=', '+', '-', 'x'];
final List<String> znakiSecond = ['e', '()', 'C', '/'];
final List<String> znakiThird = ['|x|', '^', '!', '⌫'];

class _MyHomePageState extends State<MyHomePage> {
  String _output = '';

  void _updateOutput(String value) {
    setState(() {
      _output += value;
    });
  }

  void toggleSign() {
    setState(() {
      if (_output.isNotEmpty) {
        if (_output.startsWith('-')) {
          _output = _output.substring(1); // Удаляем знак минуса
        } else {
          _output = '-$_output'; // Добавляем знак минуса
        }
      }
    });
  }

  void toggleBrackets() {
    setState(() {
      if (_output.contains('(') && _output.contains(')')) {
        // Если строка содержит и открывающую, и закрывающую скобку,
        // удаляем обе скобки
        _output = _output.replaceAll('(', '');
        _output = _output.replaceAll(')', '');
      } else {
        // Если строка не содержит обе скобки, добавляем их
        _output = '($_output)';
      }
    });
  }

  void _calculateAbs() {
    setState(() {
      _output = double.parse(_output).abs().toString();
    });
  }

  int factorial(double k) {
    if (k < 0) {
      throw ArgumentError.value(k);
    }
    if (k == 0) {
      return 1;
    }
    var result = k.toInt(); // Преобразуем к целому числу
    k--;
    while (k > 1) {
      result *= k.toInt(); // Преобразуем к целому числу
      k--;
    }
    return result;
  }

  equalPressed() {
    var userInputFC =
        _output.replaceAll("x", "*").replaceAll("e", "2.718281828459045");
    Parser p = Parser();
    Expression exp = p.parse(userInputFC);
    ContextModel ctx = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, ctx);
    setState(() {
      _output = eval.toString();
    });
  }

  void _clear() {
    setState(() {
      _output = '';
    });
  }

  void _backspace() {
    setState(() {
      if (_output.isNotEmpty) {
        _output = _output.substring(0, _output.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    _output,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          overflow: TextOverflow.clip,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: znakiThird.map((text) {
              return CustomAppButton(
                onPressed: () {
                  if (text == '⌫') {
                    _backspace();
                  } else if (text == '|x|') {
                    _calculateAbs();
                  } else if (text == '!') {
                    setState(() {
                      _output = factorial(double.parse(_output)).toString();
                    });
                  } else {
                    _updateOutput(text);
                  }
                },
                text: text,
                textColor: MaterialTheme.lightScheme().primary,
                backgroundColor: MaterialTheme.lightScheme().secondaryContainer,
                minSize: MaterialStateProperty.all(const Size(80, 40)),
                maxSize: MaterialStateProperty.all(const Size(80, 40)),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: znakiSecond.map((text) {
              return CustomAppButton(
                onPressed: () {
                  if (text == 'C') {
                    _clear();
                  } else if (text == '()') {
                    toggleBrackets();
                  } else {
                    _updateOutput(text);
                  }
                },
                text: text,
                backgroundColor: MaterialTheme.lightScheme().inverseSurface,
                minSize: MaterialStateProperty.all(const Size(80, 80)),
                maxSize: MaterialStateProperty.all(const Size(80, 80)),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 280,
                    child: Wrap(
                      verticalDirection: VerticalDirection.up,
                      spacing: 20,
                      runSpacing: 15,
                      children: buttonText.map((text) {
                        return (CustomAppButton(
                          onPressed: () {
                            if (text == '+/-') {
                              toggleSign();
                            } else {
                              _updateOutput(text);
                            }
                          },
                          text: text,
                          textColor: MaterialTheme.lightScheme().surfaceTint,
                          minSize:
                              MaterialStateProperty.all(const Size(80, 80)),
                          maxSize:
                              MaterialStateProperty.all(const Size(80, 80)),
                        ));
                      }).toList(),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                    verticalDirection: VerticalDirection.up,
                    children: znakiFirst.map((text) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: (CustomAppButton(
                          onPressed: () {
                            if (text == '=') {
                              equalPressed();
                            } else {
                              _updateOutput(text);
                            }
                          },
                          text: text,
                          backgroundColor:
                              MaterialTheme.lightScheme().inverseSurface,
                          minSize:
                              MaterialStateProperty.all(const Size(80, 80)),
                          maxSize:
                              MaterialStateProperty.all(const Size(80, 80)),
                        )),
                      );
                    }).toList()),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
