import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

final f.Vector2 moverInitAcc = f.Vector2(-0.001, 0.01);

class _Mover extends c.Mover {
  static const double radius = 24.0;
  static const double m = 1.0;
  static const double initPosOffset = 60.0;

  _Mover({required f.Rect rect})
      : super.update(
          mass: m,
          position: f.Vector2(
            rect.left + initPosOffset,
            rect.top + initPosOffset,
          ),
          velocity: f.Vector2.zero(),
          acceleration: moverInitAcc,
        );
}

class _ForcesModel extends f.Model {
  final _Mover mover;

  _ForcesModel.init({required super.size})
      : mover = _Mover(
          rect: f.Rect.fromOffsetSize(
            f.Offset.zero,
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
  final f.Vector2 wind = f.Vector2(0.01, 0.0);
  final f.Vector2 gravity = f.Vector2(0.0, 0.1);

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.mover.applyForce(wind);
    model.mover.applyForce(gravity);
    model.mover.update();
    model.mover.checkEdges(
      f.Rect.fromOffsetSize(
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
    required bool lightThemeActive,
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
