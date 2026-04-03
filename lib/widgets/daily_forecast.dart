import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import 'package:intl/intl.dart';

class DailyForecast extends StatelessWidget {
  final ForecastModel forecast;

  const DailyForecast({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    // Construct daily forecast properly by aggregating min/max over the day
    final Map<int, List<ForecastItem>> groupedByDay = {};
    for (var item in forecast.items) {
      final localDate = item.date.toLocal();
      if (!groupedByDay.containsKey(localDate.day)) {
        groupedByDay[localDate.day] = [];
      }
      groupedByDay[localDate.day]!.add(item);
    }

    final dailyWidgets = <Widget>[];
    groupedByDay.forEach((day, items) {
      if (dailyWidgets.length >= 5) return; // Only 5 days

      // Calculate max and min for the day
      double maxTemp = -100;
      double minTemp = 100;
      for (var item in items) {
        if (item.tempMax > maxTemp) maxTemp = item.tempMax;
        if (item.tempMin < minTemp) minTemp = item.tempMin;
      }

      // We'll use the condition from the midday reading
      final middayItem = items.firstWhere(
        (i) => i.date.toLocal().hour >= 11 && i.date.toLocal().hour <= 15,
        orElse: () => items.first,
      );

      dailyWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  DateFormat('EEEE').format(middayItem.date.toLocal()),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${middayItem.iconCode}.png',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    middayItem.condition,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              Text(
                '${maxTemp.round()}° / ${minTemp.round()}°',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5-Day Forecast',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: dailyWidgets,
          ),
        ),
      ],
    );
  }
}
