import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sport_weather/widgets/weather.dart';

class TempChart extends StatelessWidget {
  late final chanceofRain;
  final SunData sunData;
  late final startArray;

  TempChart(weatherData, this.sunData) {
    chanceofRain = _getData(weatherData, 'air_temperature');
  }
  _getData(weatherData, value) {
    // fill data with hours since sunup
    // Stop at an hour after sunset (maybe)
    var firstTime = DateTime.parse(weatherData[0]['time']);
    var firstValue = weatherData[0]['data']['instant']['details']['$value'];

    var noPoints = sunData.sunset.difference(sunData.sunrise).inHours;
    startArray = firstTime.difference(sunData.sunrise).inHours - 1;

    List<Point> data = List.generate(
        noPoints,
        (index) =>
            Point(sunData.sunrise.add(Duration(hours: index)), firstValue));
    int j = 0;
    for (int i = startArray; i < noPoints; i++) {
      var nextHour = weatherData[j]['data']['instant'];
      if (nextHour != null) {
        double chance = nextHour['details']['$value'];
        data[i] = (Point(DateTime.parse(weatherData[j]['time']), chance));
      }
      j++;
    }
    return data;
  }

  _createData() {
    return [
      charts.Series<Point, DateTime>(
        id: 'Chance of precipitation',
        colorFn: (_, index) => index! >= startArray
            ? charts.MaterialPalette.deepOrange.shadeDefault
            : charts.MaterialPalette.gray.shade900,
        domainFn: (Point point, _) => point.x,
        measureFn: (Point point, _) => point.y,
        data: chanceofRain,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: AspectRatio(
            aspectRatio: 4,
            child: Container(
                child: charts.TimeSeriesChart(
              _createData(),
              defaultRenderer:
                  charts.LineRendererConfig(includeArea: true, stacked: true),
              // Disable animations for image tests.
              animate: true,
              domainAxis: charts.DateTimeAxisSpec(
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                hour: charts.TimeFormatterSpec(
                    format: 'HH:mm', transitionFormat: 'HH:mm'),
              )),
            ))));
  }
}

class Point {
  final DateTime x;
  final double y;

  Point(this.x, this.y);
}
