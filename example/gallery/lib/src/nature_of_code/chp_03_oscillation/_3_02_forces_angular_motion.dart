import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Attractor {
  static const double g = 0.4;
  static const double mass = 20.0;
  static const double forceLenDistMin = 5.0;
  static const double forceLenDistMax = 25.0;

  final f.Vector2 location;

  _Attractor({required this.location});

  f.Vector2 attract(_Mover m) {
    final force = (location - m.location);
    final distance = force.length.clamp(forceLenDistMin, forceLenDistMax);
    force.normalize();
    final strength = (g * mass * m.mass) / (distance * distance);
    return force * strength;
  }

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * mass;
    return f.Translate(
      translation: location,
      canvasOps: [
        f.Circle(
            c: f.Offset.zero, radius: r, paint: f.Paint()..color = u.gray5),
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _Mover {
  static const double size = 16.0;
  static const double angularVelFactor = 0.1;
  static const double angularVelMin = -0.1;
  static const double angularVelMax = 0.1;
  static const double velHalfRange = 1.0;
  static const double massMin = 0.1;
  static const double massMax = 2.0;

  final double mass;
  final f.Vector2 location;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;
  final double angle;
  final double aVelocity;
  final double aAcceleration;

  _Mover({
    required this.mass,
    required this.location,
  })  : velocity = f.Vector2(
          u.randDoubleRange(-velHalfRange, velHalfRange),
          u.randDoubleRange(-velHalfRange, velHalfRange),
        ),
        acceleration = f.Vector2.zero(),
        angle = 0.0,
        aVelocity = 0.0,
        aAcceleration = 0.0;

  _Mover.update({
    required this.mass,
    required this.location,
    required this.velocity,
    required this.acceleration,
    required this.angle,
    required this.aVelocity,
    required this.aAcceleration,
  });

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  _Mover update() {
    velocity.add(acceleration);
    location.add(velocity);
    final aAcc = acceleration.x * angularVelFactor;
    final aVel = (aVelocity + aAcc).clamp(angularVelMin, angularVelMax);
    final a = angle + aVel;
    acceleration.setValues(0.0, 0.0);

    return _Mover.update(
      mass: mass,
      location: location,
      velocity: velocity,
      acceleration: acceleration,
      angle: a,
      aVelocity: aVel,
      aAcceleration: aAcc,
    );
  }

  f.Drawing draw(f.Size size) {
    final s = u.scale(size) * mass * _Mover.size;
    return f.Translate(
      translation: location,
      canvasOps: [
        f.Rotate(
          radians: angle,
          canvasOps: [
            f.Rectangle(
              rect: f.Rect.fromCenter(
                center: f.Offset.zero,
                width: s,
                height: s,
              ),
              paint: f.Paint()
                ..color = const p.HSLColor.fromAHSL(
                  0.78,
                  0.0,
                  0.0,
                  0.6,
                ).toColor(),
            ),
            f.Rectangle(
              rect: f.Rect.fromCenter(
                center: f.Offset.zero,
                width: s,
                height: s,
              ),
              paint: f.Paint()
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

  _ForcesAngularMotionModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => _Mover(
            mass: u.randDoubleRange(_Mover.massMin, _Mover.massMax),
            location: f.Vector2(
              u.randDoubleRange(0.0, size.width),
              u.randDoubleRange(0.0, size.height),
            ),
          ),
        ).toList(),
        attractor = _Attractor(
          location: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        );

  _ForcesAngularMotionModel.update({
    required super.size,
    required this.movers,
    required this.attractor,
  });
}

class _ForcesAngularMotionIud<M extends _ForcesAngularMotionModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _ForcesAngularMotionModel.update(
          size: size,
          movers: model.movers.map(
            (m) {
              m.applyForce(model.attractor.attract(m));
              return m.update();
            },
          ).toList(),
          attractor: _Attractor(
            location: f.Vector2(
              size.width * 0.5,
              size.height * 0.5,
            ),
          )) as M;

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
        canvasOps: [
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
        iud: _ForcesAngularMotionIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
