import 'dart:async';

import 'package:fest_app/models/session.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/utilities/services/session_manager.dart';
import 'package:fest_app/widgets/error_card.dart';
import 'package:fest_app/widgets/loader.dart';
import 'package:fest_app/widgets/session_list.dart';
import 'package:flutter/material.dart';
import 'package:fest_app/widgets/session.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool currentSessionTypeHistory = false;

  Future<List<Session?>> _loadCurrentSession() async {
    Session? session = await DatabaseProvider.sessionProvider.getLastSession();

    return session != null ? [session] : [];
  }

  void _pushHistoricalSessionsButton() {
    setState(() {
      currentSessionTypeHistory = !currentSessionTypeHistory;
    });
  }

  void _createNewSession(Session? lastSession) async {
    await SessionManager.manager.getNextSession(lastSession);
    setState(() {}); // re-render widget to show new session
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        const ListTile(
            title: Text(
          "Current Session",
        )),
        FutureBuilder(
          builder:
              (BuildContext context, AsyncSnapshot<List<Session?>> snapshot) {
            if (snapshot.hasData) {
              Session? session =
                  snapshot.data!.isNotEmpty ? snapshot.data![0] : null;
              print("SESSION");
              print(session);
              if (session != null && session.ended == null) {
                return SessionWidget(session: snapshot.data![0]!);
              }
              return TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  onPressed: () {
                    _createNewSession(session);
                  },
                  child: const Text('Create new session'));
            } else if (snapshot.hasError) {
              return const ErrorCardWidget(title: "No current session");
            } else {
              return const Loader();
            }
          },
          future: _loadCurrentSession(),
        ),
        ListTile(
          title: const Text("Historical Sessions"),
          trailing: IconButton(
              onPressed: _pushHistoricalSessionsButton,
              icon: currentSessionTypeHistory
                  ? const Icon(Icons.category)
                  : const Icon(Icons.category_outlined)),
        ),
        FutureBuilder(
          builder:
              (BuildContext context, AsyncSnapshot<List<Session?>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 1) {
                return SessionListWidget(
                    sessionType: currentSessionTypeHistory &&
                            snapshot.data![0]?.ended == null
                        ? snapshot.data![0]?.getSessionType()
                        : null);
              } else {
                return const ErrorCardWidget(title: "No current session");
              }
            } else if (snapshot.hasError) {
              return const ErrorCardWidget(title: "No current session");
            } else {
              return const Loader();
            }
          },
          future: _loadCurrentSession(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fest2',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("FEST 2"),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {});
              },
            )
          ],
        ),
        body: _buildBody(),
      ),
    );
  }
}
