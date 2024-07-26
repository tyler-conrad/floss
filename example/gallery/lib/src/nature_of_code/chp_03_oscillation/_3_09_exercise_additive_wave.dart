import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _AdditiveWaveModel extends f.Model {
  static const int maxWaves = 5;
  static const int numCircles = 80;
  static const double minAmplitude = 20.0;
  static const double maxAmplitude = 30.0;
  static const double minDxFactor = 100.0;
  static const double maxDxFactor = 300.0;
  static const double circleRadius = 8.0;
  static const double thetaTerm = 0.02;

  final double theta;
  final List<double> amplitude;
  final List<double> dx;
  final List<double> yValues;

  _AdditiveWaveModel.init({required super.size})
      : theta = 0.0,
        amplitude = List.generate(
            maxWaves, (_) => u.randDoubleRange(minAmplitude, maxAmplitude)),
        dx = List.generate(
          maxWaves,
          (_) =>
              2.0 *
              math.pi /
              u.randDoubleRange(minDxFactor, maxDxFactor) *
              (size.width / numCircles),
        ),
        yValues = List.filled(numCircles, 0.0);

  _AdditiveWaveModel.update({
    required super.size,
    required this.theta,
    required this.amplitude,
    required this.dx,
    required this.yValues,
  });
}

class _AdditiveWaveIur<M extends _AdditiveWaveModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final theta = model.theta + _AdditiveWaveModel.thetaTerm;
    model.yValues.fillRange(0, model.yValues.length, 0.0);

    for (var j = 0; j < _AdditiveWaveModel.maxWaves; j++) {
      var x = theta;
      for (var i = 0; i < model.yValues.length; i++) {
        if (j % 2 == 0) {
          model.yValues[i] += math.sin(x) * model.amplitude[j];
        } else {
          model.yValues[i] += math.cos(x) * model.amplitude[j];
        }
        x += model.dx[j];
      }
    }
    return _AdditiveWaveModel.update(
      size: size,
      theta: theta,
      amplitude: model.amplitude,
      dx: model.dx,
      yValues: model.yValues,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Translate(
        translation: f.Vector2(0.0, model.size.height * 0.5),
        canvasOps: model.yValues
            .mapIndexed(
              (x, y) => f.Circle(
                c: f.Offset(
                  x.toDouble() *
                      (model.size.width / _AdditiveWaveModel.numCircles),
                  y,
                ),
                radius: _AdditiveWaveModel.circleRadius,
                paint: f.Paint()
                  ..color = const p.HSLColor.fromAHSL(
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

const String title = 'Additive Wave';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AdditiveWaveModel.init,
        iur: _AdditiveWaveIur(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
