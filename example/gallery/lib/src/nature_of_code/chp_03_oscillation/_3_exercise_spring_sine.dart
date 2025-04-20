import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _SpringSineModel extends f.Model {
  static const double radius = 48.0;
  static const double angularVel = 0.05;

  final double angle;
  _SpringSineModel.init({required super.size, required super.inputEvents})
    : angle = 0.0;

  _SpringSineModel.update({
    required super.size,
    required super.inputEvents,
    required this.angle,
  });
}

class _SpringSineIud<M extends _SpringSineModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _SpringSineModel.update(
            size: size,
            inputEvents: inputEvents,
            angle: model.angle + _SpringSineModel.angularVel,
          )
          as M;

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    final r = u.scale(model.size) * _SpringSineModel.radius;
    final y =
        model.size.height * 0.5 +
        model.size.height * 0.25 * math.sin(model.angle);
    return f.Translate(
      dx: model.size.width * 0.5,
      dy: 0.0,
      ops: [
        f.Line(
          p1: ui.Offset.zero,
          p2: ui.Offset(0.0, y),
          paint:
              ui.Paint()
                ..color = u.black
                ..strokeWidth = 2.0,
        ),
        f.Circle(
          center: ui.Offset(0.0, y),
          radius: r,
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Circle(
          center: ui.Offset(0.0, y),
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = ui.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

const String title = 'Spring Sine';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _SpringSineModel.init,
    iud: _SpringSineIud<_SpringSineModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
