import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _MultipleOscillationsModel extends f.Model {
  static const radius = 24.0;
  static const angularVel1 = 0.01;
  static const amplitude1 = 600.0;
  static const angularVel2 = 0.3;
  static const amplitude2 = 10.0;

  final double angle1;
  final double angle2;

  _MultipleOscillationsModel.init({
    required super.size,
    required super.inputEvents,
  }) : angle1 = 0.0,
       angle2 = 0.0;

  _MultipleOscillationsModel.update({
    required super.size,
    required super.inputEvents,
    required this.angle1,
    required this.angle2,
  });
}

class _MultipleOscillationsIud<M extends _MultipleOscillationsModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    return _MultipleOscillationsModel.update(
          size: size,
          inputEvents: inputEvents,
          angle1: model.angle1 + _MultipleOscillationsModel.angularVel1,
          angle2: model.angle2 + _MultipleOscillationsModel.angularVel2,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    final r = u.scale(model.size) * _MultipleOscillationsModel.radius;
    final x =
        u.scale(model.size) *
            _MultipleOscillationsModel.amplitude1 *
            math.cos(model.angle1) +
        _MultipleOscillationsModel.amplitude2 * math.sin(model.angle2);

    return f.Translate(
      dx: model.size.width * 0.5,
      dy: model.size.height * 0.5,

      ops: [
        f.Line(
          p1: ui.Offset.zero,
          p2: ui.Offset(x, 0.0),
          paint: ui.Paint()..color = u.black,
        ),
        f.Circle(
          center: ui.Offset(x, 0.0),
          radius: r,
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Circle(
          center: ui.Offset(x, 0.0),
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = ui.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

const String title = 'Multiple Oscillations';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _MultipleOscillationsModel.init,
    iud: _MultipleOscillationsIud<_MultipleOscillationsModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
