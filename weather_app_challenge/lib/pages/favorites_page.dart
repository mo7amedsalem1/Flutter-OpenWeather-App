import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  // Function to handle navigating and fetching weather for a favorite city
  void _selectFavorite(BuildContext context, String city) {
    Provider.of<WeatherProvider>(
      context,
      listen: false,
    ).fetchWeatherForCity(city).then((_) {
      // Navigate to details page
      Navigator.of(context).pushNamed('/details', arguments: city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Cities')),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favoriteCities;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No favorites added yet.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Text('Add cities from the details screen.'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final city = favorites[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_city,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    city,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      provider.toggleFavorite(
                        city,
                      ); // Toggle logic handles removal if it exists
                      // Show a simple SnackBar confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$city removed from favorites.'),
                        ),
                      );
                    },
                  ),
                  onTap: () => _selectFavorite(context, city),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
