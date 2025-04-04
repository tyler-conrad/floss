import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

class _SystemOfSystemsModel extends f.Model {
  final List<c.ParticleSystem> systems;

  _SystemOfSystemsModel.init({required super.size}) : systems = [];

  _SystemOfSystemsModel.update({
    required super.size,
    required this.systems,
  });
}

class _SystemOfSystemsIud<M extends _SystemOfSystemsModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    ui.Offset? mouse;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          mouse = ui.Offset(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          break;

        default:
          break;
      }
    }

    if (mouse != null) {
      model.systems.add(c.ParticleSystem(origin: mouse));
    }

    for (final s in model.systems) {
      s.addParticle();
    }

    return _SystemOfSystemsModel.update(
      size: size,
      systems: model.systems
          .map(
            (ps) => ps.update(ps.origin),
          )
          .toList(),
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) {
    return f.Drawing(
      canvasOps: [
        for (final s in model.systems) s.draw(model.size),
      ],
    );
  }
}

const String title = 'System of Systems';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _SystemOfSystemsModel.init,
        iud: _SystemOfSystemsIud<_SystemOfSystemsModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
