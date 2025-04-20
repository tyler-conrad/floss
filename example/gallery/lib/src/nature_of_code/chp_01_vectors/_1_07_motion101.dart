import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const double radius = 24.0;
  static const double velXHalfRange = 4.0;
  static const double velYHalfRange = 4.0;

  ui.Offset position;
  ui.Offset velocity;

  _Mover({required ui.Rect rect})
    : position = ui.Offset(
        u.randDoubleRange(rect.left, rect.right),
        u.randDoubleRange(rect.top, rect.bottom),
      ),
      velocity = ui.Offset(
        u.randDoubleRange(-velXHalfRange, velXHalfRange),
        u.randDoubleRange(-velYHalfRange, velYHalfRange),
      );

  void update() {
    position = position + velocity;
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
                ..style = ui.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

class _MotionModel extends f.Model {
  final _Mover mover;

  _MotionModel.init({required super.size, required super.inputEvents})
    : mover = _Mover(rect: ui.Rect.fromLTWH(0.0, 0.0, size.width, size.height));

  _MotionModel.update({
    required super.size,
    required super.inputEvents,
    required this.mover,
  });
}

class _MotionIud<M extends _MotionModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.mover.update();
    model.mover.checkEdges(ui.Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    return _MotionModel.update(
          size: size,
          inputEvents: inputEvents,
          mover: model.mover,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.mover.draw(model.size);
}

const String title = 'Motion 101';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _MotionModel.init,
    iud: _MotionIud<_MotionModel>(),
    clearCanvas: f.NoClearCanvas(
      paint:
          ui.Paint()
            ..color = u.transparentWhite
            ..blendMode = ui.BlendMode.srcOver,
    ),
  ),
);
