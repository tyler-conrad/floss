import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const double radius = 8.0;

  final double mass;
  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover({
    required double m,
    required this.position,
  })  : mass = m,
        velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  void checkEdges(f.Rect rect) {
    if (position.x > rect.right) {
      position.x = rect.right;
      velocity.x *= -1.0;
    } else if (position.x < rect.left) {
      position.x = rect.left;
      velocity.x *= -1.0;
    }

    if (position.y > rect.bottom) {
      position.y = rect.bottom;
      velocity.y *= -1.0;
    }
  }

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * mass * radius;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()..color = u.transparent5black,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _ForcesManyModel extends f.Model {
  static const int numMovers = 20;

  final List<_Mover> movers;

  _ForcesManyModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => _Mover(
            m: u.randDoubleRange(0.1, 4.0),
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
