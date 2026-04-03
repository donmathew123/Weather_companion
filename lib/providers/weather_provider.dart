import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class WeatherProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

  WeatherModel? currentWeather;
  ForecastModel? forecast;
  
  bool isLoading = false;
  String? error;

  Future<void> fetchWeatherByLocation() async {
    _setLoading(true);
    try {
      final position = await _locationService.getCurrentLocation();
      currentWeather = await _apiService.fetchCurrentWeatherByCoords(position.latitude, position.longitude);
      forecast = await _apiService.fetchForecastByCoords(position.latitude, position.longitude);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    if (city.isEmpty) return;
    _setLoading(true);
    try {
      currentWeather = await _apiService.fetchCurrentWeatherByCity(city);
      forecast = await _apiService.fetchForecastByCity(city);
      error = null;
    } catch (e) {
      error = "City Not Found";
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
