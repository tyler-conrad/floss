import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const double radius = 24.0;
  static const double velXHalfRange = 4.0;
  static const double velYHalfRange = 4.0;

  final ui.Offset position;
  final ui.Offset velocity;

  _Mover({required ui.Rect rect})
      : position = ui.Offset(
          u.randDoubleRange(
            rect.left,
            rect.right,
          ),
          u.randDoubleRange(
            rect.top,
            rect.bottom,
          ),
        ),
        velocity = ui.Offset(
          u.randDoubleRange(-velXHalfRange, velXHalfRange),
          u.randDoubleRange(-velYHalfRange, velYHalfRange),
        );

  void update() {
    position.add(velocity);
  }

  void checkEdges(ui.Rect rect) {
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

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * radius;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

class _MotionModel extends f.Model {
  final _Mover mover;

  _MotionModel.init({required super.size})
      : mover = _Mover(
          rect: ui.Rect.fromOffsetSize(
            f.Offset(0.0, 0.0),
            size,
          ),
        );

  _MotionModel.update({
    required super.size,
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
    model.mover.checkEdges(
      ui.Rect.fromOffsetSize(
        f.Offset(0.0, 0.0),
        size,
      ),
    );

    return _MotionModel.update(
      size: size,
      mover: model.mover,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      model.mover.draw(model.size);
}

const String title = 'Motion 101';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _MotionModel.init,
        iud: _MotionIud<_MotionModel>(),
        clearCanvas: f.NoClearCanvas(
          paint: ui.Paint()
            ..color = u.transparentWhite
            ..blendMode = p.BlendMode.srcOver,
        ),
      ),
    );
