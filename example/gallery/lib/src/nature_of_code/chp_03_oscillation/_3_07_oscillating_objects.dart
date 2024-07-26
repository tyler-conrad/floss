import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Oscillator {
  static const double lengthFactor = 0.4;
  static const double circleRadius = 16.0;
  static const double minVel = -0.05;
  static const double maxVel = 0.05;

  final f.Size size;
  final f.Vector2 angle;
  final f.Vector2 velocity;
  final f.Vector2 amplitudeFactors;

  _Oscillator({required this.size})
      : angle = f.Vector2.zero(),
        velocity = f.Vector2(
          u.randDoubleRange(minVel, maxVel),
          u.randDoubleRange(minVel, maxVel),
        ),
        amplitudeFactors = f.Vector2(
          u.randDoubleRange(20.0, size.width),
          u.randDoubleRange(
            20.0,
            size.height,
          ),
        );

  void oscillate() {
    angle.add(velocity);
  }

  f.Drawing draw(f.Size size) {
    final s = u.scale(size);
    final x = s * lengthFactor * amplitudeFactors.x * math.sin(angle.x);
    final y = s * lengthFactor * amplitudeFactors.y * math.sin(angle.y);
    final r = s * circleRadius;

    return f.Drawing(
      canvasOps: [
        f.Circle(
          c: f.Offset(x, y),
          radius: r,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset(x, y),
          radius: r,
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
        canvasOps: model.oscillators
            .map((oscillator) => oscillator.draw(model.size))
            .toList(),
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
