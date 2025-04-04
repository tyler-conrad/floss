import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/painting.dart' as p;

final _rand = math.Random();

double randDoubleRange(double min, double max) =>
    min + _rand.nextDouble() * (max - min);

class Particle {
  static const double radius = 24.0;
  static const double gravity = 0.05;
  static const double minVelX = -1.0;
  static const double maxVelX = 1.0;
  static const double minVelY = 1.0;
  static const double maxVelY = 0.0;
  static const int ls = 128;

  ui.Offset position;
  ui.Offset velocity;
  final ui.Offset acceleration;

  int lifespan;

  Particle({required this.position})
    : velocity = ui.Offset(
        randDoubleRange(minVelX, maxVelX),
        randDoubleRange(minVelY, maxVelY),
      ),
      acceleration = ui.Offset(0.0, gravity),
      lifespan = ls;

  Particle.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.lifespan,
  });

  void update() {
    velocity += acceleration;
    position += velocity;
    lifespan -= 1;
  }

  bool get isDead => lifespan < 1;

  f.Drawing draw(ui.Size size) {
    final a = lifespan / ls;
    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      canvasOps: [
        f.Circle(
          c: ui.Offset.zero,
          radius: radius,
          paint:
              ui.Paint()
                ..color = p.HSLColor.fromAHSL(a, 0.0, 0.0, 0.5).toColor(),
        ),
        f.Circle(
          c: ui.Offset.zero,
          radius: radius,
          paint:
              ui.Paint()
                ..color = p.HSLColor.fromAHSL(a, 0.0, 0.0, 0.0).toColor()
                ..style = p.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class ParticleSystem<P extends Particle> {
  final List<P> particles;
  ui.Offset origin;

  ParticleSystem({required this.origin}) : particles = [];

  ParticleSystem.update({required this.origin, required this.particles});

  void addParticle() {
    particles.add(Particle(position: ui.Offset(origin.dx, origin.dy)) as P);
  }

  ParticleSystem<P> update(ui.Offset origin) {
    final ps = particles.whereNot((p) => p.isDead);

    for (final p in ps) {
      p.update();
    }

    return ParticleSystem<P>.update(origin: origin, particles: ps.toList());
  }

  f.Drawing draw(ui.Size size) {
    return f.Drawing(canvasOps: [for (final p in particles) p.draw(size)]);
  }
}

class _MovingParticleSystemModel extends f.Model {
  static const topOffset = 50.0;

  final ParticleSystem system;
  final ui.Offset mouse;

  _MovingParticleSystemModel.init({
    required super.size,
    required super.inputEvents,
  }) : system = ParticleSystem(origin: ui.Offset(size.width * 0.5, topOffset)),
       mouse = ui.Offset(size.width * 0.5, size.height * 0.5);

  _MovingParticleSystemModel.update({
    required super.size,
    required super.inputEvents,
    required this.system,
    required this.mouse,
  });
}

class _MovingParticleSystemIud<M extends _MovingParticleSystemModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    ui.Offset mouse = model.mouse;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerHover(:final event):
          mouse = ui.Offset(event.localPosition.dx, event.localPosition.dy);

        default:
          break;
      }
    }

    ParticleSystem ps = model.system;
    model.system.addParticle();
    ps = ps.update(mouse);

    return _MovingParticleSystemModel.update(
          size: size,
          inputEvents: inputEvents,
          system: ps,
          mouse: mouse,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.system.draw(model.size);
}

void main() {
  w.runApp(
    w.WidgetsApp(
      color: const p.HSVColor.fromAHSV(1.0, 240.0, 1.0, 0.5).toColor(),
      builder: (context, child) {
        return f.FlossWidget(
          focusNode: w.FocusNode(),
          config: f.Config(
            modelCtor: _MovingParticleSystemModel.init,
            iud: _MovingParticleSystemIud<_MovingParticleSystemModel>(),
            clearCanvas: const f.ClearCanvas(),
          ),
        );
      },
    ),
  );
}
