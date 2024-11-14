import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _FrictionModel extends f.Model {
  static const int numMovers = 20;

  final List<c.Mover> movers;

  _FrictionModel.init({required super.size})
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

  _FrictionModel.update({
    required super.size,
    required this.movers,
  });
}

class _FrictionIud<M extends _FrictionModel> extends f.IudBase<M>
    implements f.Iud<M> {
  static const double gFactor = 0.1;
  static const double c = 0.05;

  final f.Vector2 wind = f.Vector2(0.01, 0.0);

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final m in model.movers) {
      final f.Vector2 gravity = f.Vector2(0.0, gFactor * m.mass);

      f.Vector2 friction = m.velocity;
      if (friction.length > 0.0) {
        friction *= -1.0;
        friction = friction.normalized();
        friction *= c;
        m.applyForce(friction);
      }

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

    return _FrictionModel.update(
      size: size,
      movers: model.movers,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) =>
      f.Drawing(
        canvasOps: [
          for (final m in model.movers) m.draw(model.size),
        ],
      );
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
