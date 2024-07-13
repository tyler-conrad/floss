import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

import '../../utils.dart' as u;

const int numMovers = 20;

class Mover  {
  static const size = 24.0;
  static const topSpeed = 5.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  Mover({required f.Rect rect})
      : position = f.Vector2(
          u.randDoubleRange(
            rect.left,
            rect.right,
          ),
          u.randDoubleRange(
            rect.top,
            rect.bottom,
          ),
        ),
        velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero();

  Mover.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  Mover update(f.Vector2 mouse) {
    final acc = mouse - position;
    final a = acc.normalized() * 0.2;

    final vel = velocity + a;
    final v = vel.clampLenMax(topSpeed);

    return Mover.update(
      position: position + v,
      velocity: v,
      acceleration: a,
    );
  }

  f.Drawing display() {
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()
            ..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()
            ..color = u.transparent7Black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class AccArrayModel extends f.Model {
  final f.Vector2 mouse;
  final List<Mover> movers;

  AccArrayModel.fromRect({
    required super.size,
    required f.Rect rect,
  })  : mouse = f.Vector2.fromOffset(rect.center),
        movers = List.generate(numMovers, (_) => Mover(rect: rect));

  AccArrayModel.init({required f.Size size})
      : this.fromRect(
          size: size,
          rect: f.Rect.fromOffsetSize(
            f.Offset.zero,
            size,
          ),
        );

  AccArrayModel.update({
    required super.size,
    required this.mouse,
    required this.movers,
  });
}

class AccArrayIur<M extends AccArrayModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2? mousePos;
    for (final ie in inputEvents.list) {
      switch (ie) {
        case f.PointerHover(:final event):
          mousePos = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
        default:
          break;
      }
    }
    final mouse = mousePos ?? model.mouse;

    return AccArrayModel.update(
      size: size,
      mouse: mouse,
      movers: model.movers.map((m) => m.update(mouse)).toList(),
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return f.Drawing(
        canvasOps: model.movers.map((m) => m.display()).toList());
  }
}
