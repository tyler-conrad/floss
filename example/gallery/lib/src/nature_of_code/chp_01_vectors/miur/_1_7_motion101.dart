import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

class Mover {
  static const size = 24.0;

  final f.Vector2 position;
  final f.Vector2 velocity;

  Mover({required f.Rect rect})
      : position = f.Vector2(
          u.randDoubleRange(
            rect.left,
            rect.right,
          ),
          u.randDoubleRange(
            rect.top,
            rect.bottom,
          ),
        ),
        velocity = f.Vector2(
          u.randDoubleRange(-2.0, 2.0),
          u.randDoubleRange(-2.0, 2.0),
        );

  void update() {
    position.add(velocity);
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
            ..style = p.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

class MotionModel extends f.Model {
  final Mover mover;

  MotionModel.init({required super.size})
      : mover = Mover(
          rect: f.Rect.fromOffsetSize(
            f.Offset(0.0, 0.0),
            size,
          ),
        );

  MotionModel.update({
    required super.size,
    required this.mover,
  });
}

class MotionIur<M extends MotionModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.mover.update();
    model.mover.checkEdges(
      f.Rect.fromOffsetSize(
        f.Offset(0.0, 0.0),
        size,
      ),
    );

    return MotionModel.update(
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
