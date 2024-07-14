import 'dart:math' as m;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final _rand = m.Random();

class _Mover {
  static const size = 24.0;
  static const topSpeed = 6.0;
  static const double accXHalfRange = 1.0;
  static const double accYHalfRange = 1.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover()
      : position = f.Vector2.zero(),
        velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  _Mover.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  _Mover update() {
    final acc = f.Vector2(
      _rand.nextDouble() * 2.0 * accXHalfRange - accXHalfRange,
      _rand.nextDouble() * 2.0 * accYHalfRange - accYHalfRange,
    );
    final a = acc * _rand.nextDouble() * 2.0;

    final vel = velocity + a;
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

    return _Mover.update(
      position: position + v,
      velocity: v,
      acceleration: a,
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

class _AccModel extends f.Model {
  final _Mover mover;

  _AccModel.init({required super.size}) : mover = _Mover();

  _AccModel.update({
    required super.size,
    required this.mover,
  });
}

class _AccIur<M extends _AccModel> extends f.IurBase<M> implements f.Iur<M> {
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

    return _AccModel.update(
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

const String title = 'Motion 101: Acceleration 2';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      config: f.Config(
        modelCtor: _AccModel.init,
        iur: _AccIur(),
        clearCanvas: const f.ClearCanvas(),
      ),
      focusNode: focusNode,
    );
