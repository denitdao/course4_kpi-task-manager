import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter lab 1'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  String _letter = '';
  double _sliderValue = 0;
  final Random r = Random();

  void _getNewLetter() {
    setState(() {
      _letter = _getOrderedChar(r.nextInt(_sliderValue.toInt() + 1));
    });
  }

  void _updateRange(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  String _getOrderedChar(int increment) {
    return String.fromCharCode('a'.codeUnitAt(0) + increment);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Random letter is:',
            ),
            Text(
              _letter,
              style: Theme.of(context).textTheme.headline4,
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 6,
              divisions: 6,
              label: _getOrderedChar(_sliderValue.toInt()),
              onChanged: _updateRange
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getNewLetter,
        tooltip: 'Roll',
        child: const Icon(Icons.repeat),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
