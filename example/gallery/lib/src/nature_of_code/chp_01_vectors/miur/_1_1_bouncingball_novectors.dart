import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

const double pos = 100.0;
const double ballSize = 25.0;

class BallModel extends f.Model {
  final double x;
  final double y;
  final double xSpeed;
  final double ySpeed;

  BallModel.init({required super.size})
      : x = pos,
        y = pos,
        xSpeed = 2.5,
        ySpeed = 2.0;

  BallModel.update({
    required super.size,
    required this.x,
    required this.y,
    required this.xSpeed,
    required this.ySpeed,
  });
}

class BallIur<M extends BallModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final x = model.x + model.xSpeed;
    final y = model.y + model.ySpeed;
    final xSpeed = (x > size.width || x < 0) ? -model.xSpeed : model.xSpeed;
    final ySpeed = (y > size.height || y < 0) ? -model.ySpeed : model.ySpeed;
    return BallModel.update(
      size: size,
      x: x,
      y: y,
      xSpeed: xSpeed,
      ySpeed: ySpeed,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return f.Translate(
      translation: f.Vector2(model.x, model.y),
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: ballSize,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: ballSize,
          paint: f.Paint()
            ..color = u.black
            ..paint
            ..style = m.PaintingStyle.stroke,
        ),
      ],
    );
  }
}
