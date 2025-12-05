import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _favoritesKey = 'weather_favorites';
  static const String _unitKey =
      'temperature_unit'; // 'C' for Celsius, 'F' for Fahrenheit

  late SharedPreferences _prefs;

  // Initialize SharedPreferences instance
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Favorites Management ---

  // Get all favorite cities
  List<String> getFavorites() {
    final favoritesJson = _prefs.getStringList(_favoritesKey) ?? [];
    return favoritesJson;
  }

  // Add a city to favorites
  Future<bool> addFavorite(String city) async {
    final favorites = getFavorites();
    if (!favorites.contains(city)) {
      favorites.add(city);
      return _prefs.setStringList(_favoritesKey, favorites);
    }
    return false; // Already in favorites
  }

  // Remove a city from favorites
  Future<bool> removeFavorite(String city) async {
    final favorites = getFavorites();
    if (favorites.contains(city)) {
      favorites.remove(city);
      return _prefs.setStringList(_favoritesKey, favorites);
    }
    return false; // Not in favorites
  }

  // Check if a city is favorited
  bool isFavorite(String city) {
    return getFavorites().contains(city);
  }

  // --- Settings Management ---

  // Get current temperature unit ('C' or 'F')
  String getUnit() {
    return _prefs.getString(_unitKey) ?? 'C'; // Default to Celsius
  }

  // Set new temperature unit
  Future<bool> setUnit(String unit) async {
    if (unit == 'C' || unit == 'F') {
      return _prefs.setString(_unitKey, unit);
    }
    return false;
  }
}
