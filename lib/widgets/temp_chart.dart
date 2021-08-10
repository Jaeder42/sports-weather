import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TempChart extends StatelessWidget {
  late final chanceofRain;

  TempChart(weatherData) {
    chanceofRain = _getData(weatherData, 'air_temperature');
  }
  _getData(weatherData, value) {
    // fill data with hours since sunup
    // Stop at an hour after sunset (maybe)
    List<Point> chanceData = [];
    for (int i = 0; i < min(10, weatherData.length); i++) {
      var nextHour = weatherData[i]['data']['instant'];
      if (nextHour != null) {
        double chance = nextHour['details']['$value'];
        chanceData.add(Point(DateTime.parse(weatherData[i]['time']), chance));
      }
    }
    return chanceData;
  }

  _createData() {
    return [
      charts.Series<Point, DateTime>(
        id: 'Chance of precipitation',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
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
