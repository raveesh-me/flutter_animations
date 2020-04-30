import 'package:flutter/material.dart';

void main() => runApp(LogoApp());

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(seconds: 2),
    )
      ..addListener(
        () {
          setState(() {});
        },
      )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          controller.reverse();
        else if (status == AnimationStatus.dismissed) controller.forward();
      })
      ..forward();

    animation = Tween<double>(begin: 50.0, end: 100.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatingLogo(
      animation: animation,
    );
  }
}

class AnimatingLogo extends AnimatedWidget {
  final Animation animation;

  AnimatingLogo({Key key, @required this.animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.translationValues(
            animation.value * (-1), animation.value, animation.value / 10),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: animation.value,
          width: animation.value,
          child: FlutterLogo(),
        ),
      ),
    );
  }
}
