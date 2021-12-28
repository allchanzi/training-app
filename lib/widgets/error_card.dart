import 'package:fest_app/models/session.dart';
import 'package:fest_app/widgets/session_page.dart';
import 'package:flutter/material.dart';

class ErrorCardWidget extends StatelessWidget {
  final String title;

  const ErrorCardWidget({Key? key, required this.title, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(title)),
      );
  }
}
