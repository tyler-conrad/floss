import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

class Particle extends c.Particle {
  static const double r = 8.0;

  Particle({required super.position});

  @override
  f.Drawing draw(f.Size size) {
    return f.Translate(
      translation: position +
          f.Vector2(
            size.width * 0.5,
            size.height * 0.4,
          ),
      canvasOps: [
        f.Rectangle(
          rect: f.Rect.fromCenter(
            center: f.Offset.zero,
            width: r,
            height: r,
          ),
          paint: f.Paint()
            ..color = p.HSLColor.fromAHSL(
              lifespan / 256.0,
              0.0,
              0.0,
              0.0,
            ).toColor(),
        ),
      ],
    );
  }
}

class ParticleSystem extends c.ParticleSystem<Particle> {
  static const int rows = 20;
  static const int cols = 20;

  bool intact = true;

  ParticleSystem({
    required f.Size size,
    required super.origin,
  }) {
    for (var y = 0; y < cols; y++) {
      for (var x = 0; x < rows; x++) {
        particles.add(
          Particle(
            position: f.Vector2(
              offset(rows, x),
              offset(cols, y),
            ),
          ),
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
  ParticleSystem update(f.Vector2 origin) {
    final ps = particles.whereNot((p) => p.isDead).toList();

    if (!intact) {
      for (final p in ps.reversed) {
        p.update();
      }
    }

    return ParticleSystem.update(
      origin: origin,
      particles: ps,
      intact: intact,
    );
  }
}

class _ShatterModel extends f.Model {
  final ParticleSystem system;

  _ShatterModel.init({required super.size})
      : system = ParticleSystem(
          size: size,
          origin: f.Vector2.zero(),
        );

  _ShatterModel.update({
    required super.size,
    required this.system,
  });
}

class _ShatterIud<M extends _ShatterModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
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
      system: model.system.update(f.Vector2.zero()),
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    return model.system.draw(model.size);
  }
}

const String title = 'Shatter';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _ShatterModel.init,
        iud: _ShatterIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
