import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const double size = 12.0;
  static const double g = 0.4;
  static const double minMass = 0.1;
  static const double maxMass = 2.0;

  final double mass;
  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover({
    required this.mass,
    required this.position,
  })  : velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  f.Vector2 attract(_Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(5.0, d), 25.0);
    force.normalize();
    final strength = (g * mass * m.mass) / (d * d);
    return force * strength;
  }

  f.Drawing draw() => f.Translate(
        translation: position,
        canvasOps: [
          f.Circle(
            c: f.Offset.zero,
            radius: mass * size,
            paint: f.Paint()..color = u.transparent5black,
          ),
          f.Circle(
            c: f.Offset.zero,
            radius: mass * size,
            paint: f.Paint()
              ..color = u.black
              ..style = p.PaintingStyle.stroke
              ..strokeWidth = 2.0,
          ),
        ],
      );
}

class _MutualAttractionModel extends f.Model {
  static const int numMovers = 500;

  final List<_Mover> movers;

  _MutualAttractionModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => _Mover(
              mass: u.randDoubleRange(_Mover.minMass, _Mover.maxMass),
              position: f.Vector2(
                u.randDoubleRange(0.0, size.width),
                u.randDoubleRange(0.0, size.height),
              )),
        ).toList();

  _MutualAttractionModel.update({
    required super.size,
    required this.movers,
  });
}

class _MutualAttractionIud<M extends _MutualAttractionModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final left in model.movers) {
      for (final right in model.movers) {
        if (left != right) {
          left.applyForce(right.attract(left));
        }
      }
      left.update();
    }

    return _MutualAttractionModel.update(
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
          for (final m in model.movers) m.draw(),
        ],
      );
}

const String title = 'Mutual Attraction';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _MutualAttractionModel.init,
        iud: _MutualAttractionIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
