import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

final ui.Offset moverInitAcc = ui.Offset(-0.001, 0.01);

class _Mover extends c.Mover {
  // static const double radius = 24.0;
  static const double m = 1.0;
  static const double initPosOffset = 60.0;

  _Mover({required ui.Rect rect})
    : super.update(
        mass: m,
        position: ui.Offset(
          rect.left + initPosOffset,
          rect.top + initPosOffset,
        ),
        velocity: ui.Offset.zero,
        acceleration: moverInitAcc,
      );
}

class _ForcesModel extends f.Model {
  final _Mover mover;

  _ForcesModel.init({required super.size, required super.inputEvents})
    : mover = _Mover(rect: ui.Offset.zero & size);

  _ForcesModel.update({
    required super.size,
    required super.inputEvents,
    required this.mover,
  });
}

class _ForcesIud<M extends _ForcesModel> extends f.IudBase<M>
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
    model.mover.applyForce(wind);
    model.mover.applyForce(gravity);
    model.mover.update();
    model.mover.checkEdges(ui.Offset.zero & size);

    return _ForcesModel.update(
          size: size,
          inputEvents: inputEvents,
          mover: model.mover,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.mover.draw(model.size);
}

const String title = 'Forces';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _ForcesModel.init,
    iud: _ForcesIud<_ForcesModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
