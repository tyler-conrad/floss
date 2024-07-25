import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _AngularMotionModel extends f.Model {
  static const initAngAcc = -0.0001;

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

class _AngularMotionIur<M extends _AngularMotionModel> extends f.IurBase<M>
    implements f.Iur<M> {
  static const double halfLength = 60.0;
  static const double circleRadius = 8.0;

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
  f.Drawing render({
    required M model,
    required bool isLightTheme,
  }) {
    return f.Translate(
      translation: f.Vector2(model.size.width * 0.5, model.size.height * 0.5),
      canvasOps: [
        f.Rotate(
          radians: model.angle,
          canvasOps: [
            f.Line(
              p1: f.Offset(-halfLength, 0.0),
              p2: f.Offset(halfLength, 0.0),
              paint: f.Paint()
                ..color = u.black
                ..strokeWidth = 2.0,
            ),
            f.Translate(
              translation: f.Vector2(halfLength, 0.0),
              canvasOps: [
                f.Circle(
                  c: f.Offset.zero,
                  radius: circleRadius,
                  paint: f.Paint()..color = u.gray5,
                ),
                f.Circle(
                  c: f.Offset.zero,
                  radius: circleRadius,
                  paint: f.Paint()
                    ..color = u.black
                    ..style = p.PaintingStyle.stroke
                    ..strokeWidth = 2.0,
                ),
              ],
            ),
            f.Translate(
              translation: f.Vector2(-halfLength, 0.0),
              canvasOps: [
                f.Circle(
                  c: f.Offset.zero,
                  radius: circleRadius,
                  paint: f.Paint()..color = u.gray5,
                ),
                f.Circle(
                  c: f.Offset.zero,
                  radius: circleRadius,
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
        iur: _AngularMotionIur(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
