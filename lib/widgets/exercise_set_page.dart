import 'package:fest_app/models/exercise_set.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/widgets/error_card.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ExerciseSetPage extends StatefulWidget {
  final ExerciseSet exerciseSet;

  const ExerciseSetPage({Key? key, required this.exerciseSet})
      : super(key: key);

  @override
  _ExerciseSetPageState createState() => _ExerciseSetPageState();
}

class _ExerciseSetPageState extends State<ExerciseSetPage> {
  Future<List<ExerciseSet>> _loadExerciseHistory() async {
    return await DatabaseProvider.exerciseSetProvider
        .getExerciseSetByType(widget.exerciseSet.name);
  }

  List<ExerciseSetData> _generateExerciseData(List<ExerciseSet> exercises) {
    return List.generate(
        exercises.length,
        (index) => ExerciseSetData(
            exercises[index].ended == null
                ? DateTime.now()
                : exercises[index].ended!,
            exercises[index].weight.toDouble()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<List<ExerciseSet>> snapshot) {
        if (snapshot.hasData) {
          List<ExerciseSetData> data = _generateExerciseData(snapshot.data!);
          return SfCartesianChart(
              // Initialize category axis
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType.days,
              ),
              primaryYAxis: CategoryAxis(),
              series: <LineSeries<ExerciseSetData, DateTime>>[
                LineSeries<ExerciseSetData, DateTime>(
                  // Bind data source
                  dataSource: data,
                  xValueMapper: (ExerciseSetData exercises, _) =>
                      exercises.date,
                  yValueMapper: (ExerciseSetData exercises, _) =>
                      exercises.weight,
                )
              ]);
        } else if (snapshot.hasError) {
          return ErrorCardWidget(title: snapshot.error.toString());
        } else {
          return const ErrorCardWidget(title: "No History");
        }
      },
      future: _loadExerciseHistory(),
    );
  }
}

class ExerciseSetData {
  ExerciseSetData(this.date, this.weight);

  late DateTime date = DateTime.now();
  final double weight;
}
