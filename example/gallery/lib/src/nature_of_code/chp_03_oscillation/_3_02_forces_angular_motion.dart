import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Attractor {
  static const double gravity = 0.4;
  static const double mass = 20.0;
  static const double radius = 3.0;
  static const double forceLenDistMin = 5.0;
  static const double forceLenDistMax = 25.0;

  final ui.Offset position;

  _Attractor({required this.position});

  ui.Offset attract(_Mover m) {
    ui.Offset force = (position - m.position);
    final distance = force.distance.clamp(forceLenDistMin, forceLenDistMax);
    force = force.norm();
    return force * (gravity * mass * m.mass) / (distance * distance);
  }

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * radius * mass;
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
                ..style = ui.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _Mover {
  static const double sideLen = 32.0;
  static const double angularVelFactor = 0.1;
  static const double angularVelMin = -0.1;
  static const double angularVelMax = 0.1;
  static const double velHalfRange = 1.0;
  static const double massMin = 0.1;
  static const double massMax = 2.0;

  final double mass;
  ui.Offset position;
  ui.Offset velocity;
  ui.Offset acceleration;
  final double angle;
  final double aVelocity;
  final double aAcceleration;

  _Mover({required this.mass, required this.position})
    : velocity = ui.Offset(
        u.randDoubleRange(-velHalfRange, velHalfRange),
        u.randDoubleRange(-velHalfRange, velHalfRange),
      ),
      acceleration = ui.Offset.zero,
      angle = 0.0,
      aVelocity = 0.0,
      aAcceleration = 0.0;

  _Mover.update({
    required this.mass,
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.angle,
    required this.aVelocity,
    required this.aAcceleration,
  });

  void applyForce(ui.Offset force) {
    acceleration += force / mass;
  }

  _Mover update() {
    velocity += acceleration;
    position += velocity;
    final aAcc = acceleration.dx * angularVelFactor;
    final aVel = (aVelocity + aAcc).clamp(angularVelMin, angularVelMax);
    final a = angle + aVel;
    acceleration = ui.Offset(0.0, 0.0);

    return _Mover.update(
      mass: mass,
      position: position,
      velocity: velocity,
      acceleration: acceleration,
      angle: a,
      aVelocity: aVel,
      aAcceleration: aAcc,
    );
  }

  f.Drawing draw(ui.Size size) {
    final s = u.scale(size) * mass * sideLen;
    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Rotate(
          radians: angle,
          ops: [
            f.Rect(
              rect: ui.Rect.fromCenter(
                center: ui.Offset.zero,
                width: s,
                height: s,
              ),
              paint:
                  ui.Paint()
                    ..color =
                        const p.HSLColor.fromAHSL(
                          0.78,
                          0.0,
                          0.0,
                          0.6,
                        ).toColor(),
            ),
            f.Rect(
              rect: ui.Rect.fromCenter(
                center: ui.Offset.zero,
                width: s,
                height: s,
              ),
              paint:
                  ui.Paint()
                    ..color = u.black
                    ..style = p.PaintingStyle.stroke,
            ),
          ],
        ),
      ],
    );
  }
}

class _ForcesAngularMotionModel extends f.Model {
  static const int numMovers = 20;

  final List<_Mover> movers;
  final _Attractor attractor;

  _ForcesAngularMotionModel.init({
    required super.size,
    required super.inputEvents,
  }) : movers =
           List.generate(
             numMovers,
             (_) => _Mover(
               mass: u.randDoubleRange(_Mover.massMin, _Mover.massMax),
               position: ui.Offset(
                 u.randDoubleRange(0.0, size.width),
                 u.randDoubleRange(0.0, size.height),
               ),
             ),
           ).toList(),
       attractor = _Attractor(
         position: ui.Offset(size.width * 0.5, size.height * 0.5),
       );

  _ForcesAngularMotionModel.update({
    required super.size,
    required super.inputEvents,
    required this.movers,
    required this.attractor,
  });
}

class _ForcesAngularMotionIud<M extends _ForcesAngularMotionModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _ForcesAngularMotionModel.update(
            size: size,
            inputEvents: inputEvents,
            movers:
                model.movers.map((m) {
                  m.applyForce(model.attractor.attract(m));
                  return m.update();
                }).toList(),
            attractor: _Attractor(
              position: ui.Offset(size.width * 0.5, size.height * 0.5),
            ),
          )
          as M;

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(
        ops: [
          model.attractor.draw(model.size),
          for (final m in model.movers) m.draw(model.size),
        ],
      );
}

const String title = 'Forces - Angular Motion';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _ForcesAngularMotionModel.init,
    iud: _ForcesAngularMotionIud<_ForcesAngularMotionModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
