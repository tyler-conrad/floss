import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _PolarToCartesianModel extends f.Model {
  static const rFactor = 0.45;

  final double r;
  final double theta;
  _PolarToCartesianModel.init({required super.size})
      : r = size.height * rFactor,
        theta = 0.0;

  _PolarToCartesianModel.update({
    required super.size,
    required this.r,
    required this.theta,
  });
}

class _PolarToCartesianIur<M extends _PolarToCartesianModel>
    extends f.IurBase<M> implements f.Iur<M> {
  static const double circleRadius = 24.0;

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _PolarToCartesianModel.update(
        size: size,
        r: model.r,
        theta: model.theta + 0.02,
      ) as M;

  @override
  f.Drawing render({
    required M model,
    required bool isLightTheme,
  }) {
    final x = model.r * math.cos(model.theta);
    final y = model.r * math.sin(model.theta);

    return f.Translate(
      translation: f.Vector2(model.size.width * 0.5, model.size.height * 0.5),
      canvasOps: [
        f.Line(
          p1: f.Offset.zero,
          p2: f.Offset(x, y),
          paint: f.Paint()
            ..color = u.black
            ..strokeWidth = 2.0,
        ),
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
            ..paint
            ..style = p.PaintingStyle.stroke,
        ),
      ],
    );
  }
}

const String title = 'Polar To Cartesian';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _PolarToCartesianModel.init,
        iur: _PolarToCartesianIur(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
