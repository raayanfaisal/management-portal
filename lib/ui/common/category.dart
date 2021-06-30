import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String name;
  final Color color;
  final EdgeInsets padding;
  final VoidCallback? onPressed;

  const Category({
    Key? key,
    required this.name,
    required this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelStyle = color.computeLuminance() > 0.5
        ? Theme.of(context).textTheme.bodyText2
        : Theme.of(context).primaryTextTheme.bodyText2;

    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: InkWell(
        onTap: onPressed,
        child: Padding(padding: padding, child: Text(name, style: labelStyle)),
      ),
    );
  }
}
