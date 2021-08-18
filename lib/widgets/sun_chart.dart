import 'dart:math';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:sport_weather/widgets/weather.dart';

class SunChart extends StatelessWidget {
  final SunData sunData;

  SunChart(this.sunData);

  List<charts.Series<GaugeSegment, String>> _createData() {
    var now = DateTime.now();
    var past = max(now.difference(sunData.sunrise).inSeconds, 0);
    var left = max(sunData.sunset.difference(now).inSeconds, 0);
    final data = [
      GaugeSegment('Past', past),
      GaugeSegment('Possible', left),
    ];

    return [
      charts.Series<GaugeSegment, String>(
        id: 'Segments',
        colorFn: (_, index) => index == 0
            ? charts.MaterialPalette.gray.shade700
            : charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          bottom: 80,
          left: 0,
          child: Text(DateFormat('HH:mm').format(sunData.sunrise))),
      Positioned(
          bottom: 80,
          right: 0,
          child: Text(DateFormat('HH:mm').format(sunData.sunset))),
      Container(
          height: 200,
          width: 200,
          child: charts.PieChart<String>(_createData(),
              animate: true,
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 100, startAngle: pi, arcLength: pi)))
    ]);
  }
}

class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}
