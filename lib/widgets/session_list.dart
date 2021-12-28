import 'package:fest_app/models/session.dart';
import 'package:fest_app/utilities/data_sources/session_data_source.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/widgets/error_card.dart';
import 'package:fest_app/widgets/loader.dart';
import 'package:fest_app/widgets/session.dart';
import 'package:flutter/material.dart';

class SessionListWidget extends StatefulWidget {
  final String? sessionType;

  const SessionListWidget({Key? key, this.sessionType}) : super(key: key);

  @override
  _SessionListWidgetState createState() => _SessionListWidgetState();
}

class _SessionListWidgetState extends State<SessionListWidget> {
  Future<List<Session>> _loadSessions() async {
    return await DatabaseProvider.sessionProvider.getSessionsByType(widget.sessionType);
  }

  Widget _buildRow(Session session) {
    return SessionWidget(session: session);
  }

  Widget _buildList(List<Session> _sessions) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _sessions.length,
        itemBuilder: (context, int i) {
          return _buildRow(_sessions[i]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Session>> snapshot) {
        if (snapshot.hasData) {
          return _buildList(snapshot.data!);
        } else if (snapshot.hasError) {
          return const ErrorCardWidget(title: "ERROR");
        } else {
          return const Loader();
        }
      },
      future: _loadSessions(),
    );
  }
}
