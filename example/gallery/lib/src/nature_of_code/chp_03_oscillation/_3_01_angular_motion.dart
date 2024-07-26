import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _AngularMotionModel extends f.Model {
  static const double initAngAcc = -0.0001;

  final double angle;
  final double angleVelocity;
  final double angleAcceleration;

  _AngularMotionModel.init({required super.size})
      : angle = 0.0,
        angleVelocity = 0.0,
        angleAcceleration = initAngAcc;

  _AngularMotionModel.update({
    required super.size,
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
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final angle = model.angle + model.angleVelocity;
    final angleVelocity = model.angleVelocity + model.angleAcceleration;
    return _AngularMotionModel.update(
      size: size,
      angle: angle,
      angleVelocity: angleVelocity,
      angleAcceleration: model.angleAcceleration,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    final s = u.scale(model.size);
    final r = s * circleRadius;
    return f.Translate(
      translation: f.Vector2(model.size.width * 0.5, model.size.height * 0.5),
      canvasOps: [
        f.Rotate(
          radians: model.angle,
          canvasOps: [
            f.Line(
              p1: f.Offset(s * -halfLength, 0.0),
              p2: f.Offset(s * halfLength, 0.0),
              paint: f.Paint()
                ..color = u.black
                ..strokeWidth = 2.0,
            ),
            f.Translate(
              translation: f.Vector2(s * halfLength, 0.0),
              canvasOps: [
                f.Circle(
                  c: f.Offset.zero,
                  radius: r,
                  paint: f.Paint()..color = u.gray5,
                ),
                f.Circle(
                  c: f.Offset.zero,
                  radius: r,
                  paint: f.Paint()
                    ..color = u.black
                    ..style = p.PaintingStyle.stroke
                    ..strokeWidth = 2.0,
                ),
              ],
            ),
            f.Translate(
              translation: f.Vector2(s * -halfLength, 0.0),
              canvasOps: [
                f.Circle(
                  c: f.Offset.zero,
                  radius: r,
                  paint: f.Paint()..color = u.gray5,
                ),
                f.Circle(
                  c: f.Offset.zero,
                  radius: r,
                  paint: f.Paint()
                    ..color = u.black
                    ..style = p.PaintingStyle.stroke
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
        iud: _AngularMotionIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
