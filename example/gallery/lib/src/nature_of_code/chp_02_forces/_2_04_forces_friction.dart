import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _FrictionModel extends f.Model {
  static const int numMovers = 20;

  final List<c.Mover> movers;

  _FrictionModel.init({required super.size, required super.inputEvents})
    : movers =
          List.generate(
            numMovers,
            (_) => c.Mover(
              mass: u.randDoubleRange(c.Mover.massMin, c.Mover.massMax),
              position: ui.Offset(u.randDoubleRange(0.0, size.width), 0.0),
            ),
          ).toList();

  _FrictionModel.update({
    required super.size,
    required super.inputEvents,
    required this.movers,
  });
}

class _FrictionIud<M extends _FrictionModel> extends f.IudBase<M>
    implements f.Iud<M> {
  static const double gFactor = 0.1;
  static const double c = 0.05;

  final wind = ui.Offset(0.01, 0.0);

  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final m in model.movers) {
      final gravity = ui.Offset(0.0, gFactor * m.mass);

      ui.Offset friction = m.velocity;
      if (friction.distance > 0.0) {
        friction *= -1.0;
        friction = friction.norm();
        friction *= c;
        m.applyForce(friction);
      }

      m.applyForce(wind);
      m.applyForce(gravity);
      m.update();
      m.checkEdges(ui.Offset.zero & size);
    }

    return _FrictionModel.update(
          size: size,
          inputEvents: inputEvents,
          movers: model.movers,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(ops: [for (final m in model.movers) m.draw(model.size)]);
}

const String title = 'Forces - Friction';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _FrictionModel.init,
    iud: _FrictionIud<_FrictionModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
