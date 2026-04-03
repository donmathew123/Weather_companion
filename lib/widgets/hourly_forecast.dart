import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import 'package:intl/intl.dart';

class HourlyForecast extends StatelessWidget {
  final ForecastModel forecast;

  const HourlyForecast({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    // Only take next 8 items (approx 24 hours)
    final hourlyItems = forecast.items.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyItems.length,
            itemBuilder: (context, index) {
              final item = hourlyItems[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('ha').format(item.date.toLocal()),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Image.network(
                      'https://openweathermap.org/img/wn/${item.iconCode}.png',
                      width: 40,
                      height: 40,
                      errorBuilder: (_, __, ___) => const Icon(Icons.cloud, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.temperature.round()}°',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
