import 'package:flutter/material.dart';

import 'fade_sized_text.dart';

class Controls extends StatelessWidget {
  final ValueChanged<bool>? onAnswer;

  const Controls({Key? key, this.onAnswer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkResponse(
          onTap: () => onAnswer?.call(false),
          child: FadeSizedText(
            'No',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        InkResponse(
          onTap: () => onAnswer?.call(true),
          child: FadeSizedText(
            'Yes',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }
}