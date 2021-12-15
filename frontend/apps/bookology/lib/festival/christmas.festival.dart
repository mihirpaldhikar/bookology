/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:math';

import 'package:flutter/material.dart';

class SnowWidget extends StatefulWidget {
  final int totalSnow;
  final double speed;
  final bool isRunning;
  final Widget child;

  const SnowWidget(
      {Key? key,
      required this.totalSnow,
      required this.speed,
      required this.isRunning,
      required this.child})
      : super(key: key);

  @override
  _SnowWidgetState createState() => _SnowWidgetState();
}

class _SnowWidgetState extends State<SnowWidget>
    with SingleTickerProviderStateMixin {
  late Random _rnd;
  late AnimationController controller;
  late Animation animation;
  List<Snow> _snows = [];
  double angle = 0;
  double W = 0;
  double H = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _rnd = Random();

    controller = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        vsync: this,
        duration: const Duration(milliseconds: 20000));
    controller.addListener(() {
      if (mounted) {
        setState(() {
          update();
        });
      }
    });

    if (!widget.isRunning) {
      controller.stop();
    } else {
      controller.repeat();
    }
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  _createSnow() {
    _snows = [];
    for (var i = 0; i < widget.totalSnow; i++) {
      _snows.add(Snow(
          x: _rnd.nextDouble() * W,
          y: _rnd.nextDouble() * H,
          r: _rnd.nextDouble() * 4 + 1,
          d: _rnd.nextDouble() * widget.speed));
    }
  }

  update() {
    angle += 0.01;
    if (widget.totalSnow != _snows.length) {
      _createSnow();
    }
    for (var i = 0; i < widget.totalSnow; i++) {
      var snow = _snows[i];
      //We will add 1 to the cos function to prevent negative values which will lead flakes to move upwards
      //Every particle has its own density which can be used to make the downward movement different for each flake
      //Lets make it more random by adding in the radius
      snow.y += (cos(angle + snow.d) + 1 + snow.r / 2) * widget.speed;
      snow.x += sin(angle) * 2 * widget.speed;
      if (snow.x > W + 5 || snow.x < -5 || snow.y > H) {
        if (i % 3 > 0) {
          //66.67% of the flakes
          _snows[i] =
              Snow(x: _rnd.nextDouble() * W, y: -10, r: snow.r, d: snow.d);
        } else {
          //If the flake is exitting from the right
          if (sin(angle) > 0) {
            //Enter from the left
            _snows[i] =
                Snow(x: -5, y: _rnd.nextDouble() * H, r: snow.r, d: snow.d);
          } else {
            //Enter from the right
            _snows[i] =
                Snow(x: W + 5, y: _rnd.nextDouble() * H, r: snow.r, d: snow.d);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRunning && !controller.isAnimating) {
      controller.repeat();
    } else if (!widget.isRunning && controller.isAnimating) {
      controller.stop();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        W = constraints.maxWidth;
        H = constraints.maxHeight;
        return CustomPaint(
          willChange: widget.isRunning,
          painter: SnowPainter(
              context: context, isRunning: widget.isRunning, snows: _snows),
          size: Size.infinite,
          child: widget.child,
        );
      },
    );
  }
}

class Snow {
  double x;
  double y;
  double r; //radius
  double d; //density
  Snow({required this.x, required this.y, required this.r, required this.d});
}

class SnowPainter extends CustomPainter {
  List<Snow> snows;
  bool isRunning;
  final BuildContext context;

  SnowPainter(
      {required this.context, required this.isRunning, required this.snows});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isRunning) return;
    //draw circle
    final Paint paint = Paint()
      ..color = Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.grey.shade500
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
    for (var i = 0; i < snows.length; i++) {
      var snow = snows[i];
      canvas.drawCircle(Offset(snow.x, snow.y), snow.r, paint);
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => isRunning;
}
