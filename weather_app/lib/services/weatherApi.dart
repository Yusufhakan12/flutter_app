// lib/services/weather_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/model.dart';

class WeatherService {
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather?> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);

        return Weather.fromJson(
            jsonData); // JSON verisini Weather nesnesine dönüştürüyoruz
      } else {
        print('Failed to load weather data');
        return null;
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }
}
