import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sport_weather/widgets/weather.dart';

class RainChart extends StatelessWidget {
  late final minRain;
  late final maxRain;
  late final startArray;
  final SunData sunData;

  RainChart(weatherData, this.sunData) {
    var firstTime = DateTime.parse(weatherData[0]['time']);
    startArray = firstTime.difference(sunData.sunrise).inHours - 1;
    minRain = _getData(weatherData, 'precipitation_amount_min');
    maxRain = _getData(weatherData, 'precipitation_amount_max');
  }
  _getData(weatherData, value) {
    // fill data with hours since sunup
    // Stop at an hour after sunset (maybe)
    var noPoints = sunData.sunset.difference(sunData.sunrise).inHours;
    var firstValue =
        weatherData[0]['data']['next_1_hours']['details']['$value'];

    print('noPoints: $noPoints, start: $startArray');

    List<Point> data = List.generate(
        noPoints,
        (index) =>
            Point(sunData.sunrise.add(Duration(hours: index)), firstValue));

    int j = 0;
    for (int i = startArray; i < noPoints; i++) {
      var nextHour = weatherData[j]['data']['next_1_hours'];
      if (nextHour != null) {
        double chance = nextHour['details']['$value'];
        print(data[i]);
        data[i] = (Point(DateTime.parse(weatherData[j]['time']), chance));
        print(data[i]);
        print('---------------------');
      }
      j++;
    }
    return data;
  }

  _createData() {
    return [
      charts.Series<Point, DateTime>(
        id: 'Precipitation amount',
        colorFn: (_, index) => index! >= startArray
            ? charts.MaterialPalette.blue.shadeDefault
            : charts.MaterialPalette.gray.shade900,
        domainFn: (Point point, _) => point.x,
        measureFn: (Point point, _) => point.y,
        data: minRain,
      ),
      charts.Series<Point, DateTime>(
        id: 'Chance of precipitation',
        colorFn: (_, index) => index! >= startArray
            ? charts.MaterialPalette.cyan.shadeDefault
            : charts.MaterialPalette.gray.shade900,
        domainFn: (Point point, _) => point.x,
        measureFn: (Point point, _) => point.y,
        data: maxRain,
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
                  charts.LineRendererConfig(includeArea: true, stacked: false),
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

  @override
  String toString() {
    // TODO: implement toString
    return 'x: $x, y: $y';
  }
}
