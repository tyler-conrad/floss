import 'dart:math' as m;

import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

const int numMovers = 20;
const double fDistMin = 5.0;
const double fDistMax = 25.0;
const double aVelFactor = 0.1;
const double aVelMin = -0.1;
const double aVelMax = 0.1;
const double velHalfRange = 1.0;
const double massMin = 0.1;
const double massMax = 2.0;

final rng = m.Random();

class Attractor {
  static const double g = 0.4;
  static const double mass = 20.0;

  final f.Vector2 location;

  Attractor({required this.location});

  Attractor.update({
    required this.location,
  });

  f.Vector2 attract(Mover m) {
    final force = (location - m.location);
    final distance = force.length.clamp(fDistMin, fDistMax);
    force.normalize();
    final strength = (g * mass * m.mass) / (distance * distance);
    return force * strength;
  }

  f.Drawing display() {
    return f.Translate(
      translation: location,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: mass,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: mass,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class Mover {
  static const double size = 16.0;

  final double mass;
  final f.Vector2 location;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;
  final double angle;
  final double aVelocity;
  final double aAcceleration;

  Mover({
    required this.mass,
    required this.location,
  })  : velocity = f.Vector2(
          rng.nextDouble() * 2.0 * velHalfRange - velHalfRange,
          rng.nextDouble() * 2.0 * velHalfRange - velHalfRange,
        ),
        acceleration = f.Vector2.zero(),
        angle = 0.0,
        aVelocity = 0.0,
        aAcceleration = 0.0;

  Mover.update({
    required this.mass,
    required this.location,
    required this.velocity,
    required this.acceleration,
    required this.angle,
    required this.aVelocity,
    required this.aAcceleration,
  });

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  Mover update() {
    velocity.add(acceleration);
    location.add(velocity);
    final aAcc = acceleration.x * aVelFactor;
    final aVel = (aVelocity + aAcc).clamp(aVelMin, aVelMax);
    final a = angle + aVel;
    acceleration.setValues(0.0, 0.0);

    return Mover.update(
      mass: mass,
      location: location,
      velocity: velocity,
      acceleration: acceleration,
      angle: a,
      aVelocity: aVel,
      aAcceleration: aAcc,
    );
  }

  f.Drawing display() {
    final s = mass * size;
    return f.Translate(
      translation: location,
      canvasOps: [
        f.Rotate(
          radians: angle,
          canvasOps: [
            f.Rectangle(
              rect: f.Rect.fromCenter(
                center: f.Offset.zero,
                width: s,
                height: s,
              ),
              paint: f.Paint()
                ..color = const p.HSLColor.fromAHSL(
                  0.78,
                  0.0,
                  0.0,
                  0.6,
                ).toColor(),
            ),
            f.Rectangle(
              rect: f.Rect.fromCenter(
                center: f.Offset.zero,
                width: s,
                height: s,
              ),
              paint: f.Paint()
                ..color = u.black
                ..style = p.PaintingStyle.stroke,
            ),
          ],
        ),
      ],
    );
  }
}

class ForcesAngularMotionModel extends f.Model {
  final List<Mover> movers;
  final Attractor attractor;

  ForcesAngularMotionModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => Mover(
            mass: u.randDoubleRange(massMin, massMax),
            location: f.Vector2(
              u.randDoubleRange(0.0, size.width),
              u.randDoubleRange(0.0, size.height),
            ),
          ),
        ).toList(),
        attractor = Attractor(
          location: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        );

  ForcesAngularMotionModel.update({
    required super.size,
    required this.movers,
    required this.attractor,
  });
}

class ForcesAngularMotionIur<M extends ForcesAngularMotionModel>
    extends f.IurBase<M> implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final movers = model.movers.map(
      (m) {
        m.applyForce(model.attractor.attract(m));
        return m.update();
      },
    ).toList();

    return ForcesAngularMotionModel.update(
      size: size,
      movers: movers,
      attractor: model.attractor,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return f.Drawing(
      canvasOps: [
        model.attractor.display(),
        for (final m in model.movers) m.display(),
      ],
    );
  }
}
