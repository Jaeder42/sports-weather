import 'dart:convert';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sport_weather/widgets/sports/running.dart';

import '../geolocation.dart';

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
    getLocation();
    super.initState();
  }

  getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LatLon _locationData;

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
    // print(location);
    try {
      GeolocationT.getCurrentPosition((e) {
        _locationData = LatLon(e.coords.latitude, e.coords.longitude);
        getWeatherData(_locationData.latitude, _locationData.longitude);
      }, (e) => print(e),
          {"enableHighAccuracy": true, "timeout": 5000, "maximumAge": 0});
    } catch (err) {
      print(err);
      getWeatherData('59.458344', '18.074890');
    }
  }

  getWeatherData(lat, lon) async {
    try {
      var result = await http.get(Uri.parse(
          'https://api.met.no/weatherapi/locationforecast/2.0/complete.json?lat=$lat&lon=$lon'));

      var sunResult = await http.get(Uri.parse(
          'https://api.sunrise-sunset.org/json?lat=$lat&lng=$lon&formatted=0'));

//https://sunrise-sunset.org/api remember to give attribution
      setState(() {
        loading = false;
        weatherData = jsonDecode(result.body);
        sunData = jsonDecode(sunResult.body);
        // print(sunData);
      });
    } catch (e) {
      print(e);
    }
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

class LatLon {
  final double latitude;
  final double longitude;

  LatLon(this.latitude, this.longitude);
}
