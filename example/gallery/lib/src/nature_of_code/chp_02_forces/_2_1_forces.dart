import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final f.Vector2 moverInitAcc = f.Vector2(-0.001, 0.01);

class _Mover {
  static const double size = 24.0;
  static const double mass = 1.0;
  static const double initPosOffset = 60.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover({required f.Rect rect})
      : position = f.Vector2(
          rect.left + initPosOffset,
          rect.top + initPosOffset,
        ),
        velocity = f.Vector2.zero(),
        acceleration = moverInitAcc;

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

class _ForcesModel extends f.Model {
  final _Mover mover;

  _ForcesModel.init({required super.size})
      : mover = _Mover(
          rect: f.Rect.fromOffsetSize(
            f.Offset.zero,
            size,
          ),
        );

  _ForcesModel.update({
    required super.size,
    required this.mover,
  });
}

class _ForcesIur<M extends _ForcesModel> extends f.IurBase<M>
    implements f.Iur<M> {
  final f.Vector2 wind = f.Vector2(0.01, 0.0);
  final f.Vector2 gravity = f.Vector2(0.0, 0.1);

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.mover.applyForce(wind);
    model.mover.applyForce(gravity);
    model.mover.update();
    model.mover.checkEdges(
      f.Rect.fromOffsetSize(
        f.Offset(0.0, 0.0),
        size,
      ),
    );

    return _ForcesModel.update(
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

const String title = 'Forces';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      config: f.Config(
        modelCtor: _ForcesModel.init,
        iur: _ForcesIur(),
        clearCanvas: const f.ClearCanvas(),
      ),
      focusNode: focusNode,
    );
