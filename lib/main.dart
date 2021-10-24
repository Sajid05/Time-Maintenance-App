import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:time_maintenance_application/timeMode.dart';
import 'timeMode.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;

  bool _isPause = true;
  bool _isModeButtonPressed = false;
  String _textMin = "02";
  String _textSecond = "00";

  timeMode _mode = timeMode(min: -1, second: -1, color: Colors.grey[800]);

  modeButtonPressed() {
    _isModeButtonPressed = true;
    _isPause = true;
    _mode.min < 10
        ? _textMin = "0" + _mode.min.toString()
        : _textMin = _mode.min.toString();
    _mode.second < 10
        ? _textSecond = "0" + _mode.second.toString()
        : _textSecond = _mode.second.toString();
    setState(() {});
  }

  workMode() {
    _mode = timeMode(color: Colors.amber[600], min: 20, second: 0);

    modeButtonPressed();
  }

  studyMode() {
    _mode = timeMode(color: Colors.green[600], min: 0, second: 5);
    modeButtonPressed();
  }

  sleepMode() {
    _mode = timeMode(color: Colors.purple[400], min: 15, second: 0);
    modeButtonPressed();
  }

  actionbuttonPressed() {
    if (_mode.min == -1) {
      return;
    }
    if (_isPause) {
      _isPause = false;
      _isModeButtonPressed = false;

      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!_isModeButtonPressed) {
          setState(() {
            _mode.second -= 1;
            if (_mode.second < 0) {
              _mode.min -= 1;
              _mode.second = 59;
            }
            _mode.min < 10
                ? _textMin = "0" + _mode.min.toString()
                : _textMin = _mode.min.toString();
            _mode.second < 10
                ? _textSecond = "0" + _mode.second.toString()
                : _textSecond = _mode.second.toString();
          });

          if (_mode.min < 0) {
            stopTimer();
          }
        } else {
          timer!.cancel();
        }
      });
    } else {
      _isPause = true;
      timer!.cancel();
      setState(() {});
    }
  }

  stopTimer() async {
    timer!.cancel();
    setState(() {
      _mode.min = -1;
      _mode.second = 0;
      _mode.color = Colors.grey[800];
      _isPause = true;
    });
    // AudioPlayer audioPlayer = AudioPlayer();

    AudioCache audioCache = AudioCache();
    audioCache.load("sounds/alert.mp3");
    audioCache.play("sounds/alert.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Time Maintenance Application"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: workMode,
                  child: const Text(
                    "Work",
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber[600],
                  )),
              ElevatedButton(
                  onPressed: studyMode,
                  child: const Text(
                    "Study",
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[600],
                  )),
              ElevatedButton(
                  onPressed: sleepMode,
                  child: const Text(
                    "Speed Nap",
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[400],
                  )),
            ],
          ),
          const SizedBox(
            height: 180,
          ),
          Stack(alignment: Alignment.center, children: [
            Transform.scale(
              scale: 5,
              child: CircularProgressIndicator(
                value: (_mode.second / 60),
                backgroundColor: _mode.color,
                color: Colors.black,
                strokeWidth: 2,
              ),
            ),
            _mode.min != -1
                ? Text(
                    "$_textMin : $_textSecond",
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text(
                    "Choose Mode",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
          ]),
          const SizedBox(
            height: 200,
          ),
          FloatingActionButton(
              onPressed: actionbuttonPressed,
              elevation: 2,
              hoverElevation: 8,
              child: _isPause
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause)),
        ],
      ),
    );
  }
}
