import 'package:flutter/material.dart';
import '../utilities/services/app_bloc.dart';
import 'home_page.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Change design
    return StreamBuilder(
      stream: appBloc.appEventsStream,
      builder: (context, snapshot) {
        switch (snapshot.data) {
          case AppEvent.onAppInitialized:
            return const HomePage();
        }
        return MaterialApp(
          home: AppBar(title: const Text("Getting readdy")),
        );
      },
    );
  }
}
