import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;

  ShadowContainer({ this.child, this.color, this.padding });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      shadowColor: Colors.blueGrey.shade100.withAlpha(100),
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child: child,
      ),
    );
  }
}
