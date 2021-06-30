import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;

  ConfirmationDialog({Key? key, required this.title, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.headline6),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          onConfirm();
          Navigator.pop(context);
        },
        child: Text('Delete', style: Theme.of(context).primaryTextTheme.button),
      ),
    ];
  }
}
