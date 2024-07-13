import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

const int numMovers = 20;

class Attractor {
  static const double g = 1.0;
  static const double mass = 10.0;
  static const double radius = mass * 3.0;

  final f.Vector2 position;
  final f.Vector2 dragOffset;
  bool dragging;
  bool rollover;

  Attractor({required this.position})
      : dragOffset = f.Vector2.zero(),
        dragging = false,
        rollover = false;

  Attractor.update({
    required this.position,
    required this.dragOffset,
    required this.dragging,
    required this.rollover,
  });

  f.Vector2 attract(Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(5.0, d), 25.0);
    force.normalize();
    final strength = (g * mass * m.mass) / (d * d);
    return force * strength;
  }

  f.Drawing display() {
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

class Mover {
  final double mass;
  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  Mover({
    required this.mass,
    required this.position,
  })  : velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  void applyForce(f.Vector2 force) {
    final f = force / mass;
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  f.Drawing display() {
    return f.Translate(
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
  }

  f.Vector2 repel(Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(1.0, d), 10000.0);
    force.normalize();
    final strength = (Attractor.g * mass * m.mass) / (d * d);
    return force * (-1.0 * strength);
  }
}

class AttractRepelModel extends f.Model {
  final List<Mover> movers;
  final Attractor attractor;
  final f.Vector2 mouse;

  AttractRepelModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => Mover(
              mass: u.randDoubleRange(4.0, 12.0),
              position: f.Vector2(
                u.randDoubleRange(0.0, size.width),
                u.randDoubleRange(0.0, size.height),
              )),
        ).toList(),
        attractor = Attractor(
          position: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        ),
        mouse = f.Vector2(
          size.width * 0.5,
          size.height * 0.5,
        );

  AttractRepelModel.update({
    required super.size,
    required this.movers,
    required this.attractor,
    required this.mouse,
  });
}

class AttractRepelIur<M extends AttractRepelModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2? mouse;

    for (final ie in inputEvents.list) {
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

    return AttractRepelModel.update(
      size: size,
      movers: model.movers,
      attractor: model.attractor,
      mouse: mouse ?? model.mouse,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return f.Drawing(
      canvasOps: [
        model.attractor.display(),
        for (final m in model.movers) m.display(),
      ],
    );
  }
}
