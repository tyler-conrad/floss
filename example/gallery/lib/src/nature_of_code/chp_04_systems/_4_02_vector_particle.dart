import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

class _VectorParticleModel extends f.Model {
  static const topOffset = 50.0;

  final List<c.Particle> particles;

  _VectorParticleModel.init({required super.size, required super.inputEvents})
    : particles = [];

  _VectorParticleModel.update({
    required super.size,
    required super.inputEvents,
    required this.particles,
  });
}

class _VectorParticleIud<M extends _VectorParticleModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.particles.add(
      c.Particle(
        position: ui.Offset(size.width * 0.5, _VectorParticleModel.topOffset),
      ),
    );

    for (final p in model.particles) {
      p.update();
    }

    return _VectorParticleModel.update(
          size: size,
          inputEvents: inputEvents,
          particles: model.particles.where((p) => !p.isDead).toList(),
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    return f.Drawing(
      ops: [for (final p in model.particles) p.draw(model.size)],
    );
  }
}

const String title = 'Vector Particle';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _VectorParticleModel.init,
    iud: _VectorParticleIud<_VectorParticleModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
