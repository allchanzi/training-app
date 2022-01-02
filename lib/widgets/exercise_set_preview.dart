import 'package:fest_app/models/exercise.dart';
import 'package:fest_app/models/exercise_set.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/widgets/error_card.dart';
import 'package:fest_app/widgets/exercise_button.dart';
import 'package:fest_app/widgets/loader.dart';
import 'package:flutter/material.dart';

class ExerciseSetPreview extends StatefulWidget {
  ExerciseSet exerciseSet;

  ExerciseSetPreview({Key? key, required this.exerciseSet}) : super(key: key);

  @override
  _ExerciseSetPreviewState createState() => _ExerciseSetPreviewState();
}

class _ExerciseSetPreviewState extends State<ExerciseSetPreview> {
  late TextEditingController textController;

  Future<List<Exercise>> _loadExercises() async {
    return await DatabaseProvider.exerciseProvider
        .getExerciseByExerciseSetId(widget.exerciseSet.id!);
  }

  @override
  void initState() {
    textController =
        TextEditingController(text: widget.exerciseSet.weight.toString());
    super.initState();
  }

  void setSetWeight(num _weight) {
    widget.exerciseSet.setWeight(_weight);
    DatabaseProvider.exerciseSetProvider.updateExerciseSet(widget.exerciseSet);
  }

  Widget _buildList(List<Exercise> exercises) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        ListTile(
          title: const Text('Set weight is (kg): '),
          trailing: SizedBox(
            width: 150.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: textController,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration.collapsed(
                        hintText: widget.exerciseSet.weight.toString()),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    color: Colors.black26,
                    onPressed: () {
                      setSetWeight(num.parse(textController.text));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          children: List.generate(exercises.length,
              (index) => ExerciseButton(exercise: exercises[index])),
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
          return const ErrorCardWidget(title: "No exercises found.");
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
