import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;

  ShadowContainer({ this.child, this.color, this.padding });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 20.0, // has the effect of softening the shadow
                spreadRadius: 10.0, // has the effect of extending the shadow
                offset: Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ]),
        padding: padding ?? EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child: child,
      ),
    );
  }
}
