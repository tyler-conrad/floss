import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const double radius = 24.0;
  static const double topSpeed = 5.0;
  static const double accFactor = 0.2;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover({required f.Rect rect})
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

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * radius;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = u.transparent7Black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _AccArrayModel extends f.Model {
  static const int numMovers = 20;

  final f.Vector2 mouse;
  final List<_Mover> movers;

  _AccArrayModel.fromRect({
    required super.size,
    required f.Rect rect,
  })  : mouse = f.Vector2.fromOffset(rect.center),
        movers = List.generate(numMovers, (_) => _Mover(rect: rect));

  _AccArrayModel.init({required f.Size size})
      : this.fromRect(
          size: size,
          rect: f.Rect.fromOffsetSize(
            f.Offset.zero,
            size,
          ),
        );

  _AccArrayModel.update({
    required super.size,
    required this.mouse,
    required this.movers,
  });
}

class _AccArrayIud<M extends _AccArrayModel> extends f.IudBase<M>
    implements f.Iud<M> {
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
          mousePos = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
        default:
          break;
      }
    }
    final mouse = mousePos ?? model.mouse;

    return _AccArrayModel.update(
      size: size,
      mouse: mouse,
      movers: model.movers.map((m) => m.update(mouse)).toList(),
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
          canvasOps: model.movers.map((m) => m.draw(model.size)).toList());
}

const String title = 'Motion 101: Acceleration Array';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AccArrayModel.init,
        iud: _AccArrayIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
