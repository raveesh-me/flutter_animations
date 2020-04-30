import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableCard(
        child: FlutterLogo(
      size: 128,
    ));
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;

  const DraggableCard({Key key, this.child}) : super(key: key);

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  Widget get child => widget.child;
  AnimationController _controller;

  Animation<Alignment> animation;
  Alignment _dragAlignment;

  @override
  void initState() {
    super.initState();
    _dragAlignment = Alignment.center;
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..addListener(() {
            setState(() {
              _dragAlignment = animation.value;
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  runAnimation(DragEndDetails details, Size size) {
    animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut)
        .drive(AlignmentTween(end: Alignment.center, begin: _dragAlignment));

    final pixelsPerSecond = details.velocity.pixelsPerSecond;
    final speedUnitX = pixelsPerSecond.dx / size.width;
    final speedUnitY = pixelsPerSecond.dy / size.height;
    final speedUnit = Offset(speedUnitX, speedUnitY).distance;

    const spring = SpringDescription(
      damping: 0.3,
      mass: 5,
      stiffness: 0.2,
    );

    final simulation = SpringSimulation(spring, 1, 1, speedUnit);
    _controller.reset();
    _controller.fling(velocity: speedUnit);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {},
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (DragEndDetails details) {
        runAnimation(details, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}
