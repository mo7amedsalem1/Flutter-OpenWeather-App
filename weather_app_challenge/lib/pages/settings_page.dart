import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              // Temperature Unit Setting
              _buildSettingsCard(
                context,
                title: 'Temperature Unit',
                subtitle: 'Change between Celsius (°C) and Fahrenheit (°F)',
                trailing: DropdownButton<String>(
                  value: provider.unit,
                  items: const [
                    DropdownMenuItem(value: 'C', child: Text('Celsius (°C)')),
                    DropdownMenuItem(
                      value: 'F',
                      child: Text('Fahrenheit (°F)'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      provider.setUnit(newValue);
                    }
                  },
                ),
              ),

              // Optional: Language Selector Placeholder
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language (Placeholder)'),
                subtitle: const Text('English (Default)'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Language selection is an optional feature and is not implemented yet.',
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      leading: const Icon(Icons.thermostat_auto),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }
}
