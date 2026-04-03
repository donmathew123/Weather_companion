class ForecastItem {
  final DateTime date;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String iconCode;

  ForecastItem({
    required this.date,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.iconCode,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
      temperature: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}

class ForecastModel {
  final List<ForecastItem> items;

  ForecastModel({required this.items});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List;
    final items = list.map((item) => ForecastItem.fromJson(item)).toList();
    return ForecastModel(items: items);
  }
}
