import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _BallModel extends f.Model {
  static const double pos = 100.0;
  static const double initXSpeed = 2.5;
  static const double initYSpeed = 2.0;

  final double x;
  final double y;
  final double xSpeed;
  final double ySpeed;

  _BallModel.init({required super.size})
      : x = pos,
        y = pos,
        xSpeed = initXSpeed,
        ySpeed = initYSpeed;

  _BallModel.update({
    required super.size,
    required this.x,
    required this.y,
    required this.xSpeed,
    required this.ySpeed,
  });
}

class _BallIur<M extends _BallModel> extends f.IurBase<M> implements f.Iur<M> {
  static const double ballRadius = 25.0;

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
    return _BallModel.update(
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
    required bool isLightTheme,
  }) {
    return f.Translate(
      translation: f.Vector2(model.x, model.y),
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: ballRadius,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: ballRadius,
          paint: f.Paint()
            ..color = u.black
            ..paint
            ..style = p.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

const String title = 'Bouncing Ball No Vectors';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _BallModel.init,
        iur: _BallIur(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
