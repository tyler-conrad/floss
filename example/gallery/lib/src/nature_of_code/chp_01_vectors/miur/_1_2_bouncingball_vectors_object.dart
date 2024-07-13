import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

class Ball {
  static const double size = 8.0;

  final f.Vector2 position;
  final f.Vector2 velocity;

  Ball()
      : position = f.Vector2(100.0, 100.0),
        velocity = f.Vector2(2.5, 2.0);

  Ball.init({
    required this.position,
    required this.velocity,
  });

  Ball update(f.Size size) {
    position.add(velocity);
    if (position.x > size.width || position.x < 0) {
      velocity.x = -velocity.x;
    }
    if (position.y > size.height || position.y < 0) {
      velocity.y = -velocity.y;
    }
    return Ball.init(
      position: position,
      velocity: velocity,
    );
  }

  f.Drawing display() {
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

class BallModel extends f.Model {
  final Ball ball;

  BallModel.init({required super.size}) : ball = Ball();

  BallModel.update({
    required super.size,
    required this.ball,
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
    return BallModel.update(
      size: size,
      ball: model.ball.update(size),
    ) as M;
  }

  @override
  f.Drawing render({required M model}) {
    return model.ball.display();
  }
}
