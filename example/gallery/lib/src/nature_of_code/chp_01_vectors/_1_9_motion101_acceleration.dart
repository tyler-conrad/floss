import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const double radius = 24.0;
  static const double topSpeed = 6.0;
  static const double accXRange = 1.0;
  static const double accYRange = 1.0;

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
      u.randDoubleRange(-accXRange, accXRange),
      u.randDoubleRange(-accYRange, accYRange),
    );
    final a = acc * u.randDoubleRange(0.0, 2.0);

    final vel = velocity + a;
    final v = f.Vector2(
      math.min(
        vel.x,
        topSpeed,
      ),
      math.min(
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

  f.Drawing draw() => f.Translate(
        translation: position,
        canvasOps: [
          f.Circle(
            c: f.Offset.zero,
            radius: radius,
            paint: f.Paint()..color = u.gray5,
          ),
          f.Circle(
            c: f.Offset.zero,
            radius: radius,
            paint: f.Paint()
              ..color = u.black
              ..style = p.PaintingStyle.stroke
              ..strokeWidth = 2.0,
          ),
        ],
      );
}

class _AccModel extends f.Model {
  final _Mover mover;

  _AccModel.init({required super.size}) : mover = _Mover();

  _AccModel.update({
    required super.size,
    required this.mover,
  });
}

class _AccIud<M extends _AccModel> extends f.IudBase<M> implements f.Iud<M> {
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
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      model.mover.draw();
}

const String title = 'Motion 101: Acceleration 2';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AccModel.init,
        iud: _AccIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
