import 'package:flutter/material.dart';

class BackgrounndColorTransition extends StatefulWidget {
  @override
  _BackgrounndColorTransitionState createState() =>
      _BackgrounndColorTransitionState();
}

class _BackgrounndColorTransitionState extends State<BackgrounndColorTransition>
    with SingleTickerProviderStateMixin {
  Animatable<Color> background = TweenSequence<Color>(
    [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.red,
          end: Colors.green,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.green,
          end: Colors.blue,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.blue,
          end: Colors.pink,
        ),
      ),
    ],
  );
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              color: background.evaluate(
                AlwaysStoppedAnimation(_controller.value),
              ),
            );
          }),
    );
  }
}
