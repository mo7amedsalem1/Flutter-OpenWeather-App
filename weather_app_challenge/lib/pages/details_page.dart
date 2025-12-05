import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Arguments are passed from the Home Page, containing the searched city name
    final cityName = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Details')),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Failed to load weather data for "$cityName".\nError: ${provider.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final weather = provider.currentWeather;
          if (weather == null) {
            return Center(
              child: Text('Search for a city on the Home page first.'),
            );
          }

          return WeatherDetailsWidget(weather: weather, provider: provider);
        },
      ),
    );
  }
}

// Reusable Widget for displaying the detailed weather information
class WeatherDetailsWidget extends StatelessWidget {
  final WeatherData weather;
  final WeatherProvider provider;

  const WeatherDetailsWidget({
    super.key,
    required this.weather,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchWeatherForCity(weather.cityName),
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          // City Name and Favorite Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.cityName}, ${weather.country}',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    provider.formatTimestamp(
                      DateTime.now().millisecondsSinceEpoch ~/ 1000,
                      weather.timezoneOffsetSeconds,
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              IconButton(
                iconSize: 32,
                color: Colors.red,
                icon: provider.isFavorite(weather.cityName)
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                onPressed: () => provider.toggleFavorite(weather.cityName),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Main Temperature and Icon
          Center(
            child: Column(
              children: [
                Image.network(
                  provider.getWeatherIconUrl(weather.iconCode),
                  width: 120,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.cloud_queue, size: 120),
                ),
                Text(
                  '${provider.formatTemperature(weather.temperature)}${provider.unitSymbol}',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 80,
                  ),
                ),
                Text(
                  weather.description.toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),
                Text(
                  'Feels like: ${provider.formatTemperature(weather.feelsLike)}${provider.unitSymbol}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Detailed Information Grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildDetailCard(
                context,
                icon: Icons.water_drop,
                title: 'Humidity',
                value: '${weather.humidity}%',
              ),
              _buildDetailCard(
                context,
                icon: Icons.air,
                title: 'Wind Speed',
                value:
                    '${weather.windSpeed} ${(provider.unit == 'C' ? 'm/s' : 'mph')}',
              ),
              _buildDetailCard(
                context,
                icon: Icons.wb_sunny,
                title: 'Sunrise',
                value: provider.formatTimestamp(
                  weather.sunriseTimestamp,
                  weather.timezoneOffsetSeconds,
                ),
              ),
              _buildDetailCard(
                context,
                icon: Icons.nightlight_round,
                title: 'Sunset',
                value: provider.formatTimestamp(
                  weather.sunsetTimestamp,
                  weather.timezoneOffsetSeconds,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 30, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
