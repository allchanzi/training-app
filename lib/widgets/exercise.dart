import 'package:fest_app/models/exercise.dart';
import 'package:fest_app/widgets/exercise_page.dart';
import 'package:flutter/material.dart';

class ExerciseWidget extends StatefulWidget {
  final String title;
  final Exercise? exercise;

  const ExerciseWidget({Key? key, required this.title, this.exercise})
      : super(key: key);

  @override
  _ExerciseWidgetState createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExercisePage(
                      exercise: widget.exercise!,
                    )),
          );
        },
        child: ListTile(title: Text(widget.title)),
      ),
    );
  }
}
