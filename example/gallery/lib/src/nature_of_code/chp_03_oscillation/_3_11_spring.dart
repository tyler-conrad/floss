import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final f.Vector2 gravity = f.Vector2(0.0, 2.0);

class _Bob {
  static const double mass = 24.0;
  static const double damping = 0.98;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;
  final f.Vector2 dragOffset;

  bool dragging = false;

  _Bob({required this.position})
      : velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero(),
        dragOffset = f.Vector2.zero();

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
    acceleration.setValues(0.0, 0.0);

    return _Bob.update(
      position: pos,
      velocity: vel,
      acceleration: acceleration,
      dragOffset: dragOffset,
      dragging: dragging,
    );
  }

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  f.Drawing draw(f.Size size) {
    final c = dragging
        ? u.gray5
        : const p.HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.2).toColor();
    final r = u.scale(size) * mass;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()..color = c,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }

  void click(f.Vector2 mouse, f.Size size) {
    final m = position - mouse;
    if (m.length < u.scale(size) * mass) {
      dragging = true;
      dragOffset.setFrom(m);
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(f.Vector2 mouse) {
    if (dragging) {
      position.setFrom(mouse + dragOffset);
    }
  }
}

class _Spring {
  static const size = 10.0;
  static const double k = 0.2;

  final f.Vector2 anchor;
  final double length;

  _Spring({required this.anchor, required this.length});

  void connect(_Bob bob) {
    final force = bob.position - anchor;
    final stretch = force.length - length;
    bob.applyForce(force.normalized() * -k * stretch);
  }

  void constrainLength({
    required _Bob bob,
    required double minLen,
    required double maxLen,
  }) {
    final dir = bob.position - anchor;
    final d = dir.length;
    if (d < minLen) {
      dir.normalize();
      dir.scale(minLen);
      bob.position.setFrom(anchor + dir);
      bob.velocity.setValues(0.0, 0.0);
    } else if (d > maxLen) {
      dir.normalize();
      dir.scale(maxLen);
      bob.position.setFrom(anchor + dir);
      bob.velocity.setValues(0.0, 0.0);
    }
  }

  f.Drawing draw(f.Size size) {
    final s = u.scale(size);

    return f.Translate(
      translation: anchor,
      canvasOps: [
        f.Rectangle(
          rect: f.Rect.fromCenter(
            center: f.Offset.zero,
            width: s * _Spring.size,
            height: s * _Spring.size,
          ),
          paint: f.Paint()..color = u.gray5,
        ),
        f.Rectangle(
          rect: f.Rect.fromCenter(
            center: f.Offset.zero,
            width: s * _Spring.size,
            height: s * _Spring.size,
          ),
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }

  f.Drawing drawLine(_Bob bob) => f.Translate(
        translation: bob.position,
        canvasOps: [
          f.Line(
            p1: f.Offset.zero,
            p2: f.Offset.fromVec(anchor - bob.position),
            paint: f.Paint()
              ..color = u.black
              ..strokeWidth = 2.0,
          ),
        ],
      );
}

class _SpringModel extends f.Model {
  final _Bob bob;
  final _Spring spring;
  f.Vector2? mouse;

  _SpringModel.init({required super.size})
      : bob = _Bob(
          position: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        ),
        spring = _Spring(
          anchor: f.Vector2(
            size.width * 0.5,
            u.scale(size) * _Spring.size,
          ),
          length: size.height * 0.5,
        ),
        mouse = null;

  _SpringModel.update({
    required super.size,
    required this.bob,
    required this.spring,
    required this.mouse,
  });
}

class _SpringIud<M extends _SpringModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final spring = _Spring(
      anchor: f.Vector2(
        size.width * 0.5,
        u.scale(size) * _Spring.size,
      ),
      length: size.height * 0.5,
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
          bob.click(
            f.Vector2(
              event.localPosition.dx,
              event.localPosition.dy,
            ),
            size,
          );
          break;
        case f.PointerUp():
          bob.stopDragging();
          model.mouse = null;
          break;
        case f.PointerMove(:final event):
          model.mouse = f.Vector2(
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
      bob: bob,
      spring: spring,
      mouse: model.mouse,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
        canvasOps: [
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
        iud: _SpringIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
