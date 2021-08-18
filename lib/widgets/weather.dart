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
  late SunData sunData;
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  getLocation() async {
    setState(() {
      loading = true;
    });
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
      var sunJson = jsonDecode(sunResult.body);
//https://sunrise-sunset.org/api remember to give attribution
      setState(() {
        loading = false;
        weatherData = jsonDecode(result.body);
        sunData = SunData(
            sunJson['results']['sunrise'], sunJson['results']['sunset']);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _refresh() async {
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: loading
          ? CircularProgressIndicator()
          : RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(slivers: [
                SliverPadding(padding: EdgeInsets.only(top: 40)),
                SliverToBoxAdapter(
                    child: Running(
                        weatherData['properties']['timeseries'], sunData))
              ])),
    ));
  }
}

class LatLon {
  final double latitude;
  final double longitude;

  LatLon(this.latitude, this.longitude);
}

class SunData {
  late DateTime sunrise;
  late DateTime sunset;

  SunData(String sunrise, String sunset) {
    this.sunrise = DateTime.parse(sunrise).toLocal();
    this.sunset = DateTime.parse(sunset).toLocal();
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'sunrise: $sunrise, sunset: $sunset';
  }
}
