import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(LogoApp());

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: FlutterLogo(),
    );
  }
}

class GrowTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const GrowTransition({this.animation, this.child});


  @override
  Widget build(BuildContext context) {
    Tween<double> growValue = Tween(begin: 200, end: 500);
    Tween<double> rotateValue = Tween(begin: pi, end: 3 * pi / 2);

    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) => Transform.rotate(
          angle: rotateValue.evaluate(animation),
          child: Container(
            height: growValue.evaluate(animation),
            width: growValue.evaluate(animation),
            child: child,
          ),
        ),
        child: child,
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Animation curvedControl;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          controller.reverse();
        else if (status == AnimationStatus.dismissed) controller.forward();
      })
      ..forward();
    curvedControl = CurvedAnimation(
      curve: Curves.bounceOut,
      parent: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GrowTransition(
          animation: curvedControl,
          child: LogoWidget(),
        ),
      ),
    );
  }
}
