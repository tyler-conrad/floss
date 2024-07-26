import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final f.Vector2 ballInitPos = f.Vector2(100.0, 100.0);
final f.Vector2 ballInitVel = f.Vector2(2.5, 2.0);

class _Ball {
  static const double radius = 8.0;

  final f.Vector2 position;
  final f.Vector2 velocity;

  _Ball()
      : position = ballInitPos,
        velocity = ballInitVel;

  _Ball.update({
    required this.position,
    required this.velocity,
  });

  _Ball update(f.Size size) {
    position.add(velocity);
    if (position.x > size.width || position.x < 0) {
      velocity.x = -velocity.x;
    }
    if (position.y > size.height || position.y < 0) {
      velocity.y = -velocity.y;
    }
    return _Ball.update(
      position: position,
      velocity: velocity,
    );
  }

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * radius;

    return f.Translate(
      translation: position,
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
            ..style = p.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

class _BallModel extends f.Model {
  final _Ball ball;

  _BallModel.init({required super.size}) : ball = _Ball();

  _BallModel.update({
    required super.size,
    required this.ball,
  });
}

class _BallIud<M extends _BallModel> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _BallModel.update(
        size: size,
        ball: model.ball.update(size),
      ) as M;

  @override
  f.Drawing draw({required M model, required bool isLightTheme}) =>
      model.ball.draw(model.size);
}

const String title = 'Bouncing Ball Vectors Object';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _BallModel.init,
        iud: _BallIud(),
        clearCanvas: f.NoClearCanvas(
          paint: f.Paint()
            ..color = u.transparentWhite
            ..blendMode = p.BlendMode.srcOver,
        ),
      ),
    );
