import 'dart:math' as m;

import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

class Mover {
  static const size = 24.0;
  static const topSpeed = 10.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  Mover()
      : position = f.Vector2.zero(),
        velocity = f.Vector2.zero(),
        acceleration = f.Vector2(-0.001, 0.01);

  Mover.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  Mover update() {
    final vel = velocity + acceleration;
    final v = f.Vector2(
      m.min(
        vel.x,
        topSpeed,
      ),
      m.min(
        vel.y,
        topSpeed,
      ),
    );

    return Mover.update(
      position: position + v,
      velocity: v,
      acceleration: acceleration,
    );
  }

  void checkEdges(f.Rect rect) {
    if (position.x > rect.right) {
      position.x = rect.left;
    } else if (position.x < rect.left) {
      position.x = rect.right;
    }

    if (position.y < rect.top) {
      position.y = rect.bottom;
    } else if (position.y > rect.bottom) {
      position.y = rect.top;
    }
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
  final Mover mover;

  AccModel.init({required super.size}) : mover = Mover();

  AccModel.update({
    required super.size,
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
    final m = model.mover.update();
    m.checkEdges(
      f.Rect.fromOffsetSize(
        f.Offset(0.0, 0.0),
        size,
      ),
    );

    return AccModel.update(
      size: size,
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
