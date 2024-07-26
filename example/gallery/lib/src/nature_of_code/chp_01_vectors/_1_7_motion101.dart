import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const radius = 24.0;
  static const double velXHalfRange = 2.0;
  static const double velYHalfRange = 2.0;

  final f.Vector2 position;
  final f.Vector2 velocity;

  _Mover({required f.Rect rect})
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
          u.randDoubleRange(-velXHalfRange, velXHalfRange),
          u.randDoubleRange(-velYHalfRange, velYHalfRange),
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

  f.Drawing display() => f.Translate(
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
              ..style = p.PaintingStyle.stroke,
          ),
        ],
      );
}

class _MotionModel extends f.Model {
  final _Mover mover;

  _MotionModel.init({required super.size})
      : mover = _Mover(
          rect: f.Rect.fromOffsetSize(
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
      model.mover.display();
}

const String title = 'Motion 101';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _MotionModel.init,
        iud: _MotionIud(),
        clearCanvas: f.NoClearCanvas(
          paint: f.Paint()
            ..color = u.transparentWhite
            ..blendMode = p.BlendMode.srcOver,
        ),
      ),
    );
