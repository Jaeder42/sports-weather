import 'package:flutter/material.dart';
import 'package:sport_weather/widgets/weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SportsWeather',
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
        home: MyHomePage(title: 'Early testing'));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Weather(),
      ),
    );
  }
}
