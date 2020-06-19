import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
void main() {
  runApp(WelcomeScreen());
}

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// State control class of the Welcome Screen state
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin<WelcomeScreen> {
  AnimationController controller;

  // Build skeleton of the animation
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: StaggeredAnimation(controller: controller)));
  }

  // Reverse animation back to start and jump to elevation
  Future<void> reverseAndElevateDown() async {
    await controller.animateBack(0.0);
    await controller.forward(from: 0.5);
  }

  // Initialize controller and addListener to it
  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 6), vsync: this)
      ..addListener(() {
        if (controller.value >= 0.4 && controller.value < 0.5) {
          reverseAndElevateDown();
        }
      });
  }

  // Dispose controller to prevent resources overuse
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class StaggeredAnimation extends StatelessWidget {

  // Constructor along with animation Tweens initialization
  StaggeredAnimation({Key key, this.controller}):

  // Reconstruction Tweens
        flip = Tween(begin: 0.0, end: 2 * pi)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.4, curve: Curves.bounceIn))),
        size = Tween(begin: 80.0, end: 120.0)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.4, curve: Curves.bounceIn))),
        elevation = Tween(begin: 15.0, end: 0.0)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 0.7, curve: Curves.ease))),
        mouth = Tween(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.8, 1.0))),

  // Color Tweens
        eyeColorAUR = ColorTween(begin: Colors.blueAccent, end: Colors.white12)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 1.0))),
        eyeColorABL = ColorTween(begin: Colors.cyanAccent, end: Colors.white12)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 1.0))),
        eyeColorBUR = ColorTween(begin: Colors.blueAccent, end: Colors.white12)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5, curve: Curves.bounceIn))),
        eyeColorBBL = ColorTween(begin: Colors.cyanAccent, end: Colors.blueAccent)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5))),

        mouthBordersColor = ColorTween(begin: Colors.black12, end: Colors.white30)
            .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.8, 1.0))),
        super(key: key);

  // Initialize variables
  // Reconstruction
  final Animation<double> flip;
  final Animation<double> size;
  final Animation<double> mouth;
  final Animation<double> elevation;

  // Color
  final Animation<Color> eyeColorBUR;
  final Animation<Color> eyeColorBBL;
  final Animation<Color> eyeColorAUR;
  final Animation<Color> eyeColorABL;
  final Animation<Color> mouthBordersColor;

  final AnimationController controller;

  // Main function to build skeleton of the animation
  Widget _buildAnimation(BuildContext context, Widget child) {
    return Stack(children: [

      Column(children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        SizedBox(
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.2, color: mouthBordersColor.value),
              )),
          height: MediaQuery.of(context).size.height * mouth.value,
        ),
        Expanded(
          child: SizedBox(),
        )
      ]),
      Center(
          child: GestureDetector(
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.rotationY(flip.value),
              child: Material(
                shape: CircleBorder(),
                elevation: elevation.value,
                shadowColor: Colors.blueAccent,
                child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return ui.Gradient.linear(
                        Offset(4.0, 24.0),
                        Offset(24.0, 4.0),
                        [
                          (controller.value < 0.5) ? eyeColorBBL.value : eyeColorABL.value,
                          (controller.value < 0.5) ? eyeColorBUR.value : eyeColorAUR.value,
                        ],
                      );
                    },
                    child: Icon(
                      Icons.monetization_on,
                      size: controller.value < 0.5 ? size.value : 80.0,
                    )),
              ),
            ),
            onTap: () {
              controller.forward();
            },
          )),
      SafeArea(child: Container(margin: EdgeInsets.only(left: 90,top: 30,),child: Text("💵 Coin FLipper 💵",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600),))),
    ]);
  }

  // Just holds Animation Builder and calls _buildAnimation
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
