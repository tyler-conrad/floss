import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final gravity = ui.Offset(0.0, 2.0);

class _Bob {
  static const double mass = 48.0;
  static const double damping = 0.98;

  ui.Offset position;
  ui.Offset velocity;
  ui.Offset acceleration;
  ui.Offset dragOffset;

  bool dragging = false;

  _Bob({required this.position})
    : velocity = ui.Offset.zero,
      acceleration = ui.Offset.zero,
      dragOffset = ui.Offset.zero;

  _Bob.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.dragOffset,
    required this.dragging,
  });

  _Bob update() {
    final vel = (velocity + acceleration) * damping;
    final pos = position + vel;
    acceleration = ui.Offset(0.0, 0.0);

    return _Bob.update(
      position: pos,
      velocity: vel,
      acceleration: acceleration,
      dragOffset: dragOffset,
      dragging: dragging,
    );
  }

  void applyForce(ui.Offset force) {
    acceleration += force / mass;
  }

  double computeRadius(ui.Size size) => u.scale(size) * mass;

  f.Drawing draw(ui.Size size) {
    final c =
        dragging
            ? u.gray5
            : const p.HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.2).toColor();
    final r = computeRadius(size);

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = c,
        ),
        f.Circle(
          center: ui.Offset.zero,
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
    final m = position - mouse;
    if (m.distance < computeRadius(size)) {
      dragging = true;
      dragOffset = m;
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(ui.Offset mouse) {
    if (dragging) {
      position = mouse + dragOffset;
    }
  }
}

class _Spring {
  static const size = 10.0;
  static const double k = 0.2;

  final ui.Offset anchor;
  final double length;

  _Spring({required this.anchor, required this.length});

  void connect(_Bob bob) {
    final force = bob.position - anchor;
    final stretch = force.distance - length;
    bob.applyForce(force.norm() * -k * stretch);
  }

  void constrainLength({
    required _Bob bob,
    required double minLen,
    required double maxLen,
  }) {
    ui.Offset dir = bob.position - anchor;
    final d = dir.distance;
    if (d < minLen) {
      dir.norm();
      dir *= minLen;
      bob.position = anchor + dir;
      bob.velocity = ui.Offset.zero;
    } else if (d > maxLen) {
      dir = dir.norm();
      dir *= maxLen;
      bob.position = anchor + dir;
      bob.velocity = ui.Offset.zero;
    }
  }

  f.Drawing draw(ui.Size size) {
    final s = u.scale(size);

    return f.Translate(
      dx: anchor.dx,
      dy: anchor.dy,
      ops: [
        f.Rect(
          rect: ui.Rect.fromCenter(
            center: ui.Offset.zero,
            width: s * _Spring.size,
            height: s * _Spring.size,
          ),
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Rect(
          rect: ui.Rect.fromCenter(
            center: ui.Offset.zero,
            width: s * _Spring.size,
            height: s * _Spring.size,
          ),
          paint:
              ui.Paint()
                ..color = u.black
                ..style = p.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }

  f.Drawing drawLine(_Bob bob) => f.Translate(
    dx: bob.position.dx,
    dy: bob.position.dy,
    ops: [
      f.Line(
        p1: ui.Offset.zero,
        p2: anchor - bob.position,
        paint:
            ui.Paint()
              ..color = u.black
              ..strokeWidth = 2.0,
      ),
    ],
  );
}

class _SpringModel extends f.Model {
  final _Bob bob;
  final _Spring spring;
  ui.Offset? mouse;

  _SpringModel.init({required super.size, required super.inputEvents})
    : spring = _Spring(
        anchor: ui.Offset(size.width * 0.5, u.scale(size) * _Spring.size),
        length: size.height * 0.5,
      ),
      bob = _Bob(position: ui.Offset(size.width * 0.5, size.height * 0.5)),
      mouse = null;

  _SpringModel.update({
    required super.size,
    required super.inputEvents,
    required this.spring,
    required this.bob,
    required this.mouse,
  });
}

class _SpringIud<M extends _SpringModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    final spring = _Spring(
      anchor: ui.Offset(size.width * 0.5, u.scale(size) * _Spring.size),
      length: size.height * 0.6,
    );

    model.bob.applyForce(gravity);

    spring.connect(model.bob);

    spring.constrainLength(
      bob: model.bob,
      minLen: size.height * 0.1,
      maxLen: size.height * 0.9,
    );
    final bob = model.bob.update();

    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          model.mouse = ui.Offset(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          bob.clicked(model.mouse!, size);
          break;

        case f.PointerUp():
          bob.stopDragging();
          model.mouse = null;
          break;

        case f.PointerMove(:final event):
          model.mouse = ui.Offset(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          break;

        default:
          break;
      }
    }

    if (model.mouse != null) {
      bob.drag(model.mouse!);
    }

    return _SpringModel.update(
          size: size,
          inputEvents: inputEvents,
          spring: spring,
          bob: bob,
          mouse: model.mouse,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(
        ops: [
          model.spring.drawLine(model.bob),
          model.spring.draw(model.size),
          model.bob.draw(model.size),
        ],
      );
}

const String title = 'Spring';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _SpringModel.init,
    iud: _SpringIud<_SpringModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
