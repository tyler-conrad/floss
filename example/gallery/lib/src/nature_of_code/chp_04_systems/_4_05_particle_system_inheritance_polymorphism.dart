import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

sealed class ParticleType extends c.Particle {
  ParticleType({required super.position});
}

class Circle extends ParticleType {
  static const radius = 24.0;

  Circle({required super.position});

  @override
  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * radius;
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()
            ..color = p.HSLColor.fromAHSL(
              lifespan / c.Particle.ls,
              0.0,
              0.0,
              0.5,
            ).toColor(),
        ),
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()
            ..color = p.HSLColor.fromAHSL(
              lifespan / c.Particle.ls,
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

class Confetti extends ParticleType {
  static const double sideLen = 48.0;

  Confetti({required super.position});

  @override
  f.Drawing draw(ui.Size size) {
    final s = u.scale(size) * sideLen;
    final theta = position.x / size.width * math.pi * 2.0;
    final a = lifespan / c.Particle.ls;
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Rotate(
          radians: theta,
          canvasOps: [
            f.Rectangle(
              rect: ui.Rect.fromCenter(
                center: ui.Offset.zero,
                width: s,
                height: s,
              ),
              paint: ui.Paint()
                ..color = p.HSLColor.fromAHSL(
                  a,
                  0.0,
                  0.0,
                  0.5,
                ).toColor(),
            ),
            f.Rectangle(
              rect: ui.Rect.fromCenter(
                center: ui.Offset.zero,
                width: s,
                height: s,
              ),
              paint: ui.Paint()
                ..color = p.HSLColor.fromAHSL(
                  a,
                  0.0,
                  0.0,
                  0.0,
                ).toColor()
                ..style = p.PaintingStyle.stroke
                ..strokeWidth = 2.0,
            )
          ],
        ),
      ],
    );
  }
}

class ParticleSystem<P extends c.Particle> extends c.ParticleSystem<P> {
  ParticleSystem({required super.origin});

  ParticleSystem.update({
    required super.origin,
    required super.particles,
  }) : super.update();

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

  @override
  void addParticle() {
    particles.add(
      math.Random().nextBool()
          ? Circle(
              position: ui.Offset(
                origin.x,
                origin.y,
              ),
            ) as P
          : Confetti(
              position: ui.Offset(
                origin.x,
                origin.y,
              ),
            ) as P,
    );
  }

  @override
  f.Drawing draw(ui.Size size) => f.Drawing(
        canvasOps:
            particles.map((p) => p.draw(size)).toList().reversed.toList(),
      );
}

class _ParticleSystemInheritancePolymorphismModel extends f.Model {
  static const topOffset = 50.0;

  final ParticleSystem<ParticleType> system;

  _ParticleSystemInheritancePolymorphismModel.init({required super.size})
      : system = ParticleSystem<ParticleType>(
          origin: ui.Offset(
            size.width * 0.5,
            topOffset,
          ),
        );

  _ParticleSystemInheritancePolymorphismModel.update({
    required super.size,
    required this.system,
  });
}

class _ParticleSystemInheritancePolymorphismIud<
        M extends _ParticleSystemInheritancePolymorphismModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.system.addParticle();

    return _ParticleSystemInheritancePolymorphismModel.update(
      size: size,
      system: model.system.update(
        ui.Offset(
          size.width * 0.5,
          u.scale(size) * _ParticleSystemInheritancePolymorphismModel.topOffset,
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

const String title = 'Particle System Polymorphism Inheritance';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _ParticleSystemInheritancePolymorphismModel.init,
        iud: _ParticleSystemInheritancePolymorphismIud<
            _ParticleSystemInheritancePolymorphismModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
