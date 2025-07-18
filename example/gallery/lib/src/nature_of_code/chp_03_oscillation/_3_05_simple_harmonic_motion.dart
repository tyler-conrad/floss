import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _SimpleHarmonicMotionModel extends f.Model {
  final double elapsed;

  _SimpleHarmonicMotionModel.init({
    required super.size,
    required super.inputEvents,
  }) : elapsed = 0.0;

  _SimpleHarmonicMotionModel.update({
    required super.size,
    required super.inputEvents,
    required this.elapsed,
  });
}

class _SimpleHarmonicMotionIud<M extends _SimpleHarmonicMotionModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  static const double microsPerSecond = 1000000.0;
  static const double circleRadius = 25.0;
  static const double period = 0.2;
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
            elapsed: elapsed.inMicroseconds / microsPerSecond,
          )
          as M;

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    final x =
        model.size.width *
        amplitudeFactor *
        math.sin(2.0 * math.pi * model.elapsed * period);

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

const String title = 'Simple Harmonic Motion 1';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _SimpleHarmonicMotionModel.init,
    iud: _SimpleHarmonicMotionIud<_SimpleHarmonicMotionModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
