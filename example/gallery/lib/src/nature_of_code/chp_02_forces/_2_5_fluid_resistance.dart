import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

const int numMovers = 9;

class _Liquid {
  static const double c = 0.1;
  final f.Rect rect;

  _Liquid({required this.rect});

  bool contains(_Mover m) => rect.containsVec(m.position);

  f.Vector2 drag(_Mover m) {
    final speed = m.velocity.length;
    final dragMagnitude = c * speed * speed;

    f.Vector2 dragForce = m.velocity;
    dragForce *= -1.0;

    dragForce.normalize();
    dragForce *= dragMagnitude;
    return dragForce;
  }

  f.CanvasOp draw() => f.Rectangle(
        rect: rect,
        paint: f.Paint()
          ..color = const p.HSLColor.fromAHSL(
            1.0,
            0.0,
            0.0,
            0.1,
          ).toColor(),
      );
}

class _Mover {
  static const double size = 8.0;
  static const double massMin = 0.5;
  static const double massMax = 4.0;

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

  _Mover.newRandom({required double right})
      : this(
          m: u.randDoubleRange(massMin, massMax),
          position: f.Vector2(
            u.randDoubleRange(0.0, right),
            0.0,
          ),
        );

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  void checkEdges(f.Rect rect) {
    if (position.y > rect.bottom) {
      position.y = rect.bottom;
      velocity.y *= -0.9;
    }
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

class _FluidModel extends f.Model {
  final List<_Mover> movers;
  final _Liquid liquid;

  _FluidModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => _Mover.newRandom(
            right: size.width,
          ),
        ).toList(),
        liquid = _Liquid(
          rect: f.Rect.fromLTWH(
            0.0,
            size.height / 2,
            size.width,
            size.height / 2,
          ),
        );

  _FluidModel.update({
    required super.size,
    required this.movers,
    required this.liquid,
  });
}

class _FluidIud<M extends _FluidModel> extends f.IudBase<M>
    implements f.Iud<M> {
  static const double gFactor = 0.1;

  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown():
          model.movers.clear();
          model.movers.addAll(
            List.generate(
              numMovers,
              (_) => _Mover.newRandom(
                right: size.width,
              ),
            ),
          );
        default:
          break;
      }
    }

    for (final m in model.movers) {
      if (model.liquid.contains(m)) {
        final dragForce = model.liquid.drag(m);
        m.applyForce(dragForce);
      }

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

    return _FluidModel.update(
      size: size,
      movers: model.movers,
      liquid: model.liquid,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
        canvasOps: [
          model.liquid.draw(),
          for (final m in model.movers) m.draw(),
        ],
      );
}

const String title = 'Fluid Resistance';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _FluidModel.init,
        iud: _FluidIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
