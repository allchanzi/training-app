import 'package:fest_app/models/exercise_set.dart';
import 'package:fest_app/models/session.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/widgets/error_card.dart';
import 'package:fest_app/widgets/exercise_set.dart';
import 'package:fest_app/widgets/loader.dart';
import 'package:flutter/material.dart';

class ExerciseSetList extends StatefulWidget {
  final Session session;

  const ExerciseSetList({Key? key, required this.session}) : super(key: key);

  @override
  _ExerciseSetListState createState() => _ExerciseSetListState();
}

class _ExerciseSetListState extends State<ExerciseSetList> {
  Future<List<ExerciseSet>> _loadExerciseSets() async {
    return await DatabaseProvider.exerciseSetProvider.getExerciseSetsBySessionId(widget.session.id!);
  }

  Widget _buildRow(ExerciseSet set) {
    return ExerciseSetWidget(title: set.name, exerciseSet: set);
  }

  Widget _buildList(List<ExerciseSet> _sets) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _sets.length,
        itemBuilder: (context, int i) {
          return _buildRow(_sets[i]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<List<ExerciseSet>> snapshot) {
        if (snapshot.hasData) {
          return _buildList(snapshot.data!);
        } else if (snapshot.hasError) {
          return const ErrorCardWidget(title: "Error");
        } else {
          return const Loader();
        }
      },
      future: _loadExerciseSets(),
    );
  }
}
