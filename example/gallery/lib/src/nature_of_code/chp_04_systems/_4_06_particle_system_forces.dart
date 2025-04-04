import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class ParticleSystem<P extends c.ForceParticle> extends c.ParticleSystem<P> {
  ParticleSystem({
    required super.origin,
  });

  ParticleSystem.update({
    required super.origin,
    required super.particles,
  }) : super.update();

  void applyForce(ui.Offset force) {
    for (final particle in particles) {
      particle.applyForce(force);
    }
  }

  @override
  void addParticle() {
    particles.add(c.ForceParticle(position: origin) as P);
  }

  @override
  ParticleSystem<P> update(ui.Offset origin) {
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

class _ParticleSystemForcesModel extends f.Model {
  static const double topOffset = 50.0;

  final ParticleSystem<c.ForceParticle> system;

  _ParticleSystemForcesModel.init({
    required super.size,
  }) : system = ParticleSystem<c.ForceParticle>(
          origin: ui.Offset(
            size.width * 0.5,
            u.scale(size) * topOffset,
          ),
        );

  _ParticleSystemForcesModel.update({
    required super.size,
    required this.system,
  });
}

class _ParticleSystemForcesIud<M extends _ParticleSystemForcesModel>
    extends f.IudBase<M> implements f.Iud<M> {
  static const double gravity = 0.1;

  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.system.applyForce(ui.Offset(0.0, gravity));
    model.system.addParticle();

    return _ParticleSystemForcesModel.update(
      size: size,
      system: model.system.update(
        ui.Offset(
          size.width * 0.5,
          u.scale(size) * _ParticleSystemForcesModel.topOffset,
        ),
      ),
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) =>
      model.system.draw(model.size);
}

const String title = 'Particle System Forces';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _ParticleSystemForcesModel.init,
        iud: _ParticleSystemForcesIud<_ParticleSystemForcesModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
