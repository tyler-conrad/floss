import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class Particle extends c.ForceParticle {
  static const double radius = 24.0;
  static const double gravity = 0.05;
  static const double minVelX = -1.0;
  static const double maxVelX = 1.0;
  static const double minVelY = -1.0;
  static const double maxVelY = 0.0;

  bool highlight = false;

  Particle({required super.position})
      : super.update(
          velocity: f.Vector2(
            u.randDoubleRange(minVelX, maxVelX),
            u.randDoubleRange(minVelY, maxVelY),
          ),
          acceleration: f.Vector2(0.0, gravity),
          lifespan: c.Particle.ls,
        );

  void intersects(Iterable<Particle> particles, f.Size size) {
    highlight = false;
    for (final p in particles) {
      if (p != this &&
          p.position.distanceTo(position) <= u.scale(size) * radius) {
        highlight = true;
        break;
      }
    }
  }

  @override
  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * radius;
    final a = lifespan / c.Particle.ls;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = highlight
                ? const p.HSLColor.fromAHSL(
                    1.0,
                    0.0,
                    1.0,
                    0.5,
                  ).toColor()
                : p.HSLColor.fromAHSL(
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

class ParticleSystem<P extends c.ForceParticle> extends c.ParticleSystem<P> {
  ParticleSystem({required super.origin});

  ParticleSystem.update({
    required super.origin,
    required super.particles,
  }) : super.update();

  void intersection(f.Size size) {
    for (final p in particles) {
      (p as Particle).intersects(
        particles as Iterable<Particle>,
        size,
      );
    }
  }

  @override
  void addParticle() {
    particles.add(
      Particle(position: f.Vector2(origin.x, origin.y)) as P,
    );
  }

  @override
  ParticleSystem<P> update(f.Vector2 origin) {
    final ps = particles.whereNot((p) => p.isDead);

    for (final p in ps) {
      p.update();
    }

    return ParticleSystem<P>.update(
      origin: origin,
      particles: ps.toList(),
    );
  }
}

class _ParticleIntersectionModel extends f.Model {
  static const topOffset = 50.0;

  final ParticleSystem<Particle> system;
  final f.Vector2 mouse;

  _ParticleIntersectionModel.init({required super.size})
      : system = ParticleSystem<Particle>(
          origin: f.Vector2(
            size.width / 2,
            u.scale(size) * topOffset,
          ),
        ),
        mouse = f.Vector2(size.width * 0.5, size.height * 0.5);

  _ParticleIntersectionModel.update({
    required super.size,
    required this.system,
    required this.mouse,
  });
}

class _ParticleIntersectionIud<M extends _ParticleIntersectionModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2 mouse = model.mouse;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerHover(:final event):
          mouse = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          break;

        default:
          break;
      }
    }

    model.system.addParticle();
    final s = model.system.update(mouse);
    s.intersection(size);

    return _ParticleIntersectionModel.update(
      size: size,
      system: s,
      mouse: mouse,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      model.system.draw(model.size);
}

const String title = 'Particle Intersection';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _ParticleIntersectionModel.init,
        iud: _ParticleIntersectionIud<_ParticleIntersectionModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
