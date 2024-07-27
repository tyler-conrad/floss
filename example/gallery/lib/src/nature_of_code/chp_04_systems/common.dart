import 'package:collection/collection.dart';
import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class Particle {
  static const double radius = 24.0;
  static const double gravity = 0.05;
  static const double minVelX = -1.0;
  static const double maxVelX = 1.0;
  static const double minVelY = 1.0;
  static const double maxVelY = 0.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  int lifespan;

  Particle({required this.position})
      : velocity = f.Vector2(
          u.randDoubleRange(minVelX, maxVelX),
          u.randDoubleRange(minVelY, maxVelY),
        ),
        acceleration = f.Vector2(0.0, gravity),
        lifespan = 256;

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2;
  }

  bool get isDead => lifespan == 0;

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * radius;
    final a = lifespan / 256.0;
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = p.HSLColor.fromAHSL(
              a,
              0.0,
              0.0,
              0.5,
            ).toColor(),
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = p.HSLColor.fromAHSL(
              a,
              0.0,
              0.0,
              0.0,
            ).toColor()
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class ParticleSystem {
  final List<Particle> particles;
  f.Vector2 origin;

  ParticleSystem({required this.origin}) : particles = [];

  ParticleSystem.update({
    required this.origin,
    required this.particles,
  });

  void addParticle() {
    particles.add(
      Particle(
        position: f.Vector2(
          origin.x,
          origin.y,
        ),
      ),
    );
  }

  ParticleSystem update(f.Vector2 origin) {
    final ps = particles.whereNot((p) => p.isDead);

    for (final p in ps) {
      p.update();
    }

    return ParticleSystem.update(
      origin: origin,
      particles: ps.toList(),
    );
  }

  f.Drawing draw(f.Size size) {
    return f.Drawing(
      canvasOps: [
        for (final p in particles) p.draw(size),
      ],
    );
  }
}
