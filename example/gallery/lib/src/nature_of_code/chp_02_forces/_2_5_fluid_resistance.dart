import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _Liquid {
  static const double c = 0.1;

  f.Offset position;
  ui.Size size;

  ui.Rect get rect => ui.Rect.fromOffsetSize(position, size);

  _Liquid({required this.position, required this.size});

  void update(ui.Size size) {
    position = f.Offset(0.0, size.height / 2);
    this.size = ui.Size(size.width, size.height / 2);
  }

  bool contains(_Mover m) => rect.containsVec(m.position);

  ui.Offset drag(_Mover m) {
    final speed = m.velocity.length;
    final dragMagnitude = c * speed * speed;

    ui.Offset dragForce = m.velocity;
    dragForce *= -1.0;

    dragForce.normalize();
    dragForce *= dragMagnitude;
    return dragForce;
  }

  f.CanvasOp draw() => f.Rectangle(
        rect: rect,
        paint: ui.Paint()
          ..color = const p.HSLColor.fromAHSL(
            0.5,
            0.0,
            0.0,
            0.1,
          ).toColor(),
      );
}

class _Mover extends c.Mover {
  static const double massMin = 0.5;
  static const double massMax = 4.0;

  _Mover({
    required super.mass,
    required super.position,
  });

  _Mover.newRandom({required double right})
      : this(
          mass: u.randDoubleRange(massMin, massMax),
          position: ui.Offset(
            u.randDoubleRange(0.0, right),
            0.0,
          ),
        );

  @override
  void checkEdges(ui.Rect rect) {
    if (position.y > rect.bottom) {
      position.y = rect.bottom;
      velocity.y *= -0.9;
    }
  }
}

class _FluidModel extends f.Model {
  static const int numMovers = 9;

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
          position: f.Offset(0.0, size.height / 2),
          size: ui.Size(size.width, size.height / 2),
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
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown():
          model.movers.clear();
          model.movers.addAll(
            List.generate(
              _FluidModel.numMovers,
              (_) => _Mover.newRandom(
                right: size.width,
              ),
            ),
          );
        default:
          break;
      }
    }

    model.liquid.update(size);

    for (final m in model.movers) {
      if (model.liquid.contains(m)) {
        final dragForce = model.liquid.drag(m);
        m.applyForce(dragForce);
      }

      final gravity = ui.Offset(0.0, gFactor * m.mass);

      m.applyForce(gravity);
      m.update();
      m.checkEdges(
        ui.Rect.fromOffsetSize(
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
          for (final m in model.movers) m.draw(model.size),
        ],
      );
}

const String title = 'Fluid Resistance';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _FluidModel.init,
        iud: _FluidIud<_FluidModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
