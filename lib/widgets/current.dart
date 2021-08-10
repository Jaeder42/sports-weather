import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sport_weather/widgets/weather_icon.dart';

class Current extends StatelessWidget {
  late var temp;
  late var uvi;
  late var summary;

  Current(dynamic weatherData) {
    var instant = weatherData[0]['data']['instant']['details'];
    temp = instant['air_temperature'];
    uvi = instant['ultraviolet_index_clear_sky'];
    summary = weatherData[0]['data']['next_1_hours']['summary']['symbol_code'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        child: Column(children: [
          WeatherIcon(summary),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  FaIcon(FontAwesomeIcons.thermometerThreeQuarters),
                  Text('$temp °C')
                ],
              ),
              Column(
                children: [
                  FaIcon(FontAwesomeIcons.tachometerAlt),
                  Text('UVI: $uvi')
                ],
              )
            ],
          )
        ]));
  }
}
