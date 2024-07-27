import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _ForcesManyModel extends f.Model {
  static const int numMovers = 20;

  final List<c.Mover> movers;

  _ForcesManyModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => c.Mover(
            mass: u.randDoubleRange(0.1, 4.0),
            position: f.Vector2.zero(),
          ),
        ).toList();

  _ForcesManyModel.update({
    required super.size,
    required this.movers,
  });
}

class _ForcesManyIud<M extends _ForcesManyModel> extends f.IudBase<M>
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
    for (final m in model.movers) {
      m.applyForce(wind);
      m.applyForce(gravity);
      m.update();
      m.checkEdges(
        f.Rect.fromOffsetSize(
          f.Offset(0.0, 0.0),
          size,
        ),
      );
    }

    return _ForcesManyModel.update(
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

const String title = 'Forces - Many';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _ForcesManyModel.init,
        iud: _ForcesManyIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
