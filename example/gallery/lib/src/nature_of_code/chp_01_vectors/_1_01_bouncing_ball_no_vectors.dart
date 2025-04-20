import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _BallModel extends f.Model {
  static const double radius = 48.0;
  static const double pos = 100.0;
  static const double initXSpeed = 2.5;
  static const double initYSpeed = 2.0;

  final double x;
  final double y;
  final double xSpeed;
  final double ySpeed;

  _BallModel.init({required super.size, required super.inputEvents})
    : x = pos,
      y = pos,
      xSpeed = initXSpeed,
      ySpeed = initYSpeed;

  _BallModel.update({
    required super.size,
    required super.inputEvents,
    required this.x,
    required this.y,
    required this.xSpeed,
    required this.ySpeed,
  });
}

class _BallIud<M extends _BallModel> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    final x = model.x + model.xSpeed;
    final y = model.y + model.ySpeed;
    final xSpeed = (x > size.width || x < 0) ? -model.xSpeed : model.xSpeed;
    final ySpeed = (y > size.height || y < 0) ? -model.ySpeed : model.ySpeed;
    return _BallModel.update(
          size: size,
          inputEvents: inputEvents,
          x: x,
          y: y,
          xSpeed: xSpeed,
          ySpeed: ySpeed,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    final r = u.scale(model.size) * _BallModel.radius;
    return f.Translate(
      dx: model.x,
      dy: model.y,
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

const String title = 'Bouncing Ball No Vectors';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _BallModel.init,
    iud: _BallIud<_BallModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
