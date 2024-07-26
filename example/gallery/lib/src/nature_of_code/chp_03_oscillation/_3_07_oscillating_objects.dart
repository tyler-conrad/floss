import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Oscillator {
  static const double lengthFactor = 0.4;
  static const double circleRadius = 16.0;

  final f.Size size;
  final f.Vector2 angle;
  final f.Vector2 velocity;
  final f.Vector2 amplitude;

  _Oscillator({required this.size})
      : angle = f.Vector2.zero(),
        velocity = f.Vector2(
            u.randDoubleRange(-0.05, 0.05), u.randDoubleRange(-0.05, 0.05)),
        amplitude = f.Vector2(
            u.randDoubleRange(20.0, lengthFactor * size.width),
            u.randDoubleRange(20.0, lengthFactor * size.height));

  void oscillate() {
    angle.add(velocity);
  }

  f.Drawing draw() {
    final x = amplitude.x * math.sin(angle.x);
    final y = amplitude.y * math.sin(angle.y);

    return f.Drawing(
      canvasOps: [
        f.Circle(
          c: f.Offset(x, y),
          radius: circleRadius,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset(x, y),
          radius: circleRadius,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
        f.Line(
          p1: f.Offset.zero,
          p2: f.Offset(x, y),
          paint: f.Paint()
            ..color = u.black
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _OscillatingObjectsModel extends f.Model {
  final List<_Oscillator> oscillators;
  _OscillatingObjectsModel.init({required super.size})
      : oscillators = List.generate(10, (_) => _Oscillator(size: size));

  _OscillatingObjectsModel.update({
    required super.size,
    required this.oscillators,
  });
}

class _OscillatingObjectsIud<M extends _OscillatingObjectsModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final oscillator in model.oscillators) {
      oscillator.oscillate();
    }
    return _OscillatingObjectsModel.update(
      size: size,
      oscillators: model.oscillators,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Translate(
        translation: f.Vector2(model.size.width * 0.5, model.size.height * 0.5),
        canvasOps:
            model.oscillators.map((oscillator) => oscillator.draw()).toList(),
      );
}

const String title = 'Oscillating Objects';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _OscillatingObjectsModel.init,
        iud: _OscillatingObjectsIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
