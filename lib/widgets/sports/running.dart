import 'package:flutter/material.dart';
import 'package:sport_weather/widgets/rain_chart.dart';
import 'package:sport_weather/widgets/current.dart';
import 'package:sport_weather/widgets/sun_chart.dart';

import '../temp_chart.dart';
import '../weather.dart';

class Running extends StatefulWidget {
  final dynamic weatherData;
  final SunData sunData;
  Running(this.weatherData, this.sunData);
  @override
  State<StatefulWidget> createState() {
    return _RunningState(weatherData, this.sunData);
  }
}

class _RunningState extends State<Running> {
  dynamic weatherData;
  SunData sunData;
  _RunningState(this.weatherData, this.sunData);

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
                SunChart(sunData),
                Text('Rain'),
                RainChart(weatherData, sunData),
                Text('Temperature'),
                TempChart(weatherData, sunData)
              ])),
        ],
      ),
    );
  }
}
