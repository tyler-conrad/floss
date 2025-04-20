import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _SimpleHarmonicMotionModel extends f.Model {
  final double angle;
  final double aVelocity;

  _SimpleHarmonicMotionModel.init({
    required super.size,
    required super.inputEvents,
  }) : angle = 0.0,
       aVelocity = 0.03;

  _SimpleHarmonicMotionModel.update({
    required super.size,
    required super.inputEvents,
    required this.angle,
    required this.aVelocity,
  });
}

class _SimpleHarmonicMotionIud<M extends _SimpleHarmonicMotionModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  static const double circleRadius = 25.0;
  static const double amplitudeFactor = 0.4;

  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _SimpleHarmonicMotionModel.update(
            size: size,
            inputEvents: inputEvents,
            angle: model.angle + model.aVelocity,
            aVelocity: model.aVelocity,
          )
          as M;

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    final x = model.size.width * amplitudeFactor * math.sin(model.angle);
    final r = u.scale(model.size) * circleRadius;

    return f.Translate(
      dx: model.size.width * 0.5,
      dy: model.size.height * 0.5,

      ops: [
        f.Line(
          p1: ui.Offset.zero,
          p2: ui.Offset(x, 0.0),
          paint:
              ui.Paint()
                ..color = u.black
                ..strokeWidth = 2.0,
        ),
        f.Circle(
          center: ui.Offset(x, 0.0),
          radius: r,
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Circle(
          center: ui.Offset(x, 0.0),
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = ui.PaintingStyle.stroke,
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
    iud: _SimpleHarmonicMotionIud<_SimpleHarmonicMotionModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
