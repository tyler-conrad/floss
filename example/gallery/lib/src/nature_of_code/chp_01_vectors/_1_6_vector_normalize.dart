import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _VecNormModel extends f.Model {
  final f.Vector2? mouse;

  _VecNormModel.init({required super.size}) : mouse = null;

  _VecNormModel.update({
    required super.size,
    required this.mouse,
  });
}

class _VecNormIud<M extends _VecNormModel> extends f.IudBase<M>
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

    return _VecNormModel.update(
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
        (model.mouse == null ? f.Vector2.zero() : model.mouse! - center)
                .normalized() *
            150.0;

    return f.Translate(
      translation: center,
      canvasOps: [
        f.Line(
          p1: f.Offset.zero,
          p2: mouse.toOffset,
          paint: f.Paint()
            ..color = u.black
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

const String title = 'Vector Normalize';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _VecNormModel.init,
        iud: _VecNormIud<_VecNormModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
