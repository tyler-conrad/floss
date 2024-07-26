import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Attractor {
  static const double g = 1.0;
  static const double mass = 10.0;
  static const double radius = mass * 3.0;
  static const double massMin = 5.0;
  static const double massMax = 25.0;

  final f.Vector2 position;
  final f.Vector2 dragOffset;
  bool dragging;
  bool rollover;

  _Attractor({required this.position})
      : dragOffset = f.Vector2.zero(),
        dragging = false,
        rollover = false;

  f.Vector2 attract(_Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(massMin, d), massMax);
    force.normalize();
    final strength = (g * mass * m.mass) / (d * d);
    return force * strength;
  }

  f.Drawing draw() {
    double gray;
    if (dragging) {
      gray = 0.2;
    } else if (rollover) {
      gray = 0.4;
    } else {
      gray = 0.0;
    }

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: radius,
          paint: f.Paint()
            ..color = p.HSLColor.fromAHSL(
              1.0,
              0.0,
              0.0,
              gray,
            ).toColor(),
        ),
      ],
    );
  }

  void clicked(f.Vector2 mouse) {
    if ((position - mouse).length < radius) {
      dragging = true;
      dragOffset.setValues(
        position.x - mouse.x,
        position.y - mouse.y,
      );
    }
  }

  void over(f.Vector2 mouse) => rollover = (position - mouse).length < radius;

  void stopDragging() => dragging = false;

  void drag(f.Vector2 mouse) {
    if (dragging) {
      position.setValues(
        mouse.x + dragOffset.x,
        mouse.y + dragOffset.y,
      );
    }
  }
}

class _Mover {
  static const double forceLenMin = 1.0;
  static const double forceLenMax = 10000.0;
  static const double massMin = 4.0;
  static const double massMax = 12.0;

  final double mass;
  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover({
    required this.mass,
    required this.position,
  })  : velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  f.Drawing draw() => f.Translate(
        translation: position,
        canvasOps: [
          f.Circle(
            c: f.Offset.zero,
            radius: mass,
            paint: f.Paint()
              ..color = const p.HSLColor.fromAHSL(
                0.5,
                0.0,
                0.0,
                0.6,
              ).toColor(),
          ),
        ],
      );

  f.Vector2 repel(_Mover m) {
    final force = position - m.position;
    final double d = math.min(math.max(forceLenMin, force.length), forceLenMax);
    force.normalize();
    final strength = (_Attractor.g * mass * m.mass) / (d * d);
    return force * (-1.0 * strength);
  }
}

class _AttractRepelModel extends f.Model {
  static const int numMovers = 20;

  final List<_Mover> movers;
  final _Attractor attractor;
  final f.Vector2 mouse;

  _AttractRepelModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => _Mover(
              mass: u.randDoubleRange(_Mover.massMin, _Mover.massMax),
              position: f.Vector2(
                u.randDoubleRange(0.0, size.width),
                u.randDoubleRange(0.0, size.height),
              )),
        ).toList(),
        attractor = _Attractor(
          position: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        ),
        mouse = f.Vector2(
          size.width * 0.5,
          size.height * 0.5,
        );

  _AttractRepelModel.update({
    required super.size,
    required this.movers,
    required this.attractor,
    required this.mouse,
  });
}

class _AttractRepelIud<M extends _AttractRepelModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2? mouse;

    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          mouse = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          model.attractor.clicked(
            mouse,
          );
        case f.PointerHover(:final event):
          mouse = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          model.attractor.over(
            mouse,
          );
        case f.PointerMove(:final event):
          mouse = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          model.attractor.drag(
            mouse,
          );
        case f.PointerUp():
          model.attractor.stopDragging();
        default:
          break;
      }
    }

    for (final left in model.movers) {
      for (final right in model.movers) {
        if (left != right) {
          left.applyForce(right.repel(left));
        }
      }
      left.applyForce(model.attractor.attract(left));
      left.update();
    }

    return _AttractRepelModel.update(
      size: size,
      movers: model.movers,
      attractor: model.attractor,
      mouse: mouse ?? model.mouse,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
        canvasOps: [
          model.attractor.draw(),
          for (final m in model.movers) m.draw(),
        ],
      );
}

const String title = 'Attract Repel';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AttractRepelModel.init,
        iud: _AttractRepelIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
