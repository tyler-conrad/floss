import 'package:flutter/painting.dart' as p;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

const int numMovers = 20;

class Mover  {
  static const double size = 8.0;

  final double mass;
  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  Mover({
    required double m,
    required double x,
    required double y,
  })  : mass = m,
        position = f.Vector2(
          x,
          y,
        ),
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

  f.Drawing display() {
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: mass * size,
          paint: f.Paint()
            ..color = u.transparent5black,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: mass * size,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class RealGravityModel extends f.Model {
  final List<Mover> movers;

  RealGravityModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => Mover(
            m: u.randDoubleRange(1.0, 4.0),
            x: 0.0,
            y: 0.0,
          ),
        ).toList();

  RealGravityModel.update({
    required super.size,
    required this.movers,
  });
}

class RealGravityIur<M extends RealGravityModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final wind = f.Vector2(0.01, 0.0);
    for (final m in model.movers) {
      m.applyForce(wind);
      m.applyForce(
        f.Vector2(
          0.0,
          0.1 * m.mass,
        ),
      );
      m.update();
      m.checkEdges(
        f.Rect.fromOffsetSize(
          f.Offset(0.0, 0.0),
          size,
        ),
      );
    }

    return RealGravityModel.update(
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
