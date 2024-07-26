import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Pendulum {
  static const double gravity = 0.4;
  static const double damping = 0.995;
  static const double length = 220.0;
  static const double radius = 28.0;

  final f.Vector2 position;
  final f.Vector2 origin;
  final double angle;
  final double aVelocity;
  final double aAcceleration;

  _Pendulum()
      : origin = f.Vector2.zero(),
        position = f.Vector2.zero(),
        angle = math.pi / 4.0,
        aVelocity = 0.0,
        aAcceleration = 0.0;

  _Pendulum.update({
    required this.position,
    required this.origin,
    required this.angle,
    required this.aVelocity,
    required this.aAcceleration,
  });

  _Pendulum update(f.Size size) {
    final l = u.scale(size) * length;
    final aAcc = -gravity / l * math.sin(angle);
    final aVel = (aVelocity + aAcc) * damping;
    final a = angle + aVel;

    final pos = f.Vector2(
      l * math.sin(a),
      l * math.cos(a),
    );

    return _Pendulum.update(
      position: pos,
      origin: f.Vector2(size.width * 0.5, 0.0),
      angle: a,
      aVelocity: aVel,
      aAcceleration: aAcc,
    );
  }

  f.Drawing draw(f.Size size) {
    final pos = f.Offset.fromVec(position);
    final r = u.scale(size) * radius;

    return f.Translate(translation: origin, canvasOps: [
      f.Line(
          p1: f.Offset.zero,
          p2: pos,
          paint: f.Paint()
            ..color = u.black
            ..strokeWidth = 2.0),
      f.Circle(c: pos, radius: r, paint: f.Paint()..color = u.gray5),
      f.Circle(
          c: f.Offset.fromVec(position),
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0)
    ]);
  }
}

class _PendulumModel extends f.Model {
  final _Pendulum pendulum;
  _PendulumModel.init({required super.size}) : pendulum = _Pendulum();

  _PendulumModel.update({
    required super.size,
    required this.pendulum,
  });
}

class _PendulumIud<M extends _PendulumModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _PendulumModel.update(
        size: size,
        pendulum: model.pendulum.update(size),
      ) as M;

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      model.pendulum.draw(model.size);
}

const String title = 'Pendulum Simplified';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _PendulumModel.init,
        iud: _PendulumIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
