import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

final ui.Offset moverInitAcc = ui.Offset(-0.001, 0.01);

class _Mover extends c.Mover {
  static const double radius = 24.0;
  static const double m = 1.0;
  static const double initPosOffset = 60.0;

  _Mover({required ui.Rect rect})
      : super.update(
          mass: m,
          position: ui.Offset(
            rect.left + initPosOffset,
            rect.top + initPosOffset,
          ),
          velocity: ui.Offset.zero(),
          acceleration: moverInitAcc,
        );
}

class _ForcesModel extends f.Model {
  final _Mover mover;

  _ForcesModel.init({required super.size})
      : mover = _Mover(
          rect: ui.Rect.fromOffsetSize(
            ui.Offset.zero,
            size,
          ),
        );

  _ForcesModel.update({
    required super.size,
    required this.mover,
  });
}

class _ForcesIud<M extends _ForcesModel> extends f.IudBase<M>
    implements f.Iud<M> {
  final ui.Offset wind = ui.Offset(0.01, 0.0);
  final ui.Offset gravity = ui.Offset(0.0, 0.1);

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
    model.mover.checkEdges(
      ui.Rect.fromOffsetSize(
        f.Offset(0.0, 0.0),
        size,
      ),
    );

    return _ForcesModel.update(
      size: size,
      mover: model.mover,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
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
