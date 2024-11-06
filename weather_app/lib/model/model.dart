class Weather {
  final int id;
  final String name;
  final String base;
  final int timezone;
  final int cod;
  final int dt;
  final Sys sys;
  final Main main;
  final Wind wind;
  final Clouds clouds;
  final List<WeatherDescription> weather;

  Weather({
    required this.id,
    required this.name,
    required this.base,
    required this.timezone,
    required this.cod,
    required this.dt,
    required this.sys,
    required this.main,
    required this.wind,
    required this.clouds,
    required this.weather,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      name: json['name'],
      base: json['base'],
      timezone: json['timezone'],
      cod: json['cod'],
      dt: json['dt'],
      sys: Sys.fromJson(json['sys']),
      main: Main.fromJson(json['main']),
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      weather: (json['weather'] as List)
          .map((item) => WeatherDescription.fromJson(item))
          .toList(),
    );
  }
}

class WeatherDescription {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherDescription({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherDescription.fromJson(Map<String, dynamic> json) {
    return WeatherDescription(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int grndLevel;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'] ?? 0.0.toDouble(),
      feelsLike: json['feels_like'] ?? 0.0.toDouble(),
      tempMin: json['temp_min'] ?? 0.0.toDouble(),
      tempMax: json['temp_max'] ?? 0.0.toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
    );
  }
}

class Wind {
  final double speed;
  final int deg;
  final double gust;

  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'] ?? 0.0.toDouble(),
      deg: json['deg'],
      gust: json['gust'] ?? 0.0.toDouble(),
    );
  }
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }
}

class Sys {
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}
