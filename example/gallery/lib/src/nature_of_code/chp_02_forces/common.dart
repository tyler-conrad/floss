import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class Mover {
  static const double radius = 8.0;
  static const double massMin = 1.0;
  static const double massMax = 4.0;

  final double mass;
  final ui.Offset position;
  final ui.Offset velocity;
  final ui.Offset acceleration;

  Mover({
    required this.mass,
    required this.position,
  })  : velocity = ui.Offset.zero(),
        acceleration = ui.Offset.zero();

  Mover.update({
    required this.mass,
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  void applyForce(ui.Offset force) {
    acceleration.add(force / mass);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  void checkEdges(ui.Rect rect) {
    if (position.x > rect.right) {
      position.x = rect.right;
      velocity.x *= -1.0;
    } else if (position.x < rect.left) {
      position.x = rect.left;
      velocity.x *= -1.0;
    }

    if (position.y > rect.bottom) {
      position.y = rect.bottom;
      velocity.y *= -1.0;
    }
  }

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * mass * radius;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = u.transparent5black,
        ),
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}
