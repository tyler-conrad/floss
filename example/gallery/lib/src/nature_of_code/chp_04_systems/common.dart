import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class Particle {
  static const double radius = 24.0;
  static const double gravity = 0.05;
  static const double minVelX = -1.0;
  static const double maxVelX = 1.0;
  static const double minVelY = 1.0;
  static const double maxVelY = 0.0;
  static const int ls = 128;

  ui.Offset position;
  ui.Offset velocity;
  ui.Offset acceleration;

  int lifespan;

  Particle({required this.position})
    : velocity = ui.Offset(
        u.randDoubleRange(minVelX, maxVelX),
        u.randDoubleRange(minVelY, maxVelY),
      ),
      acceleration = ui.Offset(0.0, gravity),
      lifespan = ls;

  Particle.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.lifespan,
  });

  void update() {
    velocity += acceleration;
    position += velocity;
    lifespan -= 1;
  }

  bool get isDead => lifespan < 1;

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * radius;
    final a = lifespan / ls;
    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = p.HSLColor.fromAHSL(a, 0.0, 0.0, 0.5).toColor(),
        ),
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = p.HSLColor.fromAHSL(a, 0.0, 0.0, 0.0).toColor()
                ..style = p.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class ForceParticle extends Particle {
  static const mass = 1.0;
  static const minVelX = -1.0;
  static const maxVelX = 1.0;
  static const minVelY = 0.0;
  static const maxVelY = 2.0;

  ForceParticle({required super.position})
    : super.update(
        velocity: ui.Offset(
          u.randDoubleRange(minVelX, maxVelX),
          u.randDoubleRange(minVelY, minVelY),
        ),
        acceleration: ui.Offset.zero,
        lifespan: Particle.ls,
      );

  ForceParticle.update({
    required super.position,
    required super.velocity,
    required super.acceleration,
    required super.lifespan,
  }) : super.update();

  void applyForce(ui.Offset force) {
    acceleration += force / mass;
  }

  @override
  void update() {
    super.update();
    acceleration = ui.Offset.zero;
  }
}

class ParticleSystem<P extends Particle> {
  final List<P> particles;
  ui.Offset origin;

  ParticleSystem({required this.origin}) : particles = [];

  ParticleSystem.update({required this.origin, required this.particles});

  void addParticle() {
    particles.add(Particle(position: origin) as P);
  }

  ParticleSystem<P> update(ui.Offset origin) {
    final ps = particles.whereNot((p) => p.isDead);

    for (final p in ps) {
      p.update();
    }

    return ParticleSystem<P>.update(origin: origin, particles: ps.toList());
  }

  f.Drawing draw(ui.Size size) {
    return f.Drawing(ops: [for (final p in particles) p.draw(size)]);
  }
}
