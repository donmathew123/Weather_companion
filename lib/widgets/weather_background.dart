import 'package:flutter/material.dart';

class WeatherBackground extends StatelessWidget {
  final String condition;
  final Widget child;

  const WeatherBackground({super.key, required this.condition, required this.child});

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors;

    switch (condition.toLowerCase()) {
      case 'clear':
        gradientColors = [Colors.orange.shade300, Colors.blue.shade400];
        break;
      case 'clouds':
        gradientColors = [Colors.grey.shade400, Colors.blueGrey.shade700];
        break;
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        gradientColors = [Colors.blueGrey.shade800, Colors.grey.shade900];
        break;
      case 'snow':
        gradientColors = [Colors.lightBlue.shade200, Colors.white70];
        break;
      default:
        gradientColors = [Colors.blue.shade400, Colors.purple.shade500];
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: child,
    );
  }
}
