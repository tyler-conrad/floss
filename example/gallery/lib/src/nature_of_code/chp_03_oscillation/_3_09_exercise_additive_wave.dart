import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _AdditiveWaveModel extends f.Model {
  static const int maxWaves = 5;
  static const int numCircles = 160;
  static const double minAmplitude = 20.0;
  static const double maxAmplitude = 30.0;
  static const double minPeriod = 100.0;
  static const double maxPeriod = 300.0;
  static const double radius = 12.0;
  static const double angularVel = 0.02;

  final double theta;
  final List<double> amplitudeFactors;
  final List<double> dx;
  final List<double> yValues;

  _AdditiveWaveModel.init({required super.size, required super.inputEvents})
    : theta = 0.0,
      amplitudeFactors = List.generate(
        maxWaves,
        (_) => u.randDoubleRange(minAmplitude, maxAmplitude),
      ),
      dx = List.generate(
        maxWaves,
        (_) =>
            2.0 *
            math.pi /
            u.randDoubleRange(minPeriod, maxPeriod) *
            size.width /
            numCircles,
      ),
      yValues = List.filled(numCircles, 0.0);

  _AdditiveWaveModel.update({
    required super.size,
    required super.inputEvents,
    required this.theta,
    required this.amplitudeFactors,
    required this.dx,
    required this.yValues,
  });
}

class _AdditiveWaveIud<M extends _AdditiveWaveModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    final s = u.scale(size);
    final theta = model.theta + _AdditiveWaveModel.angularVel;
    model.yValues.fillRange(0, model.yValues.length, 0.0);

    for (var j = 0; j < _AdditiveWaveModel.maxWaves; j++) {
      var x = theta;
      for (var i = 0; i < model.yValues.length; i++) {
        if (j % 2 == 0) {
          model.yValues[i] += s * math.sin(x) * model.amplitudeFactors[j];
        } else {
          model.yValues[i] += s * math.cos(x) * model.amplitudeFactors[j];
        }
        x += model.dx[j];
      }
    }
    return _AdditiveWaveModel.update(
          size: size,
          inputEvents: inputEvents,
          theta: theta,
          amplitudeFactors: model.amplitudeFactors,
          dx: model.dx,
          yValues: model.yValues,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Translate(
        dx: 0.0,
        dy: model.size.height * 0.5,
        ops:
            model.yValues
                .mapIndexed(
                  (x, y) => f.Circle(
                    center: ui.Offset(
                      x.toDouble() *
                          model.size.width /
                          _AdditiveWaveModel.numCircles,
                      y,
                    ),
                    radius: u.scale(model.size) * _AdditiveWaveModel.radius,
                    paint:
                        ui.Paint()
                          ..color =
                              const p.HSLColor.fromAHSL(
                                0.25,
                                0.0,
                                0.0,
                                0.0,
                              ).toColor(),
                  ),
                )
                .toList(),
      );
}

const String title = 'Additive Wave 1';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _AdditiveWaveModel.init,
    iud: _AdditiveWaveIud<_AdditiveWaveModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
