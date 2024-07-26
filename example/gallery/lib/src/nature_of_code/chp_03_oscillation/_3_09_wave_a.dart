import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _WaveModel extends f.Model {
  static const int numCircles = 26;
  static const amplitudeFactor = 0.35;
  static const double angleVel = 0.05;
  static const startAngleDt = 0.015;

  final double startAngle;

  _WaveModel.init({required super.size}) : startAngle = 0.0;

  _WaveModel.update({
    required super.size,
    required this.startAngle,
  });
}

class _WaveIud<M extends _WaveModel> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final angle = model.startAngle + _WaveModel.startAngleDt;
    return _WaveModel.update(
      size: size,
      startAngle: angle,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    return f.Translate(
      translation: f.Vector2(0.0, model.size.height * 0.5),
      canvasOps: List.generate(
        _WaveModel.numCircles + 1,
        (i) => model.startAngle + i * _WaveModel.angleVel,
      ).mapIndexed((i, angle) {
        final x = i * model.size.width / _WaveModel.numCircles;
        final y =
            _WaveModel.amplitudeFactor * model.size.height * math.sin(angle);
        final radius = model.size.width / _WaveModel.numCircles * 0.5;
        return f.Drawing(
          canvasOps: [
            f.Circle(
              c: f.Offset(x, y),
              radius: radius,
              paint: f.Paint()
                ..color = u.transparent5black
                ..style = p.PaintingStyle.fill,
            ),
            f.Circle(
              c: f.Offset(x, y),
              radius: radius,
              paint: f.Paint()
                ..color = u.black
                ..style = p.PaintingStyle.stroke
                ..strokeWidth = 2.0,
            ),
          ],
        );
      }).toList(),
    );
  }
}

const String title = 'Wave A';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _WaveModel.init,
        iud: _WaveIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
