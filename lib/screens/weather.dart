import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:always/services/weather_service.dart';
import 'package:always/models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();
  Weather? _currentWeather;
  List<Weather>? _hourlyForecast;
  bool _isLoading = true;
  String _city = 'Capas, Tarlac, Philippines';
  List<String> _suggestedCities = [];
  final List<String> _allCities = [
    'Capas, Tarlac, Philippines',
    'Concepcion, Tarlac, Philippines',
    'Tarlac City, Tarlac, Philippines',
    'Bamban, Tarlac, Philippines',
    'Angeles City, Pampanga, Philippines',
    'Manila, Philippines',
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _cityController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _cityController.removeListener(_onSearchChanged);
    _cityController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_cityController.text.isEmpty) {
      setState(() {
        _suggestedCities = [];
      });
      return;
    }

    setState(() {
      _suggestedCities = _allCities
          .where(
            (city) =>
                city.toLowerCase().contains(_cityController.text.toLowerCase()),
          )
          .toList();
    });
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentWeather = await _weatherService.fetchWeather(_city);
      final hourlyForecast = await _weatherService.fetchHourlyForecast(_city);
      setState(() {
        _currentWeather = currentWeather;
        _hourlyForecast = hourlyForecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchCard(),
              if (_suggestedCities.isNotEmpty) _buildSuggestionsList(),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildWeatherContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'Search for a city',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_cityController.text.isNotEmpty) {
                  setState(() {
                    _city = _cityController.text;
                    _suggestedCities = [];
                  });
                  _cityController.clear();
                  _fetchWeatherData();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _suggestedCities.length,
        itemBuilder: (context, index) {
          final city = _suggestedCities[index];
          return ListTile(
            title: Text(city),
            onTap: () {
              setState(() {
                _city = city;
                _cityController.text = city;
                _suggestedCities = [];
              });
              _cityController.clear();
              _fetchWeatherData();
            },
          );
        },
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (_currentWeather == null) {
      return const Center(child: Text('Could not fetch weather data.'));
    }

    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _city,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('EEEE, d MMMM').format(DateTime.now()),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  DateFormat('h:mm a').format(DateTime.now()),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        '${_currentWeather!.temperature.round()}°',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Feels like ${_currentWeather!.feelsLike.round()}°',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildHourlyForecast(),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    if (_hourlyForecast == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hourly Forecast',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _hourlyForecast!.length,
                itemBuilder: (context, index) {
                  final weather = _hourlyForecast![index];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('h a').format(weather.time),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${weather.temperature.round()}°',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
