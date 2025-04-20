import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final ui.Offset ballInitPos = ui.Offset(100.0, 100.0);
final ui.Offset ballInitVel = ui.Offset(2.5, 2.0);

class _Ball {
  static const double radius = 48.0;

  ui.Offset position;
  ui.Offset velocity;

  _Ball() : position = ballInitPos, velocity = ballInitVel;

  _Ball.update({required this.position, required this.velocity});

  _Ball update(ui.Size size) {
    position = position + velocity;
    if (position.dx > size.width || position.dx < 0) {
      velocity = ui.Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy > size.height || position.dy < 0) {
      velocity = ui.Offset(velocity.dx, -velocity.dy);
    }
    return _Ball.update(position: position, velocity: velocity);
  }

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * radius;

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
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
                ..style = ui.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

class _BallModel extends f.Model {
  final _Ball ball;

  _BallModel.init({required super.size, required super.inputEvents})
    : ball = _Ball();

  _BallModel.update({
    required super.size,
    required super.inputEvents,
    required this.ball,
  });
}

class _BallIud<M extends _BallModel> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _BallModel.update(
            size: size,
            inputEvents: inputEvents,
            ball: model.ball.update(size),
          )
          as M;

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.ball.draw(model.size);
}

const String title = 'Bouncing Ball Vectors Object';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _BallModel.init,
    iud: _BallIud<_BallModel>(),
    clearCanvas: f.NoClearCanvas(
      paint:
          ui.Paint()
            ..color = u.transparentWhite
            ..blendMode = ui.BlendMode.srcOver,
    ),
  ),
);
