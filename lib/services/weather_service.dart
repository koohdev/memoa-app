import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:always/models/weather_model.dart';

class WeatherService {
  static const String _apiKey = '43151f280838c0744cc7d65a2b220a36';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<List<Weather>> fetchHourlyForecast(String city) async {
    final response = await http.get(Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Weather> forecast = (data['list'] as List)
          .map((item) => Weather.fromHourlyJson(item))
          .toList();
      return forecast.take(4).toList(); // Take the next 12 hours (4 * 3-hour intervals)
    } else {
      throw Exception('Failed to load hourly forecast');
    }
  }
}
