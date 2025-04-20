import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _AngularMotionModel extends f.Model {
  static const double initAngAcc = -0.0001;

  final double angle;
  final double angleVelocity;
  final double angleAcceleration;

  _AngularMotionModel.init({required super.size, required super.inputEvents})
    : angle = 0.0,
      angleVelocity = 0.0,
      angleAcceleration = initAngAcc;

  _AngularMotionModel.update({
    required super.size,
    required super.inputEvents,
    required this.angle,
    required this.angleVelocity,
    required this.angleAcceleration,
  });
}

class _AngularMotionIud<M extends _AngularMotionModel> extends f.IudBase<M>
    implements f.Iud<M> {
  static const double halfLength = 300.0;
  static const double circleRadius = 24.0;

  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    final angle = model.angle + model.angleVelocity;
    final angleVelocity = model.angleVelocity + model.angleAcceleration;
    return _AngularMotionModel.update(
          size: size,
          inputEvents: inputEvents,
          angle: angle,
          angleVelocity: angleVelocity,
          angleAcceleration: model.angleAcceleration,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    final s = u.scale(model.size);
    final r = s * circleRadius;
    return f.Translate(
      dx: model.size.width * 0.5,
      dy: model.size.height * 0.5,
      ops: [
        f.Rotate(
          radians: model.angle,
          ops: [
            f.Line(
              p1: ui.Offset(s * -halfLength, 0.0),
              p2: ui.Offset(s * halfLength, 0.0),
              paint:
                  ui.Paint()
                    ..color = u.black
                    ..strokeWidth = 2.0,
            ),
            f.Translate(
              dx: s * halfLength,
              dy: 0.0,
              ops: [
                f.Circle(
                  center: ui.Offset.zero,
                  radius: r,
                  paint: ui.Paint()..color = u.gray5,
                ),
                f.Circle(
                  center: ui.Offset.zero,
                  radius: r,
                  paint:
                      ui.Paint()
                        ..color = u.black
                        ..style = ui.PaintingStyle.stroke
                        ..strokeWidth = 2.0,
                ),
              ],
            ),
            f.Translate(
              dx: s * -halfLength,
              dy: 0.0,
              ops: [
                f.Circle(
                  center: ui.Offset.zero,
                  radius: r,
                  paint: ui.Paint()..color = u.gray5,
                ),
                f.Circle(
                  center: ui.Offset.zero,
                  radius: r,
                  paint:
                      ui.Paint()
                        ..color = u.black
                        ..style = ui.PaintingStyle.stroke
                        ..strokeWidth = 2.0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

const String title = 'Angular Motion';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _AngularMotionModel.init,
    iud: _AngularMotionIud<_AngularMotionModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
