import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

const double halfSize = 60.0;
const double circleRadius = 8.0;

class AngularMotionModel extends f.Model {
  final double angle;
  final double angleVelocity;
  final double angleAcceleration;

  AngularMotionModel.init({required super.size})
      : angle = 0.0,
        angleVelocity = 0.0,
        angleAcceleration = -0.0001;

  AngularMotionModel.update({
    required super.size,
    required this.angle,
    required this.angleVelocity,
    required this.angleAcceleration,
  });
}

class AngularMotionIur<M extends AngularMotionModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final angle = model.angle + model.angleVelocity;
    final angleVelocity = model.angleVelocity + model.angleAcceleration;
    return AngularMotionModel.update(
      size: size,
      angle: angle,
      angleVelocity: angleVelocity,
      angleAcceleration: model.angleAcceleration,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return f.Translate(
      translation: f.Vector2(model.size.width * 0.5, model.size.height * 0.5),
      canvasOps: [
        f.Rotate(
          radians: model.angle,
          canvasOps: [
            f.Line(
              p1: f.Offset(-halfSize, 0.0),
              p2: f.Offset(halfSize, 0.0),
              paint: f.Paint()
                ..color = u.black
                ..strokeWidth = 2.0,
            ),
            f.Translate(
              translation: f.Vector2(halfSize, 0.0),
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
              translation: f.Vector2(-halfSize, 0.0),
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
