import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Pendulum {
  static const double gravity = 0.4;
  static const double damping = 0.995;
  static const double length = 450.0;
  static const double radius = 48.0;

  final ui.Offset position;
  final ui.Offset origin;
  final double aAcceleration;

  bool dragging;
  double angle;
  double aVelocity;

  _Pendulum()
    : origin = ui.Offset.zero,
      position = ui.Offset.zero,
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

  _Pendulum update(ui.Size size) {
    var aAcc = aAcceleration;
    var aVel = aVelocity;
    var a = angle;
    final r = u.scale(size) * length;

    if (!dragging) {
      aAcc = -gravity / r * math.sin(angle);
      aVel = (aVelocity + aAcc) * damping;
      a = angle + aVel;
    }

    final pos = ui.Offset(r * math.sin(a), r * math.cos(a));

    return _Pendulum.update(
      position: pos,
      origin: ui.Offset(size.width * 0.5, 0.0),
      angle: a,
      aVelocity: aVel,
      aAcceleration: aAcc,
      dragging: dragging,
    );
  }

  f.Drawing draw(ui.Size size) {
    final c = dragging ? u.black : u.gray5;
    final r = u.scale(size) * radius;

    return f.Translate(
      dx: origin.dx,
      dy: origin.dy,
      ops: [
        f.Line(
          p1: ui.Offset.zero,
          p2: position,
          paint:
              ui.Paint()
                ..color = u.black
                ..strokeWidth = 2.0,
        ),
        f.Circle(center: position, radius: r, paint: ui.Paint()..color = c),
        f.Circle(
          center: position,
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = ui.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }

  void clicked(ui.Offset mouse, ui.Size size) {
    if ((mouse - (origin + position)).distance <= u.scale(size) * radius) {
      dragging = true;
    }
  }

  void stopDragging() {
    if (dragging) {
      aVelocity = 0.0;
      dragging = false;
    }
  }

  void drag(ui.Offset mouse) {
    if (dragging) {
      final diff = origin - mouse;
      angle = math.atan2(diff.dx, diff.dy) - math.pi;
    }
  }
}

class _PendulumModel extends f.Model {
  final _Pendulum pendulum;
  _PendulumModel.init({required super.size, required super.inputEvents})
    : pendulum = _Pendulum();

  _PendulumModel.update({
    required super.size,
    required super.inputEvents,
    required this.pendulum,
  });
}

class _PendulumIud<M extends _PendulumModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    final p = model.pendulum.update(size);

    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          p.clicked(
            ui.Offset(event.localPosition.dx, event.localPosition.dy),
            size,
          );
          break;
        case f.PointerUp():
          p.stopDragging();
          break;
        case f.PointerMove(:final event):
          p.drag(ui.Offset(event.localPosition.dx, event.localPosition.dy));
          break;
        default:
          break;
      }
    }

    return _PendulumModel.update(
          size: size,
          inputEvents: inputEvents,
          pendulum: p,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.pendulum.draw(model.size);
}

const String title = 'Pendulum';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _PendulumModel.init,
    iud: _PendulumIud<_PendulumModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
