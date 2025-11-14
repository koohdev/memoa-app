class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String description;
  final DateTime time;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      description: json['weather'][0]['description'],
      time: DateTime.now(),
    );
  }

  factory Weather.fromHourlyJson(Map<String, dynamic> json) {
    return Weather(
      cityName: '', // Not needed for hourly forecast
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      description: json['weather'][0]['description'],
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}
