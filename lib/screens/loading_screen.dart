import 'package:weather/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void getLocationData() async {
    var weatherData = await WeatherModel().getLocationWeather();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        locationWeather: weatherData,
      );
    }));
  }

  @override
  void initState() {
    getLocationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade300,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment(0.0, 0.0),
            colors: [const Color(0xFF3DA35D), const Color(0xFF96E072)],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Center(
          child: SpinKitDualRing(
            color: Colors.white,
            size: 110.0,
          ),
        ),
      ),
    );
  }
}
