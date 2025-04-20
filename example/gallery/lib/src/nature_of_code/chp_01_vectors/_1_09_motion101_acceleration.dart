import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const double radius = 24.0;
  static const double topSpeed = 6.0;
  static const double accXRange = 1.0;
  static const double accYRange = 1.0;

  ui.Offset position;
  final ui.Offset velocity;
  final ui.Offset acceleration;

  _Mover()
    : position = ui.Offset.zero,
      velocity = ui.Offset.zero,
      acceleration = ui.Offset.zero;

  _Mover.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  _Mover update() {
    final acc = ui.Offset(
      u.randDoubleRange(-accXRange, accXRange),
      u.randDoubleRange(-accYRange, accYRange),
    );
    final a = acc * u.randDoubleRange(0.0, 2.0);

    final vel = velocity + a;
    final v = ui.Offset(
      math.max(math.min(vel.dx, topSpeed), -topSpeed),
      math.max(math.min(vel.dy, topSpeed), -topSpeed),
    );

    return _Mover.update(position: position + v, velocity: v, acceleration: a);
  }

  void checkEdges(ui.Rect rect) {
    if (position.dx > rect.right) {
      position = ui.Offset(rect.left, position.dy);
    } else if (position.dx < rect.left) {
      position = ui.Offset(rect.right, position.dy);
    }

    if (position.dy < rect.top) {
      position = ui.Offset(position.dx, rect.bottom);
    } else if (position.dy > rect.bottom) {
      position = ui.Offset(position.dx, rect.top);
    }
  }

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * radius;

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = ui.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _AccModel extends f.Model {
  final _Mover mover;

  _AccModel.init({required super.size, required super.inputEvents})
    : mover = _Mover();

  _AccModel.update({
    required super.size,
    required super.inputEvents,
    required this.mover,
  });
}

class _AccIud<M extends _AccModel> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    final m = model.mover.update();
    m.checkEdges(ui.Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    return _AccModel.update(size: size, inputEvents: inputEvents, mover: m)
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.mover.draw(model.size);
}

const String title = 'Motion 101: Acceleration 2';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _AccModel.init,
    iud: _AccIud<_AccModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
