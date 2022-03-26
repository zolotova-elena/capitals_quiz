import 'package:flutter/material.dart';

class QuestionHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const QuestionHeader({
    Key? key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final subtitle = this.subtitle;
    return Column(
      children: [
        if (title != null)
          Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
        if (subtitle != null)
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyText2,
          ),
      ],
    );
  }
}
