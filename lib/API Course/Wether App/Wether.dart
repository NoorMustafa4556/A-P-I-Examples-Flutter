import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class Wether extends StatefulWidget {
  const Wether({super.key});

  @override
  State<Wether> createState() => _WetherState();
}

class _WetherState extends State<Wether> {
  String cityName = "Loading...";
  String temperature = "--";
  String weatherDescription = "--";
  String weatherIcon = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      // Check and request location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          cityName = "Location disabled";
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            cityName = "Location permission denied";
            isLoading = false;
          });
          return;
        }
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch weather data
      final apiKey = 'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cityName = data['name'];
          temperature = "${data['main']['temp'].toStringAsFixed(1)}°C";
          weatherDescription = data['weather'][0]['description'];
          weatherIcon = data['weather'][0]['icon'];
          isLoading = false;
        });
      } else {
        setState(() {
          cityName = "Error fetching data";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        cityName = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome To Weather App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: CupertinoColors.activeGreen,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (weatherIcon.isNotEmpty)
                Image.network(
                  'https://openweathermap.org/img/wn/$weatherIcon@2x.png',
                  width: 100,
                  height: 100,
                ),
              const SizedBox(height: 20),
              Text(
                temperature,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                weatherDescription.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchWeatherData,
                child: const Text("Refresh"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}