import 'package:animation_task/images.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Animation Task"),
        ),
        body: const CircularAnimation(),
      ),
    );
  }
}

// List of image paths
final List<String> _imagePaths = [item1, item2, item3, item4, item5, item6];

class CircularAnimation extends StatefulWidget {
  const CircularAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CircularAnimationState createState() => _CircularAnimationState();
}

class _CircularAnimationState extends State<CircularAnimation>  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _textScaleAnimation; //Initialization of variabe
  late Animation<double> _rotationAnimation;

  final int textAnimationDuration = 1500;
  final int imageAnimationDuration = 300; // Defining time for each animation
  late int totalImageAnimationDuration;
  final int rotationDuration = 6000;

  @override
  void initState() {
    super.initState();

    totalImageAnimationDuration = _imagePaths.length *
        imageAnimationDuration; // Calculating total time for total number of images

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: textAnimationDuration +
              totalImageAnimationDuration +
              rotationDuration +
              1000), 
    );

    _textScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
            0.0,
            textAnimationDuration /
                (textAnimationDuration +
                    totalImageAnimationDuration +
                    rotationDuration +
                    1000),
            curve: Curves.easeInOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          (textAnimationDuration + totalImageAnimationDuration + 1000) /
              (textAnimationDuration +
                  totalImageAnimationDuration +
                  rotationDuration +
                  1000),
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle getBoldTextStyle() {
    return const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.black, 
      shadows: [
        Shadow(
          offset: Offset(0, 0),
          blurRadius: 3.0,
          color: Colors.black,
        ),
        Shadow(
          offset: Offset(1, 1),
          blurRadius: 0.0,
          color: Colors.black,
        ),
        Shadow(
          offset: Offset(-1, -1),
          blurRadius: 0.0,
          color: Colors.black,
        ),
        Shadow(
          offset: Offset(1, -1),
          blurRadius: 0.0,
          color: Colors.black,
        ),
        Shadow(
          offset: Offset(-1, 1),
          blurRadius: 0.0,
          color: Colors.black,
        ),
        // Shadow(
        //   offset: Offset(-3, 3),
        //   blurRadius: 0.0,
        //   color: Colors.white,
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.yellow,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Central Text with Scaling Animation
              ScaleTransition(
                scale: _textScaleAnimation,
                child: Text(
                  "MIX &\n MATCH!\n\$5.99",
                  textAlign: TextAlign.center,
                  style: getBoldTextStyle(),
                ),
              ),
              // Circular Animated Images
              for (int i = 0; i < _imagePaths.length; i++)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final double angle = (2 * pi / _imagePaths.length) * i +
                        (_rotationAnimation.value);
                    const double radius = 89; //  Circle size
                    final double x = radius * cos(angle);
                    final double y = radius * sin(angle);
                    final double aspectRatioWidth =
                        MediaQuery.of(context).size.width;
                    final double aspectRatioHeight =
                        MediaQuery.of(context).size.height;
                    final double left =
                        (aspectRatioWidth / 2) + x - 37; // Adjust for X-axis
                    final double top =
                        (aspectRatioHeight / 2) + y - 360; // Adjust for Y-axis

                    return Positioned(
                      left: left,
                      top: top,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              (textAnimationDuration +
                                          i * imageAnimationDuration)
                                      .toDouble() /
                                  (textAnimationDuration +
                                      totalImageAnimationDuration +
                                      rotationDuration +
                                      1000),
                              (textAnimationDuration +
                                          (i + 1) * imageAnimationDuration)
                                      .toDouble() /
                                  (textAnimationDuration +
                                      totalImageAnimationDuration +
                                      rotationDuration +
                                      1000),
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                        child: child!,
                      ),
                    );
                  },
                  child: Image.asset(
                    _imagePaths[i],
                    width: 78,
                    height: 78,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
