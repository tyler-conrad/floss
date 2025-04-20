import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _VecMultModel extends f.Model {
  final ui.Offset? mouse;

  _VecMultModel.init({required super.size, required super.inputEvents})
    : mouse = null;

  _VecMultModel.update({
    required super.size,
    required super.inputEvents,
    required this.mouse,
  });
}

class _VecMultIud<M extends _VecMultModel> extends f.IudBase<M>
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
          mouse = ui.Offset(event.localPosition.dx, event.localPosition.dy);
        default:
          break;
      }
    }

    return _VecMultModel.update(
          size: size,
          inputEvents: inputEvents,
          mouse: mouse ?? model.mouse,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    final center = ui.Offset(model.size.width * 0.5, model.size.height * 0.5);
    final mouse =
        (model.mouse == null ? ui.Offset.zero : model.mouse! - center) * 0.5;

    return f.Translate(
      dx: center.dx,
      dy: center.dy,
      ops: [
        f.Line(
          p1: ui.Offset.zero,
          p2: mouse,
          paint:
              ui.Paint()
                ..color = u.black
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

const String title = 'Vector Multiplication';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _VecMultModel.init,
    iud: _VecMultIud<_VecMultModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
