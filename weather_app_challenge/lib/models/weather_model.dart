class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;
  final int sunriseTimestamp;
  final int sunsetTimestamp;
  final int timezoneOffsetSeconds;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.sunriseTimestamp,
    required this.sunsetTimestamp,
    required this.timezoneOffsetSeconds,
  });

  // Factory constructor to create a WeatherData object from the JSON response
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // OpenWeatherMap returns temperature in Kelvin by default.
    // We store it directly and let the provider handle the conversion.
    final double tempKelvin = json['main']['temp']?.toDouble() ?? 0.0;
    final double feelsLikeKelvin =
        json['main']['feels_like']?.toDouble() ?? 0.0;

    return WeatherData(
      cityName: json['name'] ?? 'Unknown City',
      country: json['sys']['country'] ?? 'N/A',
      temperature: tempKelvin,
      feelsLike: feelsLikeKelvin,
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: json['wind']['speed']?.toDouble() ?? 0.0,
      description: json['weather'][0]['description'] ?? 'Clear',
      iconCode: json['weather'][0]['icon'] ?? '01d',
      sunriseTimestamp: json['sys']['sunrise'] ?? 0,
      sunsetTimestamp: json['sys']['sunset'] ?? 0,
      timezoneOffsetSeconds:
          json['timezone'] ?? 0, // Timezone offset in seconds from UTC
    );
  }

  // Helper for favorites storage (to be used with StorageService)
  Map<String, dynamic> toJson() => {'cityName': cityName, 'country': country};
}
