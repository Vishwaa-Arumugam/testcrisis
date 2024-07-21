import 'package:flutter/material.dart';

class VictimNotification extends StatelessWidget {
  const VictimNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return NotoficationPage();
  }
}

class NotoficationPage extends StatefulWidget {
  const NotoficationPage({super.key});

  @override
  State<NotoficationPage> createState() => _NotoficationPageState();
}

class _NotoficationPageState extends State<NotoficationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Notofication Screen for victim'),
      ),
    );
  }
}