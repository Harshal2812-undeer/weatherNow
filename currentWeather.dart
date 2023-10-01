import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:weather_application/models/weather.dart';
import 'package:http/http.dart' as http;

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  String city = "Jalgaon"; // Default city

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                city = value;
              });
            },
            decoration: InputDecoration(
              labelText: "Enter city",
            ),
          ),
          Expanded(
            child: FutureBuilder<Weather?>(
              future: getCurrentWeather(city),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error getting weather");
                } else if (snapshot.hasData) {
                  Weather? _weather = snapshot.data;
                  if (_weather != null) {
                    return weatherBox(_weather);
                  } else {
                    return Text("No data");
                  }
                } else {
                  return Text("No data");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget weatherBox(Weather _weather) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("${_weather.temp} degree Celsius"),
          Text("${_weather.description}"),
          Text("Feels: ${_weather.feelsLike} degree Celsius"),
          Text(
              "H: ${_weather.high} degree Celsius L: ${_weather.low} degree Celsius")
        ],
      ),
    );
  }

  Future<Weather?> getCurrentWeather(String city) async {
    Weather? weather;
    String apikey = "your api key";
    var url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apikey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body));
    } else {
      print("Error");
    }
    return weather;
  }
}
