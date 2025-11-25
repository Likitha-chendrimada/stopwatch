import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late Timer _timer;
  int milliseconds = 0;
  bool isRunning = false;
  final player = AudioPlayer();

  void playClickSound() {
    player.play(AssetSource('click.mp3')); // add sound in assets folder
  }

  void vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 80);
    }
  }

  void startTimer() {
    playClickSound();
    vibrate();

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        milliseconds += 10;
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    playClickSound();
    vibrate();

    _timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    playClickSound();
    vibrate();

    _timer.cancel();
    setState(() {
      milliseconds = 0;
      isRunning = false;
    });
  }

  String formatTime(int ms) {
    int minutes = (ms / 60000).floor();
    int seconds = ((ms % 60000) / 1000).floor();
    int milli = (ms % 1000) ~/ 10;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}:"
        "${milli.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.blueGrey.shade900,
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatTime(milliseconds),
              style: TextStyle(
                color: Colors.white,
                fontSize: 70,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 50),

            // Modern Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circleButton(
                  text: "Start",
                  onTap: isRunning ? null : startTimer,
                  color: Colors.greenAccent,
                ),
                SizedBox(width: 20),
                circleButton(
                  text: "Pause",
                  onTap: isRunning ? stopTimer : null,
                  color: Colors.orangeAccent,
                ),
                SizedBox(width: 20),
                circleButton(
                  text: "Reset",
                  onTap: resetTimer,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Circular Modern Button
  Widget circleButton({required String text, required Function()? onTap, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey.shade800 : color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 3,
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
