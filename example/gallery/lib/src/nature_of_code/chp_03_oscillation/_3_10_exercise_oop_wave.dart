import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Wave {
  static const double radius = 2.0;
  static const double angularVel = 0.02;

  final int numCircles;
  final ui.Offset originFactor;
  final double theta;
  final double widthFactor;
  final double period;
  final double amplitude;
  final List<double> yValues;

  _Wave.init({
    required this.numCircles,
    required this.originFactor,
    required this.widthFactor,
    required this.period,
    required this.amplitude,
  }) : theta = 0.0,
       yValues = List.filled(numCircles, 0.0);

  _Wave.update({
    required this.numCircles,
    required this.originFactor,
    required this.theta,
    required this.widthFactor,
    required this.period,
    required this.amplitude,
    required this.yValues,
  });

  _Wave calculate(ui.Size size) => _Wave.update(
    numCircles: numCircles,
    originFactor: originFactor,
    theta: theta + angularVel,
    widthFactor: widthFactor,
    period: period,
    amplitude: amplitude,
    yValues:
        yValues
            .mapIndexed(
              (x, _) =>
                  amplitude *
                  math.sin(
                    x *
                            2.0 *
                            math.pi /
                            period *
                            widthFactor *
                            size.width /
                            numCircles +
                        theta,
                  ),
            )
            .toList(),
  );

  f.Drawing draw(ui.Size size) => f.Translate(
    dx: size.width * originFactor.dx,
    dy: size.height * originFactor.dy,

    ops: List.generate(numCircles, (i) {
      final x = i * size.width * widthFactor / numCircles;
      final y = u.scale(size) * yValues[i];
      final r = u.scale(size) * radius * widthFactor * size.width / numCircles;
      return f.Circle(
        center: ui.Offset(x, y),
        radius: r,
        paint:
            ui.Paint()
              ..color = const p.HSLColor.fromAHSL(0.2, 0.0, 0.0, 0.0).toColor(),
      );
    }),
  );
}

class _OopWaveModel extends f.Model {
  final _Wave waveOne;
  final _Wave waveTwo;

  _OopWaveModel.init({required super.size, required super.inputEvents})
    : waveOne = _Wave.init(
        numCircles: 15,
        originFactor: ui.Offset(0.1, 0.4),
        widthFactor: 0.3,
        period: 400.0,
        amplitude: 30.0,
      ),
      waveTwo = _Wave.init(
        numCircles: 40,
        originFactor: ui.Offset(0.5, 0.5),
        widthFactor: 0.4,
        period: 600.0,
        amplitude: 70.0,
      );

  _OopWaveModel.update({
    required super.size,
    required super.inputEvents,
    required this.waveOne,
    required this.waveTwo,
  });
}

class _OopWaveIud<M extends _OopWaveModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _OopWaveModel.update(
            size: size,
            inputEvents: inputEvents,
            waveOne: model.waveOne.calculate(size),
            waveTwo: model.waveTwo.calculate(size),
          )
          as M;

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(
        ops: [model.waveOne.draw(model.size), model.waveTwo.draw(model.size)],
      );
}

const String title = 'OOP Wave';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _OopWaveModel.init,
    iud: _OopWaveIud<_OopWaveModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
