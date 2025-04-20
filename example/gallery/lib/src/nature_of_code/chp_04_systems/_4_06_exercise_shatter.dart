import 'dart:ui' as ui;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

class Particle extends c.Particle {
  static const double r = 8.0;

  Particle({required super.position});

  @override
  f.Drawing draw(ui.Size size) {
    final pos = position + ui.Offset(size.width * 0.5, size.height * 0.4);
    return f.Translate(
      dx: pos.dx,
      dy: pos.dy,
      ops: [
        f.Rect(
          rect: ui.Rect.fromCenter(center: ui.Offset.zero, width: r, height: r),
          paint:
              ui.Paint()
                ..color =
                    p.HSLColor.fromAHSL(
                      lifespan / c.Particle.ls,
                      0.0,
                      0.0,
                      0.0,
                    ).toColor(),
        ),
      ],
    );
  }
}

class ParticleSystem<P extends c.Particle> extends c.ParticleSystem<P> {
  static const int rows = 20;
  static const int cols = 20;

  bool intact = true;

  ParticleSystem({required ui.Size size, required super.origin}) {
    for (var y = 0; y < cols; y++) {
      for (var x = 0; x < rows; x++) {
        particles.add(
          Particle(position: ui.Offset(offset(rows, x), offset(cols, y))) as P,
        );
      }
    }
  }

  double offset(int d, int i) =>
      -0.5 * d * Particle.r + i * Particle.r + 0.5 * Particle.r;

  ParticleSystem.update({
    required super.origin,
    required super.particles,
    required this.intact,
  }) : super.update();

  void shatter() {
    intact = false;
  }

  @override
  ParticleSystem<P> update(ui.Offset origin) {
    final ps = particles.whereNot((p) => p.isDead).toList();

    if (!intact) {
      for (final p in ps.reversed) {
        p.update();
      }
    }

    return ParticleSystem<P>.update(
      origin: origin,
      particles: particles,
      intact: intact,
    );
  }
}

class _ShatterModel extends f.Model {
  final ParticleSystem system;

  _ShatterModel.init({required super.size, required super.inputEvents})
    : system = ParticleSystem(size: size, origin: ui.Offset.zero);

  _ShatterModel.update({
    required super.size,
    required super.inputEvents,
    required this.system,
  });
}

class _ShatterIud<M extends _ShatterModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown():
          model.system.shatter();
          break;

        default:
          break;
      }
    }
    return _ShatterModel.update(
          size: size,
          inputEvents: inputEvents,
          system: model.system.update(ui.Offset.zero),
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.system.draw(model.size);
}

const String title = 'Shatter';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _ShatterModel.init,
    iud: _ShatterIud<_ShatterModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
