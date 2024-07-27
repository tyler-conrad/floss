import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class Mover {
  static const double radius = 8.0;
  static const double massMin = 1.0;
  static const double massMax = 4.0;

  final double mass;
  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  Mover({
    required this.mass,
    required this.position,
  })  : velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  Mover.update({
    required this.mass,
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  void checkEdges(f.Rect rect) {
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

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * mass * radius;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()..color = u.transparent5black,
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
}
