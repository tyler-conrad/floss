import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _PolarToCartesianModel extends f.Model {
  static const double circleRadius = 24.0;
  static const double radiusFactor = 0.4;
  static const double angularVel = 0.02;

  final double radius;
  final double theta;

  _PolarToCartesianModel.init({required super.size})
      : radius = radiusFactor * size.height,
        theta = 0.0;

  _PolarToCartesianModel.update({
    required super.size,
    required this.radius,
    required this.theta,
  });
}

class _PolarToCartesianIud<M extends _PolarToCartesianModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) =>
      _PolarToCartesianModel.update(
        size: size,
        radius: _PolarToCartesianModel.radiusFactor * size.height,
        theta: model.theta + _PolarToCartesianModel.angularVel,
      ) as M;

  @override
  f.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) {
    final x = model.radius * math.cos(model.theta);
    final y = model.radius * math.sin(model.theta);
    final r = u.scale(model.size) * _PolarToCartesianModel.circleRadius;

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
          radius: r,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset(x, y),
          radius: r,
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
        iud: _PolarToCartesianIud<_PolarToCartesianModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
