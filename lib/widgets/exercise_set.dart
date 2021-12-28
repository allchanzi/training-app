import 'package:fest_app/models/exercise_set.dart';
import 'package:fest_app/widgets/exercise_set_page.dart';
import 'package:fest_app/widgets/exercise_set_preview.dart';
import 'package:flutter/material.dart';


class ExerciseSetWidget extends StatefulWidget {
  final String title;
  final ExerciseSet exerciseSet;

  const ExerciseSetWidget({Key? key, required this.title, required this.exerciseSet})
      : super(key: key);

  @override
  _ExerciseSetWidgetState createState() => _ExerciseSetWidgetState();
}

class _ExerciseSetWidgetState extends State<ExerciseSetWidget> {
  bool showDetail = false;

  void _showExerciseSetPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ExerciseSetPage(
            exerciseSet: widget.exerciseSet,
          )
      ),
    );
  }

  Widget getCardContent() {
    ListTile exerciseSetNameWidget = ListTile(title: Text(widget.title),
      trailing: IconButton(
          onPressed: _showExerciseSetPage,
          icon: const Icon(Icons.more_vert))
    );
    if (!showDetail) {
      return exerciseSetNameWidget;
    }
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        exerciseSetNameWidget,
        ExerciseSetPreview(exerciseSet: widget.exerciseSet)

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            showDetail = !showDetail;
          });
        },
        child: getCardContent(),
      ),
    );
  }
}
