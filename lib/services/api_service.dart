import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  String get _apiKey {
    return dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';
  }

  Future<WeatherModel> fetchCurrentWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse('$baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load current weather data');
    }
  }

  Future<ForecastModel> fetchForecastByCoords(double lat, double lon) async {
    final url = Uri.parse('$baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ForecastModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<WeatherModel> fetchCurrentWeatherByCity(String cityName) async {
    final url = Uri.parse('$baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('City not found');
    }
  }

  Future<ForecastModel> fetchForecastByCity(String cityName) async {
    final url = Uri.parse('$baseUrl/forecast?q=$cityName&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ForecastModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load forecast data for city');
    }
  }
}
