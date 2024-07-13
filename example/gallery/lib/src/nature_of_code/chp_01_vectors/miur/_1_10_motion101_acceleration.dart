import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

class Mover {
  static const size = 24.0;
  static const topSpeed = 5.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  Mover({required f.Vector2 center})
      : position = center,
        velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  Mover.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  Mover update(f.Vector2 mouse) {
    final acc = mouse - position;
    final a = acc.normalized() * 0.2;

    final vel = velocity + a;
    final v = vel.clampLenMax(topSpeed);

    return Mover.update(
      position: position + v,
      velocity: v,
      acceleration: a,
    );
  }

  f.Drawing display() {
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class AccModel extends f.Model {
  final f.Vector2 mouse;
  final Mover mover;

  AccModel.fromCenter({
    required super.size,
    required f.Vector2 center,
  })  : mouse = center,
        mover = Mover(center: center);

  AccModel.init({required f.Size size})
      : this.fromCenter(
          size: size,
          center: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        );

  AccModel.update({
    required super.size,
    required this.mouse,
    required this.mover,
  });
}

class AccIur<M extends AccModel> extends f.IurBase<M> implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2? mousePos;
    for (final ie in inputEvents.list) {
      switch (ie) {
        case f.PointerHover(:final event):
          mousePos = f.Vector2(event.localPosition.dx, event.localPosition.dy);
        default:
          break;
      }
    }
    final mouse = mousePos ?? model.mouse;

    final m = model.mover.update(mouse);

    return AccModel.update(
      size: size,
      mouse: mouse,
      mover: m,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return model.mover.display();
  }
}
