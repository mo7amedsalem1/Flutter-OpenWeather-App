import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class WeatherProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService;

  WeatherProvider(this._storageService) {
    _loadInitialState();
  }

  // --- State Variables ---
  WeatherData? _currentWeather;
  bool _isLoading = false;
  String? _errorMessage;
  String _unit = 'C'; // Default to Celsius
  List<String> _favoriteCities = [];

  // --- Getters (for UI access) ---
  WeatherData? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get unit => _unit;
  List<String> get favoriteCities => _favoriteCities;
  String get unitSymbol => _unit == 'C' ? '°C' : '°F';

  // --- Initialization ---
  void _loadInitialState() {
    _unit = _storageService.getUnit();
    _favoriteCities = _storageService.getFavorites();
    notifyListeners();
  }

  // --- Core Functionality ---

  Future<void> fetchWeatherForCity(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchWeatherByCity(city, _unit);
      _currentWeather = data;
      _errorMessage = null; // Clear error on successful fetch
    } on Exception catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Unit Conversion Helper ---

  double _kelvinToCelsius(double k) => k - 273.15;
  double _kelvinToFahrenheit(double k) => (k - 273.15) * 9 / 5 + 32;

  String formatTemperature(double tempKelvin) {
    double displayTemp;
    if (_unit == 'C') {
      // The API call in ApiService already fetches in the requested unit
      // based on the 'units' query parameter (metric/imperial).
      // If ApiService was written to always return Kelvin, the logic below would apply.
      // Since we modified ApiService to use the app unit, we can use the value directly,
      // but let's keep the conversion logic here for robustness if we switch back.

      // For the current ApiService implementation, the temperature field in WeatherData
      // already contains Celsius or Fahrenheit based on the last API call.
      displayTemp = tempKelvin;
    } else {
      displayTemp = tempKelvin;
    }
    return displayTemp.toStringAsFixed(1);
  }

  // --- Settings Management ---

  Future<void> setUnit(String newUnit) async {
    if (_unit != newUnit) {
      _unit = newUnit;
      await _storageService.setUnit(newUnit);
      notifyListeners();

      // Optional: Re-fetch weather for the currently viewed city to update units instantly
      if (_currentWeather != null) {
        await fetchWeatherForCity(_currentWeather!.cityName);
      }
    }
  }

  // --- Favorites Management ---

  bool isFavorite(String city) => _storageService.isFavorite(city);

  Future<void> toggleFavorite(String city) async {
    if (isFavorite(city)) {
      await _storageService.removeFavorite(city);
    } else {
      await _storageService.addFavorite(city);
    }
    // Update local list and notify listeners
    _favoriteCities = _storageService.getFavorites();
    notifyListeners();
  }

  // --- Utility Formatting ---

  String formatTimestamp(int timestamp, int timezoneOffset) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );
    // Apply the timezone offset to get local time
    final localTime = dateTime.add(Duration(seconds: timezoneOffset));
    return DateFormat('h:mm a').format(localTime);
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
