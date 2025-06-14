import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class Repeller {
  static const double radius = 32.0;
  static const double gravity = 100.0;

  final ui.Offset position;

  Repeller({required this.position});

  ui.Offset repel(c.ForceParticle p) {
    ui.Offset dir = position - p.position;
    double l = dir.distance;
    dir = dir.norm();
    l = l.clamp(5.0, 100.0);
    final double force = -gravity / (l * l);
    return ui.Offset(dir.dx * force, dir.dy * force);
  }

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * radius;

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = p.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class ParticleSystem<P extends c.ForceParticle> extends c.ParticleSystem<P> {
  ParticleSystem({required super.origin});

  ParticleSystem.update({required super.origin, required super.particles})
    : super.update();

  void applyForce(ui.Offset force) {
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
  ParticleSystem<P> update(ui.Offset origin) {
    final ps = particles.whereNot((p) => p.isDead).toList().reversed;

    for (final p in ps) {
      p.update();
    }

    return ParticleSystem<P>.update(origin: origin, particles: ps.toList());
  }
}

class _ParticleSystemForcesRepellerModel extends f.Model {
  static const double topOffset = 50.0;

  final Repeller repeller;
  final ParticleSystem<c.ForceParticle> system;

  _ParticleSystemForcesRepellerModel.init({
    required super.size,
    required super.inputEvents,
  }) : repeller = Repeller(
         position: ui.Offset(size.width * 0.45, size.height * 0.5),
       ),
       system = ParticleSystem<c.ForceParticle>(
         origin: ui.Offset(size.width * 0.5, u.scale(size) * topOffset),
       );

  _ParticleSystemForcesRepellerModel.update({
    required super.size,
    required super.inputEvents,
    required this.repeller,
    required this.system,
  });
}

class _ParticleSystemForcesRepellerIud<
  M extends _ParticleSystemForcesRepellerModel
>
    extends f.IudBase<M>
    implements f.Iud<M> {
  static const double gravity = 0.1;

  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.system.addParticle();
    model.system.applyForce(ui.Offset(0.0, gravity));
    model.system.applyRepeller(model.repeller);

    return _ParticleSystemForcesRepellerModel.update(
          size: size,
          inputEvents: inputEvents,
          repeller: model.repeller,
          system: model.system.update(
            ui.Offset(
              size.width * 0.5,
              u.scale(size) * _ParticleSystemForcesRepellerModel.topOffset,
            ),
          ),
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(
        ops: [model.repeller.draw(model.size), model.system.draw(model.size)],
      );
}

const String title = 'Particle System Forces Repeller';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _ParticleSystemForcesRepellerModel.init,
    iud: _ParticleSystemForcesRepellerIud<_ParticleSystemForcesRepellerModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
