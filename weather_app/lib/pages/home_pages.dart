import 'dart:ui';
import 'package:flutter/material.dart';
import '../consts.dart';
import 'package:intl/intl.dart';
import '../services/weatherApi.dart';
import 'SelectCity.dart';
import '../model/model.dart';

class HomePage extends StatefulWidget {
  String cityName;
  HomePage({Key? key, required this.cityName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isBlurred = false;
  final WeatherService weatherService =
      WeatherService(apiKey: OPENWEATHER_API_KEY);
  Weather? _weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeatherForCity(widget.cityName);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchWeatherForCity(widget.cityName);
      isBlurred = false;
    } else {
      setState(() {
        isBlurred = true;
      });
    }
    print(state);
  }

  Future<void> fetchWeatherForCity(String city) async {
    final Weather? data = await weatherService.fetchWeather(city);
    setState(() {
      _weatherData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/broken_clouds.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    if (_weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            locationHeader(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
            ),
            dateTimeInfo(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            weatherIcon(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            currentTemperature(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            extraInfo(),
            if (isBlurred)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              )
          ],
        ),
      ]),
    );
  }

  Widget locationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 63),
            child: Center(
              child: Text(
                _weatherData?.name ?? "",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            disabledBackgroundColor: const Color.fromARGB(0, 163, 29, 29),
            backgroundColor: const Color.fromARGB(255, 223, 221, 221),
            iconColor: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectCityName(),
              ),
            );
          },
          child: const Icon(Icons.search),
        ),
      ],
    );
  }

  Widget dateTimeInfo() {
    DateTime now = DateTime.now();

    return Column(children: [
      Text(
        DateFormat("HH:mm").format(now),
        style: const TextStyle(fontSize: 22),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            DateFormat("EEE").format(now),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            "  ${DateFormat("d.M.y").format(now)}",
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      )
    ]);
  }

  Widget weatherIcon() {
    String? iconCode = _weatherData?.weather[0].icon;
    String? description = _weatherData?.weather[0].description;

    return Column(
      children: [
        if (iconCode != null)
          Container(
            height: MediaQuery.sizeOf(context).height * 0.20,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "http://openweathermap.org/img/wn/$iconCode@4x.png"),
              ),
            ),
          ),
        Text(
          description ?? "",
          style: const TextStyle(fontSize: 20, color: Colors.black),
        )
      ],
    );
  }

  Widget currentTemperature() {
    return Text(
      "${_weatherData?.main.temp.round()}°C",
      style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold),
    );
  }

  Widget extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.8,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Max: ${_weatherData?.main.tempMax.round()}°C",
                  style: const TextStyle(fontSize: 15, color: Colors.white)),
              Text("Min: ${_weatherData?.main.tempMin.round()}°C",
                  style: const TextStyle(fontSize: 15, color: Colors.white))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Humidity: ${_weatherData?.main.humidity ?? ''}%",
                  style: const TextStyle(fontSize: 15, color: Colors.white)),
              Text("Wind: ${_weatherData?.wind.speed.toString()} km/h",
                  style: const TextStyle(fontSize: 15, color: Colors.white))
            ],
          )
        ],
      ),
    );
  }
}
