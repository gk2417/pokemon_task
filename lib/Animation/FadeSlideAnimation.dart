import 'package:flutter/material.dart';

class FadeSlideAnimation extends StatelessWidget {
  final Widget child;
  final Offset beginOffset;
  final Duration duration;
  final Curve curve;

  const FadeSlideAnimation({
    super.key,
    required this.child,
    this.beginOffset = const Offset(0, 0.3),
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: beginOffset, end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, offset, child) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: duration,
          curve: curve,
          builder: (context, opacity, _) {
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(
                  offset.dx * MediaQuery.of(context).size.width,
                  offset.dy * MediaQuery.of(context).size.height,
                ),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
      child: child,
    );
  }
}
