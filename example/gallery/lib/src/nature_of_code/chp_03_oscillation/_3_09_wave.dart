import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _WaveModel extends f.Model {
  static const int numCircles = 12;
  static const double amplitudeFactor = 0.35;
  static const double startVel = 0.23;
  static const double startAngleDt = 0.015;

  final double startAngle;

  _WaveModel.init({required super.size, required super.inputEvents})
    : startAngle = 0.0;

  _WaveModel.update({
    required super.size,
    required super.inputEvents,
    required this.startAngle,
  });
}

class _WaveIud<M extends _WaveModel> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _WaveModel.update(
            size: size,
            inputEvents: inputEvents,
            startAngle: model.startAngle + _WaveModel.startAngleDt,
          )
          as M;

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Translate(
        dx: 0.0,
        dy: model.size.height * 0.5,
        ops:
            List.generate(
              _WaveModel.numCircles + 1,
              (i) => model.startAngle + i * _WaveModel.startVel,
            ).mapIndexed((i, angle) {
              final x = i * model.size.width / _WaveModel.numCircles;
              final y =
                  _WaveModel.amplitudeFactor *
                  model.size.height *
                  math.sin(angle);
              final r = model.size.width / _WaveModel.numCircles;
              return f.Drawing(
                ops: [
                  f.Circle(
                    center: ui.Offset(x, y),
                    radius: r,
                    paint: ui.Paint()..color = u.transparent5black,
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
                ],
              );
            }).toList(),
      );
}

const String title = 'Wave';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _WaveModel.init,
    iud: _WaveIud<_WaveModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
