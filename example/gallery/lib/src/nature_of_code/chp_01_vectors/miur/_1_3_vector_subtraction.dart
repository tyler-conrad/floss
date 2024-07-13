import 'package:flutter/painting.dart' as p;

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

class VecSubModel extends f.Model {
  final f.Vector2? mouse;

  VecSubModel.init({required super.size}) : mouse = null;
  VecSubModel.update({
    required super.size,
    required this.mouse,
  });
}

class VecSubIur<M extends VecSubModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2? mouse;
    for (final ie in inputEvents.list) {
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

    return VecSubModel.update(
      size: size,
      mouse: mouse ?? model.mouse,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
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
