import 'package:flutter/material.dart';

import '../theme.dart';

class CustomAppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final MaterialStateProperty<Size> minSize;
  final MaterialStateProperty<Size> maxSize;
  final Color? textColor;
  final Color? backgroundColor;

  const CustomAppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.minSize,
    required this.maxSize,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: textColor ?? MaterialTheme.lightScheme().primaryFixedDim,
            overflow: TextOverflow.visible),
        softWrap: false,
      ),
      style: ButtonStyle(
        minimumSize: minSize,
        maximumSize: maxSize,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? Colors.transparent) ,
      ),
    );
  }
}
