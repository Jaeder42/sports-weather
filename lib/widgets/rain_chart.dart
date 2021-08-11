import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RainChart extends StatelessWidget {
  late final chanceofRain;
  late final rainAmount;

  RainChart(weatherData) {
    chanceofRain = _getData(weatherData, 'probability_of_precipitation');
    rainAmount = _getData(weatherData, 'precipitation_amount_max');
  }
  _getData(weatherData, value) {
    // fill data with hours since sunup
    // Stop at an hour after sunset (maybe)
    List<Point> chanceData = [];
    for (int i = 0; i < min(10, weatherData.length); i++) {
      var nextHour = weatherData[i]['data']['next_1_hours'];
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
        id: 'Precipitation amount',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Point point, _) => point.x,
        measureFn: (Point point, _) => point.y,
        data: rainAmount,
      ),
      charts.Series<Point, DateTime>(
        id: 'Chance of precipitation',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
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

              // primaryMeasureAxis: charts.NumericAxisSpec(
              //     // Set the initial viewport by providing a new AxisSpec with the
              //     // desired viewport, in NumericExtents.
              //     viewport: charts.NumericExtents(0.0, 100.0)),
              // // Optionally add a pan or pan and zoom behavior.
              // // If pan/zoom is not added, the viewport specified remains the viewport.
              // behaviors: [charts.PanAndZoomBehavior()],
            ))));
  }
}

class Point {
  final DateTime x;
  final double y;

  Point(this.x, this.y);
}
