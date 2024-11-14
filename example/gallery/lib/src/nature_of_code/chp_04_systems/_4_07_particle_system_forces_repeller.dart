import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class Repeller {
  static const double radius = 32.0;
  static const double gravity = 100.0;

  final f.Vector2 position;

  Repeller({required this.position});

  f.Vector2 repel(c.ForceParticle p) {
    final f.Vector2 dir = position - p.position;
    double l = dir.length;
    dir.normalize();
    l = l.clamp(5.0, 100.0);
    final double force = -gravity / (l * l);
    return f.Vector2(dir.x * force, dir.y * force);
  }

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * radius;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()..color = u.gray5,
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

class ParticleSystem<P extends c.ForceParticle> extends c.ParticleSystem<P> {
  ParticleSystem({
    required super.origin,
  });

  ParticleSystem.update({
    required super.origin,
    required super.particles,
  }) : super.update();

  void applyForce(f.Vector2 force) {
    for (final particle in particles) {
      particle.applyForce(force);
    }
  }

  void applyRepeller(Repeller repeller) {
    for (final particle in particles) {
      particle.applyForce(repeller.repel(particle));
    }
  }

  @override
  void addParticle() {
    particles.add(c.ForceParticle(position: origin) as P);
  }

  @override
  ParticleSystem<P> update(f.Vector2 origin) {
    final ps = particles.whereNot((p) => p.isDead).toList().reversed;

    for (final p in ps) {
      p.update();
    }

    return ParticleSystem<P>.update(
      origin: origin,
      particles: ps.toList(),
    );
  }
}

class _ParticleSystemForcesRepellerModel extends f.Model {
  static const double topOffset = 50.0;

  final Repeller repeller;
  final ParticleSystem<c.ForceParticle> system;

  _ParticleSystemForcesRepellerModel.init({required super.size})
      : repeller = Repeller(
            position: f.Vector2(
          size.width * 0.45,
          size.height * 0.5,
        )),
        system = ParticleSystem<c.ForceParticle>(
          origin: f.Vector2(
            size.width * 0.5,
            u.scale(size) * topOffset,
          ),
        );

  _ParticleSystemForcesRepellerModel.update({
    required super.size,
    required this.repeller,
    required this.system,
  });
}

class _ParticleSystemForcesRepellerIud<
        M extends _ParticleSystemForcesRepellerModel> extends f.IudBase<M>
    implements f.Iud<M> {
  static const double gravity = 0.1;

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.system.addParticle();
    model.system.applyForce(f.Vector2(0.0, gravity));
    model.system.applyRepeller(model.repeller);

    return _ParticleSystemForcesRepellerModel.update(
      size: size,
      repeller: model.repeller,
      system: model.system.update(
        f.Vector2(
          size.width * 0.5,
          u.scale(size) * _ParticleSystemForcesRepellerModel.topOffset,
        ),
      ),
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) =>
      f.Drawing(
        canvasOps: [
          model.repeller.draw(model.size),
          model.system.draw(model.size),
        ],
      );
}

const String title = 'Particle System Forces Repeller';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _ParticleSystemForcesRepellerModel.init,
        iud: _ParticleSystemForcesRepellerIud<
            _ParticleSystemForcesRepellerModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
