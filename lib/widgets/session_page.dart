import 'package:fest_app/models/session.dart';
import 'package:fest_app/utilities/services/database_provider.dart';
import 'package:fest_app/widgets/exercise_set_list.dart';
import 'package:flutter/material.dart';

class SessionPage extends StatefulWidget {
  final Session session;

  const SessionPage({Key? key, required this.session}) : super(key: key);

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        ListTile(title: Text("Current Session: " + widget.session.type)),
        ExerciseSetList(
          session: widget.session,
        )
      ],
    );
  }

  List<Widget> getActions() {
    List<Widget> actions = [];
    if (widget.session.ended == null) {
      actions.add(IconButton(
        icon: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          Session _session = widget.session;
          _session.ended = DateTime.now();
          DatabaseProvider.sessionProvider.updateSession(_session);
          Navigator.pop(context);
        },
      ));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fest2',
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text("FEST 2"),
          backgroundColor: Colors.red,
          actions: getActions(),
        ),
        body: _buildBody(),
      ),
    );
  }
}
