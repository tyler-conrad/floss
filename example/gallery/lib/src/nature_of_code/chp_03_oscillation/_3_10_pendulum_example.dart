import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Pendulum {
  static const double gravity = 0.4;
  static const double damping = 0.995;
  static const double length = 450.0;
  static const double radius = 48.0;

  final f.Vector2 position;
  final f.Vector2 origin;
  final double aAcceleration;

  bool dragging;
  double angle;
  double aVelocity;

  _Pendulum()
      : origin = f.Vector2.zero(),
        position = f.Vector2.zero(),
        angle = math.pi / 4.0,
        aVelocity = 0.0,
        aAcceleration = 0.0,
        dragging = false;

  _Pendulum.update({
    required this.position,
    required this.origin,
    required this.angle,
    required this.aVelocity,
    required this.aAcceleration,
    required this.dragging,
  });

  _Pendulum update(f.Size size) {
    var aAcc = aAcceleration;
    var aVel = aVelocity;
    var a = angle;
    final r = u.scale(size) * length;

    if (!dragging) {
      aAcc = -gravity / r * math.sin(angle);
      aVel = (aVelocity + aAcc) * damping;
      a = angle + aVel;
    }

    final pos = f.Vector2(
      r * math.sin(a),
      r * math.cos(a),
    );

    return _Pendulum.update(
      position: pos,
      origin: f.Vector2(size.width * 0.5, 0.0),
      angle: a,
      aVelocity: aVel,
      aAcceleration: aAcc,
      dragging: dragging,
    );
  }

  f.Drawing draw(f.Size size) {
    final c = dragging ? u.black : u.gray5;
    final pos = f.Offset.fromVec(position);
    final r = u.scale(size) * radius;

    return f.Translate(translation: origin, canvasOps: [
      f.Line(
          p1: f.Offset.zero,
          p2: pos,
          paint: f.Paint()
            ..color = u.black
            ..strokeWidth = 2.0),
      f.Circle(c: pos, radius: r, paint: f.Paint()..color = c),
      f.Circle(
          c: f.Offset.fromVec(position),
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0)
    ]);
  }

  void clicked(f.Vector2 mouse, f.Size size) {
    if ((mouse - (origin + position)).length <= u.scale(size) * radius) {
      dragging = true;
    }
  }

  void stopDragging() {
    if (dragging) {
      aVelocity = 0.0;
      dragging = false;
    }
  }

  void drag(f.Vector2 mouse) {
    if (dragging) {
      final diff = origin - mouse;
      angle = math.atan2(diff.x, diff.y) - math.pi;
    }
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
  }) {
    final p = model.pendulum.update(size);

    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          p.clicked(
              f.Vector2(event.localPosition.dx, event.localPosition.dy), size);
          break;
        case f.PointerUp():
          p.stopDragging();
          break;
        case f.PointerMove(:final event):
          p.drag(f.Vector2(event.localPosition.dx, event.localPosition.dy));
          break;
        default:
          break;
      }
    }

    return _PendulumModel.update(
      size: size,
      pendulum: p,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      model.pendulum.draw(model.size);
}

const String title = 'Pendulum';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _PendulumModel.init,
        iud: _PendulumIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
