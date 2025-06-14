import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final rng = math.Random();

class _Particle {
  final ui.Offset position;
  final double radius;
  _Particle() : position = ui.Offset.zero, radius = 0.0;

  _Particle.update({required this.position, required this.radius});

  f.Drawing draw() {
    final l = rng.nextDouble();
    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: radius,
          paint:
              ui.Paint()
                ..color = p.HSLColor.fromAHSL(1.0, 0.0, 0.0, l).toColor(),
        ),
        f.Circle(
          center: ui.Offset.zero,
          radius: radius,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = p.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

class _Wave {
  static const double radius = 2.0;
  static const double angularVel = 0.02;

  final int numParticles;
  final ui.Offset originFactor;
  final double theta;
  final double widthFactor;
  final double period;
  final double amplitude;
  final List<_Particle> particles;

  _Wave.init({
    required this.numParticles,
    required this.originFactor,
    required this.widthFactor,
    required this.period,
    required this.amplitude,
  }) : theta = 0.0,
       particles = List.filled(numParticles, _Particle());

  _Wave.update({
    required this.numParticles,
    required this.originFactor,
    required this.theta,
    required this.widthFactor,
    required this.period,
    required this.amplitude,
    required this.particles,
  });

  _Wave calculate(ui.Size size) => _Wave.update(
    numParticles: numParticles,
    originFactor: originFactor,
    theta: theta + angularVel,
    widthFactor: widthFactor,
    period: period,
    amplitude: amplitude,
    particles:
        particles.mapIndexed((i, _) {
          final xOffset = size.width * widthFactor / numParticles;
          return _Particle.update(
            position: ui.Offset(
              i * xOffset,
              amplitude *
                  math.sin(
                    u.scale(size) *
                            i *
                            2.0 *
                            math.pi /
                            period *
                            widthFactor *
                            size.width /
                            numParticles +
                        theta,
                  ),
            ),
            radius: u.scale(size) * radius * xOffset,
          );
        }).toList(),
  );

  f.Drawing draw(ui.Size size) => f.Translate(
    dx: size.width * originFactor.dx,
    dy: size.height * originFactor.dy,

    ops: [for (final p in particles) p.draw()],
  );
}

class _OopWaveParticlesModel extends f.Model {
  final _Wave waveOne;
  final _Wave waveTwo;

  _OopWaveParticlesModel.init({required super.size, required super.inputEvents})
    : waveOne = _Wave.init(
        numParticles: 15,
        originFactor: ui.Offset(0.1, 0.4),
        widthFactor: 0.3,
        period: 400.0,
        amplitude: 30.0,
      ),
      waveTwo = _Wave.init(
        numParticles: 40,
        originFactor: ui.Offset(0.5, 0.5),
        widthFactor: 0.4,
        period: 600.0,
        amplitude: 70.0,
      );

  _OopWaveParticlesModel.update({
    required super.size,
    required super.inputEvents,
    required this.waveOne,
    required this.waveTwo,
  });
}

class _OopWaveParticlesIud<M extends _OopWaveParticlesModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _OopWaveParticlesModel.update(
            size: size,
            inputEvents: inputEvents,
            waveOne: model.waveOne.calculate(size),
            waveTwo: model.waveTwo.calculate(size),
          )
          as M;

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(
        ops: [model.waveOne.draw(model.size), model.waveTwo.draw(model.size)],
      );
}

const String title = 'OOP Wave Particles';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _OopWaveParticlesModel.init,
    iud: _OopWaveParticlesIud<_OopWaveParticlesModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
