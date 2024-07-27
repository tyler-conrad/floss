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

  int lifespan;

  _Particle({required this.position})
      : velocity = f.Vector2(
          u.randDoubleRange(minVel, maxVel),
          u.randDoubleRange(1.0, 0.0),
        ),
        acceleration = f.Vector2(0.0, 0.05),
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

class _ParticleSystem {
  final List<_Particle> particles;
  f.Vector2 origin;

  _ParticleSystem.init({required this.origin}) : particles = [];

  _ParticleSystem.update({
    required this.origin,
    required this.particles,
  });

  void addParticle() => particles.add(_Particle(position: origin));

  _ParticleSystem update() {
    final ps = particles.where((p) => !p.isDead);

    for (final p in ps) {
      p.update();
    }
    return _ParticleSystem.update(
      origin: origin,
      particles: particles.toList(),
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

class _VectorParticleModel extends f.Model {
  static const topOffset = 50.0;

  final _ParticleSystem ps;

  _VectorParticleModel.init({required super.size})
      : ps = _ParticleSystem.init(
          origin: f.Vector2(
            size.width * 0.5,
            topOffset,
          ),
        );

  _VectorParticleModel.update({
    required super.size,
    required this.ps,
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
    f.Vector2 origin = model.ps.origin;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerHover(:final event):
          origin = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          break;

        default:
          break;
      }
    }

    model.ps.addParticle();
    model.ps.update();

    return _VectorParticleModel.update(
        size: size,
        ps: _ParticleSystem.update(
          origin: origin,
          particles: model.ps.particles,
        )) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    return f.Drawing(
      canvasOps: [
        model.ps.draw(model.size),
      ],
    );
  }
}

const String title = 'Moving Particle System';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _VectorParticleModel.init,
        iud: _VectorParticleIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
