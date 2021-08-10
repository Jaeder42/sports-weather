import 'dart:convert';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sport_weather/widgets/sports/running.dart';

class Weather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherState();
  }
}

class _WeatherState extends State<Weather> {
  bool loading = true;
  var weatherData;
  var sunData;
  @override
  void initState() {
    // TODO: implement initState
    // getWeatherData();
    getLocation();
    super.initState();
  }

  getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    getWeatherData(_locationData.latitude, _locationData.longitude);
  }

  getWeatherData(lat, lon) async {
    var result = await http.get(Uri.parse(
        'https://api.met.no/weatherapi/locationforecast/2.0/complete.json?lat=$lat&lon=$lon'));

    var sunResult = await http.get(Uri.parse(
        'https://api.sunrise-sunset.org/json?lat=$lat&lng=$lon&formatted=0'));

//https://sunrise-sunset.org/api remember to give attribution
    setState(() {
      loading = false;
      weatherData = jsonDecode(result.body);
      sunData = jsonDecode(sunResult.body);
      print(sunData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: loading
          ? CircularProgressIndicator()
          : Running(weatherData['properties']['timeseries']),
    ));
  }
}
