import 'package:weather/services/networking.dart';
import '../services/location.dart';

const apiKey = 'ee76a3027d6aa26bd0f1903c4d7563bd';
const openWeatherMap = 'https://api.openweathermap.org/data/2.5/';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    double latitude;
    double longitude;

    var url =
        '${openWeatherMap}weather?q=$cityName&appid=$apiKey&units=metric&lang=pt_br';
    NetworkHelper networkHelp = NetworkHelper(url);

    var cityData = await networkHelp.getData();

    if (cityData != null) {
      latitude = cityData['coord']['lat'];
      longitude = cityData['coord']['lon'];

      NetworkHelper networkHelper = NetworkHelper(
        '${openWeatherMap}onecall?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=pt_br',
      );

      var weatherData = await networkHelper.getData();
      return weatherData;
    }
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
      '${openWeatherMap}onecall?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric&lang=pt_br',
      //'$openWeatherMap?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric&lang=pt_br'
    );

    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}
