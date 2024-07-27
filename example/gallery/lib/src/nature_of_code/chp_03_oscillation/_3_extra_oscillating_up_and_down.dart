import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _OscillatingUpDownModel extends f.Model {
  static const angularVel = 0.02;
  static const amplitude = 200.0;
  static const radius = 24.0;

  final double angle;

  _OscillatingUpDownModel.init({required super.size}) : angle = 0.0;

  _OscillatingUpDownModel.update({
    required super.size,
    required this.angle,
  });
}

class _OscillatingUpDownIud<M extends _OscillatingUpDownModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    return _OscillatingUpDownModel.update(
      size: size,
      angle: model.angle + _OscillatingUpDownModel.angularVel,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    final r = u.scale(model.size) * _OscillatingUpDownModel.radius;
    final y = u.scale(model.size) *
        _OscillatingUpDownModel.amplitude *
        math.sin(model.angle);
    return f.Translate(
      translation: f.Vector2(model.size.width * 0.5, 0.0),
      canvasOps: [
        f.Line(
          p1: f.Offset.zero,
          p2: f.Offset(0.0, model.size.height * 0.5 + y),
          paint: f.Paint()..color = u.black,
        ),
        f.Translate(
          translation: f.Vector2(0.0, model.size.height * 0.5),
          canvasOps: [
            f.Circle(
              c: f.Offset(0.0, y),
              radius: r,
              paint: f.Paint()..color = u.gray5,
            ),
            f.Circle(
              c: f.Offset(0.0, y),
              radius: r,
              paint: f.Paint()
                ..color = u.black
                ..style = p.PaintingStyle.stroke
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
        iud: _OscillatingUpDownIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
