import 'dart:async';

import 'package:fest_app/models/exercise.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseButton extends StatefulWidget {
  final Exercise exercise;

  const ExerciseButton({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseButtonState createState() => _ExerciseButtonState();
}

class _ExerciseButtonState extends State<ExerciseButton> {
  late Exercise exercise;
  int repetitions = 0;
  bool timer = false;
  int timerCount = 0;
  late Timer _timer;

  void startTimer() {
    setState(() {
      timer = true;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        if (timerCount == 0) {
          SystemSound.play(SystemSoundType.click);
          _updateExercise();
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

  void stopTimer() {
    setState(() {
      try {
        _timer.cancel();
      } catch (error) {
        if ("LateError" != error.runtimeType.toString()) {
          print(error);
        }
      }
      timer = false;
    });
  }

  @override
  void initState() {
    exercise = widget.exercise;
    repetitions = exercise.repetitions;
    timerCount = getPause();
    super.initState();
  }

  @override
  void dispose() {
    try {
      _timer.cancel();
    } catch (error) {
      if ("LateError" != error.runtimeType.toString()) {
        print(error);
      }
    }
    super.dispose();
  }

  void _onLongPress() {
    if (!timer) {
      startTimer();
    } else {
      stopTimer();
      _updateExercise();
    }
  }

  void _onButtonPressed() {
    setState(() {
      if (!timer) {
        repetitions--;
        if (repetitions == 0) {
          startTimer();
        }
      }
    });
  }

  int getPause() {
    return widget.exercise.pause != null ? widget.exercise.pause! : 60;
  }

  bool isDisabled() {
    return widget.exercise.ended != null;
  }

  String getButtonText() {
    return isDisabled() ? widget.exercise.repetitions.toString() : timer ? timerCount.toString() : repetitions.toString();
  }

  void _updateExercise() async {
    exercise.endExercise();
    exercise.setRepetitions(exercise.repetitions - repetitions);
    exercise.setPause(getPause() - timerCount);
    DatabaseProvider.exerciseProvider.updateExercise(exercise);
    exercise = (await DatabaseProvider.exerciseProvider.reloadExercise(exercise))!;
    reload();
  }

  void reload() {
    setState(()  {});
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onLongPress: isDisabled() ? () {} : _onLongPress,
      onPressed: isDisabled() ? () {} : _onButtonPressed,
      child: Text(getButtonText()),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        // padding: const EdgeInsets.all(20),
        primary: isDisabled() ? Colors.green : Colors.red, // <-- Button color
        onPrimary: Colors.white, // <-- Splash color
      ),
    );
  }
}
