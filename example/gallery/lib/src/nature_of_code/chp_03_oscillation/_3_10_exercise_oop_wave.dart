import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart' show IterableExtension;

import 'package:floss/floss.dart' as f;

class _Wave {
  static const double dt = 0.02;

  final int numCircles;
  final f.Vector2 originFactor;
  final double theta;
  final double widthFactor;
  final double period;
  final double amplitude;
  //final double dx;
  final List<double> yValues;

  _Wave.init({
    required this.numCircles,
    required this.originFactor,
    required this.widthFactor,
    required this.period,
    required this.amplitude,
  })  : theta = 0.0,
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

  _Wave calculate(f.Size size) => _Wave.update(
        numCircles: numCircles,
        originFactor: originFactor,
        theta: theta + dt,
        widthFactor: widthFactor,
        period: period,
        amplitude: amplitude,
        yValues: yValues
            .mapIndexed((x, _) =>
                math.sin(x *
                        2.0 *
                        math.pi /
                        period *
                        widthFactor *
                        size.width /
                        numCircles +
                    theta) *
                amplitude)
            .toList(),
      );

  f.Drawing display(f.Size size) => f.Translate(
        translation: f.Vector2(
          size.width * originFactor.x,
          size.height * originFactor.y,
        ),
        canvasOps: List.generate(
          numCircles,
          (i) {
            final x = i * size.width * widthFactor / numCircles;
            final y = yValues[i];
            final radius = widthFactor * size.width / numCircles * 2.0;
            return f.Circle(
              c: f.Offset(x, y),
              radius: radius,
              paint: f.Paint()
                ..color = const p.HSLColor.fromAHSL(
                  0.2,
                  0.0,
                  0.0,
                  0.0,
                ).toColor(),
            );
          },
        ),
      );
}

class _OopWaveModel extends f.Model {
  final _Wave waveOne;
  final _Wave waveTwo;

  _OopWaveModel.init({required super.size})
      : waveOne = _Wave.init(
          numCircles: 9,
          originFactor: f.Vector2(0.1, 0.4),
          widthFactor: 0.3,
          period: 500.0,
          amplitude: 20.0,
        ),
        waveTwo = _Wave.init(
          numCircles: 25,
          originFactor: f.Vector2(0.5, 0.5),
          widthFactor: 0.4,
          period: 220.0,
          amplitude: 40.0,
        );

  _OopWaveModel.update({
    required super.size,
    required this.waveOne,
    required this.waveTwo,
  });
}

class _OopWaveIud<M extends _OopWaveModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _OopWaveModel.update(
        size: size,
        waveOne: model.waveOne.calculate(size),
        waveTwo: model.waveTwo.calculate(size),
      ) as M;

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
        canvasOps: [
          model.waveOne.display(model.size),
          model.waveTwo.display(model.size),
        ],
      );
}

const String title = 'OOP Wave';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _OopWaveModel.init,
        iud: _OopWaveIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
