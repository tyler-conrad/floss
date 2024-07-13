import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

const int numMovers = 20;

class Mover {
  static const double size = 8.0;
  static const double g = 0.4;
  static const double padding = 50.0;

  final double mass;
  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  Mover({
    required double m,
    required this.position,
  })  : mass = m,
        velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  void applyForce(f.Vector2 force) {
    final f = force / mass;
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  f.Drawing display() {
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: mass * size,
          paint: f.Paint()
            ..color = const p.HSLColor.fromAHSL(
              0.7,
              0.0,
              0.0,
              0.6,
            ).toColor(),
        ),
      ],
    );
  }

  f.Vector2 attract(Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(5.0, d), 25.0);
    force.normalize();
    final strength = (g * mass * m.mass) / (d * d);
    return force * strength;
  }

  void boundaries(f.Rect rect) {
    final r = rect.inflate(padding);
    final force = f.Vector2.zero();

    if (position.x < r.left) {
      force.x = 1.0;
    } else if (position.x > rect.right) {
      force.x = -1.0;
    }

    if (position.y > r.bottom) {
      force.y = -1.0;
    } else if (position.y < r.top) {
      force.y = 1.0;
    }

    if (force.length > 0.0) {
      force.normalize();
      force.multiply(f.Vector2(0.1, 0.1));
      applyForce(force);
    }
  }
}

class ForcesManyMutualBoundariesModel extends f.Model {
  final List<Mover> movers;

  ForcesManyMutualBoundariesModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => Mover(
            m: u.randDoubleRange(1.0, 2.0),
            position: f.Vector2(
              u.randDoubleRange(0.0, size.width),
              u.randDoubleRange(0.0, size.height),
            ),
          ),
        ).toList();

  ForcesManyMutualBoundariesModel.update({
    required super.size,
    required this.movers,
  });
}

class ForcesManyMutualBoundariesIur<M extends ForcesManyMutualBoundariesModel>
    extends f.IurBase<M> implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final left in model.movers) {
      for (final right in model.movers) {
        if (left != right) {
          left.applyForce(right.attract(left));
        }
      }
      left.boundaries(
        f.Rect.fromOffsetSize(
          f.Offset.zero,
          size,
        ),
      );
      left.update();
    }
    return ForcesManyMutualBoundariesModel.update(
      size: size,
      movers: model.movers,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return f.Drawing(
      canvasOps: model.movers.map((m) => m.display()).toList(),
    );
  }
}
