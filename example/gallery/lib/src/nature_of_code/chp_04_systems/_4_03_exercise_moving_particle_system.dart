import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

class _MovingParticleSystemModel extends f.Model {
  static const topOffset = 50.0;

  final c.ParticleSystem system;
  final f.Vector2? mouse;

  _MovingParticleSystemModel.init({required super.size})
      : system = c.ParticleSystem(
          origin: f.Vector2(
            size.width * 0.5,
            topOffset,
          ),
        ),
        mouse = null;

  _MovingParticleSystemModel.update({
    required super.size,
    required this.system,
    required this.mouse,
  });
}

class _MovingParticleSystemIud<M extends _MovingParticleSystemModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Vector2? mouse = model.mouse;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerHover(:final event):
          mouse = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );

        default:
          break;
      }
    }

    c.ParticleSystem ps = model.system;
    if (mouse != null) {
      model.system.addParticle();
      ps = ps.update(mouse);
    }

    return _MovingParticleSystemModel.update(
      size: size,
      system: ps,
      mouse: mouse,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      model.system.draw(model.size);
}

const String title = 'Moving Particle System';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _MovingParticleSystemModel.init,
        iud: _MovingParticleSystemIud<_MovingParticleSystemModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
