import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _NoFrictionModel extends f.Model {
  static const int numMovers = 20;

  final List<c.Mover> movers;

  _NoFrictionModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => c.Mover(
            mass: u.randDoubleRange(c.Mover.massMin, c.Mover.massMax),
            position: f.Vector2(
              u.randDoubleRange(0.0, size.width),
              0.0,
            ),
          ),
        ).toList();

  _NoFrictionModel.update({
    required super.size,
    required this.movers,
  });
}

class _NoFrictionIud<M extends _NoFrictionModel> extends f.IudBase<M>
    implements f.Iud<M> {
  static const double gFactor = 0.1;

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    final wind = f.Vector2(0.01, 0.0);
    for (final m in model.movers) {
      m.applyForce(wind);
      final gravity = f.Vector2(0.0, gFactor * m.mass);
      m.applyForce(gravity);
      m.update();
      m.checkEdges(
        f.Rect.fromOffsetSize(
          f.Offset(0.0, 0.0),
          size,
        ),
      );
    }

    return _NoFrictionModel.update(
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

const String title = 'Forces - No Friction';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _NoFrictionModel.init,
        iud: _NoFrictionIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
