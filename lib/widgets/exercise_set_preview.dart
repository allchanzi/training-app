import 'package:fest_app/models/exercise.dart';
import 'package:fest_app/models/exercise_set.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/widgets/error_card.dart';
import 'package:fest_app/widgets/exercise_button.dart';
import 'package:fest_app/widgets/loader.dart';
import 'package:flutter/material.dart';

class ExerciseSetPreview extends StatefulWidget {
  final ExerciseSet exerciseSet;

  const ExerciseSetPreview({Key? key, required this.exerciseSet})
      : super(key: key);

  @override
  _ExerciseSetPreviewState createState() => _ExerciseSetPreviewState();
}

class _ExerciseSetPreviewState extends State<ExerciseSetPreview> {
  Future<List<Exercise>> _loadExercises() async {
    return await DatabaseProvider.exerciseProvider
        .getExerciseByExerciseSetId(widget.exerciseSet.id!);
  }

  Widget _buildList(List<Exercise> exercises) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        const ListTile(title: Text("Sets")),
        Row(
          children: List.generate(exercises.length,
              (index) => ExerciseButton(exercise: exercises[index])
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return _buildList(snapshot.data!);
          }
          return ErrorCardWidget(title: "No exercises found.");
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return ErrorCardWidget(
            title: "Some error: " + snapshot.error.toString(),
          );
        } else {
          return const Loader();
        }
      },
      future: _loadExercises(),
    );
  }
}
