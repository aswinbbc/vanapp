import 'package:flutter/material.dart';

extension ContainerSub on Widget {
  Container withBorder({
    double borderRadius = 5.0,
    double borderWidth = 1,
    Color? borderColor,
    double verticalPadding = 0,
    double horizontalPadding = 0,
    double verticalMargin = 0,
    double horizontalMargin = 0,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin, vertical: verticalMargin),
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        border:
            Border.all(width: borderWidth, color: borderColor ?? Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: this,
    );
  }
}
