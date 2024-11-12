import 'dart:math' as math;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _Mover extends c.Mover {
  static const double gravity = 0.4;
  static const double minMass = 0.1;
  static const double maxMass = 2.0;

  _Mover({
    required super.mass,
    required super.position,
  });

  ui.Offset attract(_Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(5.0, d), 25.0);
    force.normalize();
    return force * (gravity * mass * m.mass) / (d * d);
  }
}

class _MutualAttractionModel extends f.Model {
  static const int numMovers = 500;

  final List<_Mover> movers;

  _MutualAttractionModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => _Mover(
              mass: u.randDoubleRange(_Mover.minMass, _Mover.maxMass),
              position: ui.Offset(
                u.randDoubleRange(0.0, size.width),
                u.randDoubleRange(0.0, size.height),
              )),
        ).toList();

  _MutualAttractionModel.update({
    required super.size,
    required this.movers,
  });
}

class _MutualAttractionIud<M extends _MutualAttractionModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final left in model.movers) {
      for (final right in model.movers) {
        if (left != right) {
          left.applyForce(right.attract(left));
        }
      }
      left.update();
    }

    return _MutualAttractionModel.update(
      size: size,
      movers: model.movers,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
        canvasOps: [
          for (final m in model.movers) m.draw(model.size),
        ],
      );
}

const String title = 'Mutual Attraction';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _MutualAttractionModel.init,
        iud: _MutualAttractionIud<_MutualAttractionModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
