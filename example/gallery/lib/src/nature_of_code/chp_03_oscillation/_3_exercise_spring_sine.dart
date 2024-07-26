import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _SpringSineModel extends f.Model {
  static const radius = 12.0;
  static const double angularVel = 0.05;

  final double angle;
  _SpringSineModel.init({required super.size}) : angle = 0.0;

  _SpringSineModel.update({
    required super.size,
    required this.angle,
  });
}

class _SpringSineIud<M extends _SpringSineModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _SpringSineModel.update(
        size: size,
        angle: model.angle + _SpringSineModel.angularVel,
      ) as M;

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    final r = u.scale(model.size) * _SpringSineModel.radius;
    final y = model.size.height * 0.5 +
        model.size.height * 0.25 * math.sin(model.angle);
    return f.Translate(
      translation: f.Vector2(model.size.width * 0.5, 0.0),
      canvasOps: [
        f.Line(
          p1: f.Offset.zero,
          p2: f.Offset(0.0, y),
          paint: f.Paint()
            ..color = u.black
            ..strokeWidth = 2.0,
        ),
        f.Circle(
          c: f.Offset(
            0.0,
            y,
          ),
          radius: r,
          paint: f.Paint()
            ..color = const p.HSLColor.fromAHSL(
              1.0,
              0.0,
              0.0,
              0.7,
            ).toColor()
            ..style = p.PaintingStyle.fill,
        ),
        f.Circle(
          c: f.Offset(
            0.0,
            y,
          ),
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
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
        iud: _SpringSineIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
