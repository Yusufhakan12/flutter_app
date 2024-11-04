import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'api_test.mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';

@GenerateMocks([http.Client])
Future<Map<String, dynamic>> fetchWeatherTest(
    http.Client client, String city) async {
  final response = await client.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=your_openweather_api_key&units=metric'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}

void main() {
  group('fetchWeather', () {
    test('basarili API yaniti', () async {
      final client = MockClient();

      // Mock API yanıtı (başarılı)
      final mockResponse = {
        "weather": [
          {"description": "clear sky", "icon": "01d"}
        ],
        "main": {
          "temp": 20.0,
          "temp_min": 18.0,
          "temp_max": 22.0,
          "humidity": 60
        },
        "wind": {"speed": 10.0},
        "name": "Sakarya"
      };

      when(client.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=Sakarya&appid=your_openweather_api_key&units=metric'),
      )).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      final weatherData = await fetchWeatherTest(client, 'Sakarya');

      expect(weatherData['name'], 'Sakarya');
      expect(weatherData['main']['temp'], 20.0);
      expect(weatherData['main']['temp_min'], 18.0);
      expect(weatherData['main']['temp_max'], 22.0);
      expect(weatherData['weather'][0]['description'], 'clear sky');
    });

    test('başarisiz API yaniti', () async {
      final client = MockClient();

      // 404 Hata kodu döndüren bir mock yanıt
      when(client.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=Sakarya&appid=your_openweather_api_key&units=metric'),
      )).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(fetchWeatherTest(client, 'Sakarya'), throwsException);
    });
  });
}
