import 'dart:ui' as ui;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class Mover {
  static const double radius = 24.0;
  static const double massMin = 1.0;
  static const double massMax = 4.0;

  final double mass;
  ui.Offset position;
  ui.Offset velocity;
  ui.Offset acceleration;

  Mover({required this.mass, required this.position})
    : velocity = ui.Offset.zero,
      acceleration = ui.Offset.zero;

  Mover.update({
    required this.mass,
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  void applyForce(ui.Offset force) {
    acceleration += force / mass;
  }

  void update() {
    velocity += acceleration;
    position += velocity;
    acceleration = ui.Offset(0.0, 0.0);
  }

  void checkEdges(ui.Rect rect) {
    if (position.dx > rect.right) {
      position = ui.Offset(rect.right, position.dy);
      velocity = ui.Offset(-velocity.dx, velocity.dy);
    } else if (position.dx < rect.left) {
      position = ui.Offset(rect.left, position.dy);
      velocity = ui.Offset(-velocity.dx, velocity.dy);
    }

    if (position.dy > rect.bottom) {
      position = ui.Offset(position.dx, rect.bottom);
      velocity = ui.Offset(velocity.dx, -velocity.dy);
    }
  }

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * mass * radius;

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = u.transparent5black,
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
}
