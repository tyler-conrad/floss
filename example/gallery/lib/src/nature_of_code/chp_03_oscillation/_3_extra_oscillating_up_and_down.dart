import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _OscillatingUpDownModel extends f.Model {
  static const angularVel = 0.02;
  static const amplitude = 200.0;
  static const radius = 24.0;

  final double angle;

  _OscillatingUpDownModel.init({
    required super.size,
    required super.inputEvents,
  }) : angle = 0.0;

  _OscillatingUpDownModel.update({
    required super.size,
    required super.inputEvents,
    required this.angle,
  });
}

class _OscillatingUpDownIud<M extends _OscillatingUpDownModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    return _OscillatingUpDownModel.update(
          size: size,
          inputEvents: inputEvents,
          angle: model.angle + _OscillatingUpDownModel.angularVel,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    final r = u.scale(model.size) * _OscillatingUpDownModel.radius;
    final y =
        u.scale(model.size) *
        _OscillatingUpDownModel.amplitude *
        math.sin(model.angle);
    return f.Translate(
      dx: model.size.width * 0.5,
      dy: 0.0,
      ops: [
        f.Line(
          p1: ui.Offset.zero,
          p2: ui.Offset(0.0, model.size.height * 0.5 + y),
          paint: ui.Paint()..color = u.black,
        ),
        f.Translate(
          dx: 0.0,
          dy: model.size.height * 0.5,
          ops: [
            f.Circle(
              center: ui.Offset(0.0, y),
              radius: r,
              paint: ui.Paint()..color = u.gray5,
            ),
            f.Circle(
              center: ui.Offset(0.0, y),
              radius: r,
              paint:
                  ui.Paint()
                    ..color = u.black
                    ..style = ui.PaintingStyle.stroke
                    ..strokeWidth = 2.0,
            ),
          ],
        ),
      ],
    );
  }
}

const String title = 'Oscillating Up Down';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _OscillatingUpDownModel.init,
    iud: _OscillatingUpDownIud<_OscillatingUpDownModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
