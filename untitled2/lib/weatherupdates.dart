import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:untitled2/components/top_navbar.dart';

class WeatherUpdates extends StatelessWidget {
  const WeatherUpdates({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetweatherUpdates(),
    );
  }
}

class GetweatherUpdates extends StatefulWidget {
  const GetweatherUpdates({Key? key});

  @override
  State<GetweatherUpdates> createState() => _GetweatherUpdatesState();
}

class _GetweatherUpdatesState extends State<GetweatherUpdates> {
  String? selectedArea;

  List<String> chennaiAreas = [
    'Chennai',
    'Tambaram',
    'Guindy',
    'Anna Nagar',
    'Mylapore',
    'Adyar',
    'Nungambakkam',
    'Egmore',
    'Royapettah',
    'Kodambakkam',
    'Pallavaram',
    'Ambattur',
    'Porur',
    'Teynampet',
    'Perambur',
    'Kotturpuram',
  ];

  String condition = '';
  double feelslike = 0.0;
  int humidity = 0;
  List<String> icons = [];
  String location = '';
  List<double> temp = [];
  double tempMax = 0.0;
  double tempMin = 0.0;
  List<String> time = [];
  int visibility = 0;
  String windDir = '';
  int windKph = 0;
  String error = '';

  @override
  void initState() {
    super.initState();
    selectedArea = chennaiAreas[0]; 
    fetchWeatherData(selectedArea!);
  }

  Future<void> fetchWeatherData(String location) async {
    final url = 'http://192.168.43.72:5000/get_weather_data?location=$location';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          condition = data['condition'];
          feelslike = data['feelslike'];
          humidity = data['humidity'];
          icons = List<String>.from(data['icon'].map((icon) => 'http://$icon'));
          location = data['location'];
          temp = List<double>.from(data['temp']);
          tempMax = data['temp_max'];
          tempMin = data['temp_min'];
          time = List<String>.from(data['time']);
          visibility = data['visibility'];
        });
      } else {
        setState(() {
          error = 'Failed to fetch weather data';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String currentDay = DateFormat('EEEE').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 72.0),
              child: Row(
                children: [
                  Icon(Icons.pin_drop_outlined),
                  Text(
                    '$selectedArea',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20,),
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    elevation: 20,
                    value: selectedArea,
                    hint: Text('Select Chennai Area'),
                    onChanged: (String? value) {
                      setState(() {
                        selectedArea = value;
                      });
                      // Fetch weather data for the selected location
                      if (value != null) {
                        fetchWeatherData(value);
                        print('Selected Chennai area: $value');
                      }
                    },
                    items: chennaiAreas.map((String area) {
                      return DropdownMenuItem<String>(
                        value: area,
                        child: Text(area),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 72),
            Row(
              children: [
                Padding(padding: const EdgeInsets.only(left: 10, top: 96)),
                Text(
                  '${((tempMax + tempMin) / 2).toInt()}°',
                  style: TextStyle(fontSize: 96),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28, left: 10),
                  child: Text(
                    '$condition',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(padding: const EdgeInsets.only(left: 10)),
                Text(
                  '$currentDay -',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 5),
                Text(
                  '$tempMin°/$tempMax°',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: Colors.grey[200],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Rainfall Forecast',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 150, // Adjust the height as needed
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    temp.length,
                    (index) => WeatherItem(
                      time: time.length > index
                          ? time[index].substring(time[index].length - 5)
                          : '',
                      iconUrl: icons.length > index ? icons[index] : '',
                      temp: temp.length > index ? temp[index] : 0.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WeatherInfoContainer(
                      icon: Icons.thermostat,
                      heading: 'Minimum Temperature',
                      value: '$tempMin°C',
                    ),
                    WeatherInfoContainer(
                      icon: Icons.thermostat,
                      heading: 'Maximum Temperature',
                      value: '$tempMax°C',
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WeatherInfoContainer(
                      icon: Icons.water_drop,
                      heading: 'Humidity',
                      value: '$humidity%',
                    ),
                    WeatherInfoContainer(
                      icon: Icons.thermostat,
                      heading: 'Feels Like',
                      value: '$feelslike°C',
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherItem extends StatelessWidget {
  final String iconUrl;
  final double temp;
  final String time;

  const WeatherItem(
      {Key? key, required this.time, required this.iconUrl, required this.temp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 8),
          Image.network(
            iconUrl,
            width: 64,
            height: 64,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 8),
          Text(
            '${temp.toInt()}°',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class WeatherInfoContainer extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String value;

  const WeatherInfoContainer({
    Key? key,
    required this.icon,
    required this.heading,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
      ),
      height: 175,
      width: 175,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(height: 10),
            Text(
              heading,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
