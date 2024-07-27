import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _RealGravityModel extends f.Model {
  static const int numMovers = 20;

  final List<c.Mover> movers;

  _RealGravityModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => c.Mover(
            mass: u.randDoubleRange(c.Mover.massMin, c.Mover.massMax),
            position: f.Vector2.zero(),
          ),
        ).toList();

  _RealGravityModel.update({
    required super.size,
    required this.movers,
  });
}

class _RealGravityIud<M extends _RealGravityModel> extends f.IudBase<M>
    implements f.Iud<M> {
  static const double gFactor = 0.1;

  final wind = f.Vector2(0.01, 0.0);

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
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

    return _RealGravityModel.update(
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

const String title = 'Forces - Many Real Gravity';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _RealGravityModel.init,
        iud: _RealGravityIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
