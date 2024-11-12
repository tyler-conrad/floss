import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _VecMagModel extends f.Model {
  final ui.Offset? mouse;

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
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    ui.Offset? mouse;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerHover(:final event):
          mouse = ui.Offset(
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
    final center = ui.Offset(
      model.size.width * 0.5,
      model.size.height * 0.5,
    );
    final mouse =
        model.mouse == null ? ui.Offset.zero() : model.mouse! - center;

    return f.Translate(
      translation: center,
      canvasOps: [
        f.Rectangle(
            rect: ui.Rect.fromOffsetSize(
              f.Offset.fromVec(-center),
              ui.Size(
                mouse.length,
                10.0,
              ),
            ),
            paint: ui.Paint()..color = u.black),
        f.Line(
          p1: ui.Offset.zero,
          p2: mouse.toOffset,
          paint: ui.Paint()
            ..color = u.black
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
        iud: _VecMagIud<_VecMagModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
