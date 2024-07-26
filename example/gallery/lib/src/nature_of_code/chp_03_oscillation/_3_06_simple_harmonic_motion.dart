import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _SimpleHarmonicMotionModel extends f.Model {
  final double angle;
  final double aVelocity;

  _SimpleHarmonicMotionModel.init({required super.size})
      : angle = 0.0,
        aVelocity = 0.03;

  _SimpleHarmonicMotionModel.update({
    required super.size,
    required this.angle,
    required this.aVelocity,
  });
}

class _SimpleHarmonicMotionIur<M extends _SimpleHarmonicMotionModel>
    extends f.IurBase<M> implements f.Iur<M> {
  static const double circleRadius = 25.0;
  static const double period = 0.2;
  static const double amplitudeFactor = 0.4;
  static const double twoPi = 2.0 * math.pi;

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _SimpleHarmonicMotionModel.update(
        size: size,
        angle: model.angle + model.aVelocity,
        aVelocity: model.aVelocity,
      ) as M;

  @override
  f.Drawing render({
    required M model,
    required bool isLightTheme,
  }) {
    final x = model.size.width * amplitudeFactor * math.sin(model.angle);

    return f.Translate(
      translation: f.Vector2(model.size.width * 0.5, model.size.height * 0.5),
      canvasOps: [
        f.Line(
          p1: f.Offset.zero,
          p2: f.Offset(x, 0.0),
          paint: f.Paint()
            ..color = u.black
            ..strokeWidth = 2.0,
        ),
        f.Circle(
          c: f.Offset(x, 0.0),
          radius: circleRadius,
          paint: f.Paint()
            ..color = const p.HSLColor.fromAHSL(
              1.0,
              0.0,
              0.0,
              0.68,
            ).toColor(),
        ),
        f.Circle(
          c: f.Offset(x, 0.0),
          radius: circleRadius,
          paint: f.Paint()
            ..color = u.black
            ..paint
            ..style = p.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

const String title = 'Simple Harmonic Motion 2';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _SimpleHarmonicMotionModel.init,
        iur: _SimpleHarmonicMotionIur(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );