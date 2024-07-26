import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const radius = 24.0;
  static const topSpeed = 5.0;
  static const double accFactor = 0.2;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover({required f.Vector2 center})
      : position = center,
        velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  _Mover.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  _Mover update(f.Vector2 mouse) {
    final acc = mouse - position;
    final a = acc.normalized() * accFactor;

    final vel = velocity + a;
    final v = vel.clampLenMax(topSpeed);

    return _Mover.update(
      position: position + v,
      velocity: v,
      acceleration: a,
    );
  }

  f.Drawing display() => f.Translate(
        translation: position,
        canvasOps: [
          f.Circle(
            c: f.Offset.zero,
            radius: radius,
            paint: f.Paint()..color = u.gray5,
          ),
          f.Circle(
            c: f.Offset.zero,
            radius: radius,
            paint: f.Paint()
              ..color = u.black
              ..style = p.PaintingStyle.stroke
              ..strokeWidth = 2.0,
          ),
        ],
      );
}

class _AccModel extends f.Model {
  final f.Vector2 mouse;
  final _Mover mover;

  _AccModel.fromCenter({
    required super.size,
    required f.Vector2 center,
  })  : mouse = center,
        mover = _Mover(center: center);

  _AccModel.init({required f.Size size})
      : this.fromCenter(
          size: size,
          center: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        );

  _AccModel.update({
    required super.size,
    required this.mouse,
    required this.mover,
  });
}

class _AccIud<M extends _AccModel> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2? mousePos;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerHover(:final event):
          mousePos = f.Vector2(event.localPosition.dx, event.localPosition.dy);
        default:
          break;
      }
    }
    final mouse = mousePos ?? model.mouse;

    final m = model.mover.update(mouse);

    return _AccModel.update(
      size: size,
      mouse: mouse,
      mover: m,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      model.mover.display();
}

const String title = 'Motion 101: Acceleration 3';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AccModel.init,
        iud: _AccIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
