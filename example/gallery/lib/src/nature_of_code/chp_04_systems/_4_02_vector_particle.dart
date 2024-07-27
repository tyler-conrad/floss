import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Particle {
  static const double radius = 24.0;
  static const double minVel = -1.0;
  static const double maxVel = 1.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  double lifespan;

  _Particle({required this.position})
      : velocity = f.Vector2(
          u.randDoubleRange(minVel, maxVel),
          u.randDoubleRange(1.0, 0.0),
        ),
        acceleration = f.Vector2(0.0, 0.05),
        lifespan = 255.0;

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2.0;
  }

  bool get isDead => lifespan < 0.0;

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * radius;
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = p.HSLColor.fromAHSL(
              lifespan / 255.0,
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
              lifespan / 255.0,
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

class _VectorParticleModel extends f.Model {
  static const topOffset = 50.0;

  final List<_Particle> particles;

  _VectorParticleModel.init({required super.size}) : particles = [];

  _VectorParticleModel.update({
    required super.size,
    required this.particles,
  });
}

class _VectorParticleIud<M extends _VectorParticleModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.particles.add(_Particle(
      position: f.Vector2(
        size.width * 0.5,
        _VectorParticleModel.topOffset,
      ),
    ));

    for (final p in model.particles) {
      p.update();
    }

    return _VectorParticleModel.update(
      size: size,
      particles: model.particles.where((p) => !p.isDead).toList(),
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    return f.Drawing(
      canvasOps: [
        for (final p in model.particles) p.draw(model.size),
      ],
    );
  }
}

const String title = 'Vector Particle';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _VectorParticleModel.init,
        iud: _VectorParticleIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
