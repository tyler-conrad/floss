import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _VecMagModel extends f.Model {
  final f.Vector2? mouse;

  _VecMagModel.init({required super.size}) : mouse = null;

  _VecMagModel.update({
    required super.size,
    required this.mouse,
  });
}

class _VecMagIud<M extends _VecMagModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2? mouse;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerHover(:final event):
          mouse = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
        default:
          break;
      }
    }

    return _VecMagModel.update(
      size: size,
      mouse: mouse ?? model.mouse,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    final center = f.Vector2(
      model.size.width * 0.5,
      model.size.height * 0.5,
    );
    final mouse =
        model.mouse == null ? f.Vector2.zero() : model.mouse! - center;

    return f.Translate(
      translation: center,
      canvasOps: [
        f.Rectangle(
            rect: f.Rect.fromOffsetSize(
              f.Offset.fromVec(-center),
              f.Size(
                mouse.length,
                10.0,
              ),
            ),
            paint: f.Paint()..color = u.black),
        f.Line(
          p1: f.Offset.zero,
          p2: f.Offset.fromVec(mouse),
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

const String title = 'Vector Magnitude';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _VecMagModel.init,
        iud: _VecMagIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
