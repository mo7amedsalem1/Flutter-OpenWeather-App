import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();

  void _searchWeather(BuildContext context) {
    final cityName = _cityController.text.trim();
    if (cityName.isNotEmpty) {
      Provider.of<WeatherProvider>(
        context,
        listen: false,
      ).fetchWeatherForCity(cityName).then((_) {
        // Navigate to details page after fetch attempt
        Navigator.of(context).pushNamed('/details', arguments: cityName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Weather Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.of(context).pushNamed('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Search Bar
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name (e.g., London)',
                hintText: 'Search for any city...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchWeather(context),
                ),
              ),
              onSubmitted: (_) => _searchWeather(context),
            ),
            const SizedBox(height: 20),

            // Search Button
            ElevatedButton.icon(
              onPressed: () => _searchWeather(context),
              icon: const Icon(Icons.travel_explore),
              label: const Text('Get Weather', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Optional: Placeholder for Search History/Recent Cities
            Text(
              'Recent Searches (Feature Placeholder)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),

            // Display any general error if present after an attempted search
            Consumer<WeatherProvider>(
              builder: (context, provider, child) {
                if (provider.errorMessage != null &&
                    provider.currentWeather == null &&
                    !provider.isLoading) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Error: ${provider.errorMessage}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
