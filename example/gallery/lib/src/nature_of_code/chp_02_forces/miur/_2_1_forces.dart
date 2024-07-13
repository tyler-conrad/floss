import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

const initPosOffset = 60.0;

class Mover  {
  static const size = 24.0;
  static const mass = 1.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  Mover({required f.Rect rect})
      : position = f.Vector2(
          rect.left + initPosOffset,
          rect.top + initPosOffset,
        ),
        velocity = f.Vector2.zero(),
        acceleration = f.Vector2(-0.001, 0.01);

  void applyForce(f.Vector2 force) {
    final f = force / mass;
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  void checkEdges(f.Rect rect) {
    if (position.x > rect.right) {
      position.x = rect.right;
      velocity.x *= -1.0;
    } else if (position.x < rect.left) {
      position.x = rect.left;
      velocity.x *= -1.0;
    }

    if (position.y > rect.bottom) {
      position.y = rect.bottom;
      velocity.y *= -1.0;
    }
  }

  f.Drawing display() {
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()
            ..color = u.gray5,
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

class ForcesModel extends f.Model {
  final Mover mover;

  ForcesModel.init({required super.size})
      : mover = Mover(
          rect: f.Rect.fromOffsetSize(
            f.Offset.zero,
            size,
          ),
        );

  ForcesModel.update({
    required super.size,
    required this.mover,
  });
}

class ForcesIur<M extends ForcesModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final wind = f.Vector2(0.01, 0.0);
    final gravity = f.Vector2(0.0, 0.1);

    model.mover.applyForce(wind);
    model.mover.applyForce(gravity);
    model.mover.update();
    model.mover.checkEdges(
      f.Rect.fromOffsetSize(
        f.Offset(0.0, 0.0),
        size,
      ),
    );

    return ForcesModel.update(
      size: size,
      mover: model.mover,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return model.mover.display();
  }
}
