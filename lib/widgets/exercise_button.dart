import 'dart:async';

import 'package:fest_app/models/exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseButton extends StatefulWidget {
  Exercise exercise;

  ExerciseButton({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseButtonState createState() => _ExerciseButtonState();
}

class _ExerciseButtonState extends State<ExerciseButton> {
  int repetitions = 0;
  bool timer = false;
  late int timerCount;
  late Timer _timer;

  void startTimer() {
    setState(() {
      if (!timer) {timer = true;} else {timer = false;}
    });
    if (timer) {
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
            (Timer timer) async {
          if (timerCount == 0) {
            SystemSound.play(SystemSoundType.click);
            setState(() {
              timer.cancel();
            });
          } else {
            setState(() {
              timerCount--;
            });
          }
        },
      );
    }
  }

  @override
  void initState() {
    repetitions = widget.exercise.repetitions;
    timerCount = widget.exercise.pause != null ? widget.exercise.pause! : 60;
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateExercise() {
    widget.exercise.ended = DateTime.now();
    widget.exercise.repetitions = repetitions;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onLongPress: startTimer,
      onPressed: () {
        setState(() {
          if (repetitions > 1) {
            repetitions--;
          } else if (!timer) {
            startTimer();
          }
        });
      },
      child: Text(timer ? timerCount.toString() : repetitions.toString()),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        primary: Colors.red, // <-- Button color
        onPrimary: Colors.white, // <-- Splash color
      ),
    );
  }
}
