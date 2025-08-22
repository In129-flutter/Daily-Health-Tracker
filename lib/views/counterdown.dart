/* import 'dart:async';
import 'package:flutter/material.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  int seconds = 600; // 10 minutes
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return Scaffold(
      appBar: AppBar(title: Text("Countdown Timer")),
      body: Center(
        child: Text(
          "$minutes:${secs.toString().padLeft(2, '0')}",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
*/