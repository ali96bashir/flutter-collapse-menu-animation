import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class HomeController {
  HomeController({required TickerProvider vsync})
      : menuController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 950),
          reverseDuration: const Duration(milliseconds: 750),
        ) {
    menuCurve = CurvedAnimation(
      parent: menuController,
      curve: const Cubic(0.22, 1, 0.36, 1),
      reverseCurve: Curves.easeInCubic,
    );
    iconCurve = CurvedAnimation(
      parent: menuController,
      curve: const Interval(0, 0.7, curve: Curves.easeInOutCubic),
      reverseCurve: const Interval(0.3, 1, curve: Curves.easeInOutCubic),
    );
  }

  final AnimationController menuController;
  late final Animation<double> menuCurve;
  late final Animation<double> iconCurve;

  bool get isMenuOpen =>
      menuController.status == AnimationStatus.completed ||
      menuController.status == AnimationStatus.forward;

  double get progress => menuCurve.value;

  double menuHeight(double screenHeight) {
    return (screenHeight * 0.48).clamp(380.0, 430.0);
  }

  double animatedMenuHeight(double menuHeight) {
    return lerpDouble(0, menuHeight, progress)!;
  }

  double get headerHeight => lerpDouble(142, 0, progress)!;
  double get titleTop => lerpDouble(72, 20, progress)!;
  double get cardTop => lerpDouble(112, 62, progress)!;
  double get bodyTop => lerpDouble(142, 0, progress)!;

  void toggleMenu() {
    if (isMenuOpen) {
      menuController.reverse();
    } else {
      menuController.forward();
    }
  }

  void selectMenuItem(int index) {
    menuController.reverse();
  }

  void dispose() {
    menuController.dispose();
  }
}
