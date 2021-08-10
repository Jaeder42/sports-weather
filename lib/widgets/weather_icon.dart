import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherIcon extends StatelessWidget {
  late IconData icon;
  final Map<String, IconData> icons = {
    'clearsky': FontAwesomeIcons.sun,
    'cloudy': FontAwesomeIcons.cloud,
    'fair': FontAwesomeIcons.cloudSun,
    'fog': FontAwesomeIcons.smog,
    'heavyrain': FontAwesomeIcons.cloudShowersHeavy,
    'heavyrainandthunder': FontAwesomeIcons.cloudShowersHeavy,
    'heavyrainshowers': FontAwesomeIcons.cloudShowersHeavy,
    'heavyrainshowersandthunder': FontAwesomeIcons.cloudShowersHeavy,
    'heavysleet': FontAwesomeIcons.cloudRain,
    'heavysleetandthunder': FontAwesomeIcons.cloudRain,
    'heavysleetshowers': FontAwesomeIcons.cloudRain,
    'heavysnow': FontAwesomeIcons.snowflake,
    'heavysnowandthunder': FontAwesomeIcons.snowflake,
    'heavysnowshowers': FontAwesomeIcons.snowflake,
    'heavysnowshowersandthunder': FontAwesomeIcons.snowflake,
    'lightrain': FontAwesomeIcons.cloudRain,
    'lightrainandthunder': FontAwesomeIcons.cloudRain,
    'lightrainshowers': FontAwesomeIcons.cloudRain,
    'lightrainshowersandthunder': FontAwesomeIcons.cloudRain,
    'lightsleet': FontAwesomeIcons.cloudRain,
    'lightsleetandthunder': FontAwesomeIcons.cloudRain,
    'lightsleetshowers': FontAwesomeIcons.cloudRain,
    'lightsnow': FontAwesomeIcons.snowflake,
    'lightsnowandthunder': FontAwesomeIcons.snowflake,
    'lightsnowshowers': FontAwesomeIcons.snowflake,
    'lightssleetshowersandthunder': FontAwesomeIcons.snowflake,
    'lightssnowshowersandthunder': FontAwesomeIcons.snowflake,
    'partlycloudy': FontAwesomeIcons.cloudSun,
    'rain': FontAwesomeIcons.cloudRain,
    'rainandthunder': FontAwesomeIcons.cloudRain,
    'rainshowers': FontAwesomeIcons.cloudRain,
    'rainshowersandthunder': FontAwesomeIcons.cloudRain,
    'sleet': FontAwesomeIcons.cloudRain,
    'sleetandthunder': FontAwesomeIcons.cloudRain,
    'sleetshowers': FontAwesomeIcons.cloudRain,
    'sleetshowersandthunder': FontAwesomeIcons.cloudRain,
    'snow': FontAwesomeIcons.snowflake,
    'snowandthunder': FontAwesomeIcons.snowflake,
    'snowshowers': FontAwesomeIcons.snowflake,
    'snowshowersandthunder': FontAwesomeIcons.snowflake,
  };

  WeatherIcon(String symbol) {
    // clear _any from symbol
    print(symbol);
    symbol = symbol.replaceAll(RegExp(r'_.+'), '');
    icon = icons[symbol] ?? FontAwesomeIcons.question;
  }

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      icon,
      size: 30,
    );
  }
}
