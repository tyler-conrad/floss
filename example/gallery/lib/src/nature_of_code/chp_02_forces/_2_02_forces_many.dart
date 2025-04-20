import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _ForcesManyModel extends f.Model {
  static const int numMovers = 20;

  final List<c.Mover> movers;

  _ForcesManyModel.init({required super.size, required super.inputEvents})
    : movers =
          List.generate(
            numMovers,
            (_) => c.Mover(
              mass: u.randDoubleRange(0.1, 4.0),
              position: ui.Offset.zero,
            ),
          ).toList();

  _ForcesManyModel.update({
    required super.size,
    required super.inputEvents,
    required this.movers,
  });
}

class _ForcesManyIud<M extends _ForcesManyModel> extends f.IudBase<M>
    implements f.Iud<M> {
  final wind = ui.Offset(0.01, 0.0);
  final gravity = ui.Offset(0.0, 0.1);

  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final m in model.movers) {
      m.applyForce(wind);
      m.applyForce(gravity);
      m.update();
      m.checkEdges(ui.Offset.zero & size);
    }

    return _ForcesManyModel.update(
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

const String title = 'Forces - Many';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _ForcesManyModel.init,
    iud: _ForcesManyIud<_ForcesManyModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
