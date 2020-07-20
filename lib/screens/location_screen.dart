import 'package:weather/screens/city_screen.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import '../services/weather.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  int maxTemperature;
  int minTemperature;
  String weatherIcon;
  String weatherMessage;
  String iconCode;
  String iconCodeMin;
  String iconCodeMax;
  String description;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        isVisible = false;
        description = 'TENTE NOVAMENTE!';
        temperature = 0;
        iconCode = '11d';
        return;
      }
      isVisible = true;
      double temp = weatherData['current']['temp'];
      temperature = temp.toInt();
      double tempMin = weatherData['daily'][0]['temp']['min'];
      minTemperature = tempMin.toInt();
      double tempMax = weatherData['daily'][0]['temp']['max'];
      maxTemperature = tempMax.toInt();
      iconCode = weatherData['current']['weather'][0]['icon'];
      iconCodeMin = weatherData['hourly'][7]['weather'][0]['icon'];
      iconCodeMax = weatherData['hourly'][18]['weather'][0]['icon'];
      description = weatherData['current']['weather'][0]['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WEATHER'),
        actions: [
          IconButton(
            onPressed: () async {
              var weatherData = await weather.getLocationWeather();
              updateUI(weatherData);
            },
            icon: Icon(
              Icons.near_me,
              size: 30.0,
            ),
          ),
          IconButton(
            onPressed: () async {
              var typedName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityScreen(),
                  ));
              if (typedName != null) {
                var weatherData = await weather.getCityWeather(typedName);
                updateUI(weatherData);
              }
            },
            icon: Icon(
              Icons.location_city,
              size: 30.0,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment(
                0.8, 1.2), // 10% of the width, so there are ten blinds.
            colors: [
              const Color(0xFF3DA35D),
              const Color(0xFF96E072)
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 130.0, 0.0, 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$temperature°',
                        style: kTempTextStyle,
                      ),
                      Image.network(
                        'http://openweathermap.org/img/wn/$iconCode@2x.png',
                        scale: 0.8,
                      ),
                    ],
                  ),
                ),
                Text(
                  description.toUpperCase(),
                  style: kDescriptionTextStyle,
                ),
                Divider(
                  color: Colors.white,
                  height: 70.0,
                  thickness: 2.0,
                  indent: 40.0,
                  endIndent: 40.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Visibility(
                    visible: isVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Image.network(
                              'http://openweathermap.org/img/wn/$iconCodeMin@2x.png',
                            ),
                            Text(
                              '$minTemperature°',
                              style: kMinMaxTextStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Image.network(
                              'http://openweathermap.org/img/wn/$iconCodeMax@2x.png',
                            ),
                            Text(
                              '$maxTemperature°',
                              style: kMinMaxTextStyle,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
