import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final bool light;
  final VoidCallback? onToggle;

  const Settings({
    Key? key,
    this.light = true,
    this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: Container(
        child: IconButton(
          icon: Icon(
            light ? Icons.nightlight_round : Icons.wb_sunny_outlined,
          ),
          onPressed: () => onToggle?.call(),
        ),
      ),
    );
  }
}
