import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

// IMPORTANT: Replace this with your actual OpenWeatherMap API Key.
// In a real project, this would be loaded from a config file or environment variable.
const String apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

class ApiService {
  // Exception classes for specific errors
  static const String invalidApiKeyError =
      'Invalid API Key. Please check your setup.';
  static const String cityNotFoundError =
      'City not found. Please try another name.';
  static const String unknownError =
      'An unknown error occurred. Please try again.';

  Future<WeatherData> fetchWeatherByCity(String city, String units) async {
    // 'units' parameter is for OpenWeatherMap API, but we'll stick to 'metric' or 'imperial'
    // in the call for base data, and perform the final conversion in the provider for flexibility.
    // However, the OpenWeatherMap API supports a 'units' query parameter.
    // Let's use the 'units' parameter from our app's setting to fetch in the desired unit.
    String apiUnits = (units == 'C') ? 'metric' : 'imperial';

    // The API call will be done without the 'units' parameter initially to get Kelvin data,
    // which makes the model unit-independent. But for simplicity and meeting the requirements
    // let's pass the 'units' parameter to get Celsius/Fahrenheit directly.

    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=$apiUnits');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return WeatherData.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        throw Exception(cityNotFoundError);
      } else if (response.statusCode == 401) {
        throw Exception(invalidApiKeyError);
      } else {
        // Handle other HTTP errors (5xx, 400, etc.)
        throw Exception('${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network errors (no internet connection, DNS failure, etc.)
      if (e is http.ClientException) {
        throw Exception(
          'Network Error: Could not connect to the server. Check your internet connection.',
        );
      }
      rethrow; // Re-throw the original exception (like City Not Found or Invalid Key)
    }
  }
}
