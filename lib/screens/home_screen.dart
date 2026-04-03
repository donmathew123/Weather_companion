import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_background.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  void _searchCity() {
    FocusScope.of(context).unfocus();
    if (_searchController.text.trim().isNotEmpty) {
      context.read<WeatherProvider>().fetchWeatherByCity(_searchController.text.trim());
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          final condition = provider.currentWeather?.condition ?? 'Clear';
          return WeatherBackground(
            condition: condition,
            child: SafeArea(
              child: Column(
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (provider.isLoading && provider.currentWeather == null) {
                          return const ShimmerLoading();
                        } else if (provider.error != null && provider.currentWeather == null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, color: Colors.white, size: 60),
                                const SizedBox(height: 16),
                                Text(
                                  provider.error!,
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => context.read<WeatherProvider>().fetchWeatherByLocation(),
                                  child: const Text('Try Current Location'),
                                )
                              ],
                            ),
                          );
                        } else if (provider.currentWeather != null) {
                          return RefreshIndicator(
                            onRefresh: () => context.read<WeatherProvider>().fetchWeatherByCity(provider.currentWeather!.cityName),
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              children: [
                                if (provider.isLoading)
                                  const LinearProgressIndicator(color: Colors.white),
                                if (provider.error != null)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    color: Colors.redAccent.withAlpha(128),
                                    child: Text(provider.error!, style: const TextStyle(color: Colors.white)),
                                  ),
                                CurrentWeatherCard(weather: provider.currentWeather!),
                                const SizedBox(height: 24),
                                if (provider.forecast != null)
                                  HourlyForecast(forecast: provider.forecast!),
                                const SizedBox(height: 24),
                                if (provider.forecast != null)
                                  DailyForecast(forecast: provider.forecast!),
                              ],
                            ),
                          );
                        }
                        return const ShimmerLoading();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(51),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search city...',
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onSubmitted: (_) => _searchCity(),
        ),
      ),
    );
  }
}
