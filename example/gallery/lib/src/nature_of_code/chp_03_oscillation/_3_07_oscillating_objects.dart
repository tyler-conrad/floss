import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Oscillator {
  static const double lengthFactor = 0.4;
  static const double minLength = 20.0;
  static const double circleRadius = 16.0;
  static const double minVel = -0.05;
  static const double maxVel = 0.05;

  final ui.Size size;
  ui.Offset angle;
  final ui.Offset velocity;
  final ui.Offset amplitudeFactors;

  _Oscillator({required this.size})
    : angle = ui.Offset.zero,
      velocity = ui.Offset(
        u.randDoubleRange(minVel, maxVel),
        u.randDoubleRange(minVel, maxVel),
      ),
      amplitudeFactors = ui.Offset(
        u.randDoubleRange(minLength, size.width * lengthFactor),
        u.randDoubleRange(minLength, size.height * lengthFactor),
      );

  void oscillate() {
    angle += velocity;
  }

  f.Drawing draw(ui.Size s) {
    final x = s.width / size.width * amplitudeFactors.dx * math.sin(angle.dx);
    final y = s.height / size.height * amplitudeFactors.dy * math.sin(angle.dy);
    final r = u.scale(size) * circleRadius;

    return f.Drawing(
      ops: [
        f.Circle(
          center: ui.Offset(x, y),
          radius: r,
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Circle(
          center: ui.Offset(x, y),
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = ui.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
        f.Line(
          p1: ui.Offset.zero,
          p2: ui.Offset(x, y),
          paint:
              ui.Paint()
                ..color = u.black
                ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _OscillatingObjectsModel extends f.Model {
  final List<_Oscillator> oscillators;
  _OscillatingObjectsModel.init({
    required super.size,
    required super.inputEvents,
  }) : oscillators = List.generate(10, (_) => _Oscillator(size: size));

  _OscillatingObjectsModel.update({
    required super.size,
    required super.inputEvents,
    required this.oscillators,
  });
}

class _OscillatingObjectsIud<M extends _OscillatingObjectsModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final oscillator in model.oscillators) {
      oscillator.oscillate();
    }
    return _OscillatingObjectsModel.update(
          size: size,
          inputEvents: inputEvents,
          oscillators: model.oscillators,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Translate(
        dx: model.size.width * 0.5,
        dy: model.size.height * 0.5,

        ops:
            model.oscillators
                .map((oscillator) => oscillator.draw(model.size))
                .toList(),
      );
}

const String title = 'Oscillating Objects';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _OscillatingObjectsModel.init,
    iud: _OscillatingObjectsIud<_OscillatingObjectsModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
