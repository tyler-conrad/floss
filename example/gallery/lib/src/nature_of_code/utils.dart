import 'dart:math' as m;

import 'package:flutter/painting.dart' as p;

import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

final p.Color black = const p.HSLColor.fromAHSL(
  1.0,
  0.0,
  0.0,
  0.0,
).toColor();

final p.Color transparent5black = const p.HSLColor.fromAHSL(
  0.5,
  0.0,
  0.0,
  0.0,
).toColor();

final p.Color transparent7Black = const p.HSLColor.fromAHSL(
  0.7,
  0.0,
  0.0,
  0.0,
).toColor();

final p.Color transparentWhite = const m.HSLColor.fromAHSL(
  0.93,
  0.0,
  0.0,
  1.0,
).toColor();

final p.Color gray5 = const p.HSLColor.fromAHSL(
  1.0,
  0.0,
  0.0,
  0.5,
).toColor();

final _rand = m.Random();

double randDoubleRange(double min, double max) =>
    min + _rand.nextDouble() * (max - min);

class ExamplesWidget extends m.StatelessWidget {
  final String _title;
  final f.FlossWidget _child;

  const ExamplesWidget(
      {super.key, required String title, required f.FlossWidget child})
      : _title = title,
        _child = child;

  @override
  m.Widget build(m.BuildContext context) =>
      m.MaterialApp(title: _title, home: m.Scaffold(body: _child));
}
