import 'package:fest_app/models/session.dart';
import 'package:fest_app/widgets/session_page.dart';
import 'package:flutter/material.dart';

class SessionWidget extends StatelessWidget {
  final Session session;

  const SessionWidget({Key? key, required this.session})
      : super(key: key);

  String getTitle() {
    return "Session " + session.type + " from: " + session.started.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SessionPage(session: session)),
          );
        },
        child: ListTile(title: Text(getTitle())),
      ),
    );
  }
}
