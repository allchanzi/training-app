import 'package:fest_app/widgets/launch_page.dart';
import 'package:flutter/material.dart';

import 'utilities/services/app_bloc.dart';
import 'widgets/launch_page.dart';
void main() => runApp(App());

class App extends StatefulWidget {

  App({Key? key}) : super(key: key) {
    appBloc.dispatch(AppEvent.onStart);
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return const LaunchPage();
  }

  @override
  void dispose() {
    appBloc.dispatch(AppEvent.onStop);
    super.dispose();
  }
}