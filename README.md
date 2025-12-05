Flutter Weather App: OpenWeatherMap Integration

This is a multi-page Flutter mobile application built to demonstrate advanced Flutter development techniques, including REST API integration, state management, local storage, and structured code organization.

Features

Multi-page Architecture: Includes Home/Search, Weather Details, Favorites, and Settings screens.

Real-time Data: Fetches current weather data using the OpenWeatherMap Current Weather API.

Search Functionality: Allows users to search for weather by city name.

Detailed View: Displays temperature, "feels like," description, humidity, wind speed, sunrise, and sunset times, including local time calculation based on timezone offset.

Favorites Management: Users can save and remove favorite cities using shared_preferences.

Unit Switching: Users can toggle the temperature display between Celsius (°C) and Fahrenheit (°F).

State Management: Uses the provider package for clean and reactive state handling.

Error Handling: Robust handling for API errors (e.g., Invalid City, Network issues, Invalid API Key).

App Description

The application follows a standard mobile architecture, separating concerns into models, services, providers (state), and pages (UI). This structure makes the app scalable and maintainable.

Setup Steps

Follow these steps to get the project running locally.

1. Prerequisites

Flutter SDK installed and configured.

An active OpenWeatherMap API Key. You can obtain one from OpenWeatherMap.

2. Get the Source Code

(Assuming you clone or download the provided files into a directory named weather_app_challenge).

3. API Key Usage (CRITICAL STEP)

The API Key is required for the application to function.

Open the file: lib/services/api_service.dart.

Find the constant definition:

const String apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';


Replace 'YOUR_OPENWEATHERMAP_API_KEY' with your actual key.

Note on Security: In a production application, the API key should never be committed directly to Git. It should be loaded from a local .env file or environment variables, which are then added to .gitignore. For this project setup, direct replacement is used for simplicity.

4. Install Dependencies

Open your terminal in the project root directory (weather_app_challenge/) and run:

flutter pub get


5. Run the Application

Connect a mobile device or launch an emulator/simulator, and run the app:

flutter run


Folder Structure Summary

Path

Purpose

lib/main.dart

Main entry point, Provider setup, and Routing.

lib/models/weather_model.dart

Data model for API responses.

lib/services/api_service.dart

Handles all HTTP communication with OpenWeatherMap.

lib/services/storage_service.dart

Manages local data (favorites, settings) using shared_preferences.

lib/providers/weather_provider.dart

Centralized state and business logic using ChangeNotifier.

lib/pages/home_page.dart

Search and initial screen.

lib/pages/details_page.dart

Displays the full weather report.

lib/pages/favorites_page.dart

Lists and manages favorite cities.

lib/pages/settings_page.dart

Allows changing temperature units.
