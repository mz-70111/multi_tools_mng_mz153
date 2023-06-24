import 'package:flutter/material.dart';

class TweenMZ {
  static rotate({begin = 0.0, end = 0.0, duration = 0, child0}) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: begin, end: end),
        duration: Duration(milliseconds: duration),
        builder: (_, end0, child) {
          return Transform.rotate(
            angle: end0,
            child: child0,
          );
        });
  }

  static translatey({begin = 0.0, end = 0.0, duration = 0, child0}) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: begin, end: end),
        duration: Duration(milliseconds: duration),
        builder: (_, end0, child) {
          return Transform.translate(
            offset: Offset(0.0, end0),
            child: child0,
          );
        });
  }

  static translatex({begin = 0.0, end = 0.0, duration = 0, child0}) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: begin, end: end),
        duration: Duration(milliseconds: duration),
        builder: (_, end0, child) {
          return Transform.translate(
            offset: Offset(end0, 0.0),
            child: child0,
          );
        });
  }

  static scale({begin = 1, end = 1, duration = 0, child0}) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: begin, end: end),
        duration: Duration(milliseconds: duration),
        builder: (_, end0, child) {
          return Transform.scale(
            scale: end0,
            child: child0,
          );
        });
  }
}
