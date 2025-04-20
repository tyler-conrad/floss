import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _NoFrictionModel extends f.Model {
  static const int numMovers = 20;

  final List<c.Mover> movers;

  _NoFrictionModel.init({required super.size, required super.inputEvents})
    : movers =
          List.generate(
            numMovers,
            (_) => c.Mover(
              mass: u.randDoubleRange(c.Mover.massMin, c.Mover.massMax),
              position: ui.Offset(u.randDoubleRange(0.0, size.width), 0.0),
            ),
          ).toList();

  _NoFrictionModel.update({
    required super.size,
    required super.inputEvents,
    required this.movers,
  });
}

class _NoFrictionIud<M extends _NoFrictionModel> extends f.IudBase<M>
    implements f.Iud<M> {
  static const double gFactor = 0.1;

  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    final wind = ui.Offset(0.01, 0.0);
    for (final m in model.movers) {
      m.applyForce(wind);
      final gravity = ui.Offset(0.0, gFactor * m.mass);
      m.applyForce(gravity);
      m.update();
      m.checkEdges(ui.Offset.zero & size);
    }

    return _NoFrictionModel.update(
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

const String title = 'Forces - No Friction';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _NoFrictionModel.init,
    iud: _NoFrictionIud<_NoFrictionModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
