import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  final String title;
  final String message;
  const CustomNotification({super.key, required this.title, required this.message});

  @override
  /// Builds a custom notification widget.
  ///
  /// A custom notification widget is simply an [AlertDialog] with a
  /// title, content, and an "Ok" button.
  ///
  /// The [title] is the title of the notification.
  ///
  /// The [message] is the content of the notification.
  ///
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
