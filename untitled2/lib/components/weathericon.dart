import 'package:flutter/material.dart';

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