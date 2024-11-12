import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _SingleParticleTrailModel extends f.Model {
  static const topOffset = 20.0;

  c.Particle particle;
  bool mouseDown = false;

  _SingleParticleTrailModel.init({required super.size})
      : particle = c.Particle(
          position: ui.Offset(size.width * 0.5, topOffset),
        );

  _SingleParticleTrailModel.update({
    required super.size,
    required this.particle,
    required this.mouseDown,
  });
}

class _SingleParticleTrailIud<M extends _SingleParticleTrailModel>
    extends f.IudBase<M> implements f.Iud<M> {
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
          model.mouseDown = true;
          break;

        case f.PointerUp():
          model.mouseDown = false;
          break;

        default:
          break;
      }
    }

    if (model.mouseDown) {
      model.particle.update();
      if (model.particle.isDead) {
        model.particle = c.Particle(
          position: ui.Offset(
            size.width * 0.5,
            _SingleParticleTrailModel.topOffset,
          ),
        );
      }
    }
    return _SingleParticleTrailModel.update(
      size: size,
      particle: model.particle,
      mouseDown: model.mouseDown,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    return model.mouseDown ? model.particle.draw(model.size) : const f.Noop();
  }
}

const String title = 'Single Particle Trail';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _SingleParticleTrailModel.init,
        iud: _SingleParticleTrailIud<_SingleParticleTrailModel>(),
        clearCanvas: f.NoClearCanvas(
          paint: ui.Paint()
            ..color = u.transparentWhite
            ..blendMode = p.BlendMode.srcOver,
        ),
      ),
    );
