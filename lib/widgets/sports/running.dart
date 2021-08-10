import 'package:flutter/material.dart';
import 'package:sport_weather/widgets/rain_chart.dart';
import 'package:sport_weather/widgets/current.dart';

import '../temp_chart.dart';

class Running extends StatefulWidget {
  final dynamic weatherData;
  Running(this.weatherData);
  @override
  State<StatefulWidget> createState() {
    return _RunningState(weatherData);
  }
}

class _RunningState extends State<Running> {
  dynamic weatherData;
  _RunningState(this.weatherData);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Running',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Current(weatherData),
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(children: [
                Text(
                  'Prognosis',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  height: 5,
                ),
                Text('Rain'),
                RainChart(weatherData),
                Text('Temperature'),
                TempChart(weatherData)
              ])),
        ],
      ),
    );
  }
}
