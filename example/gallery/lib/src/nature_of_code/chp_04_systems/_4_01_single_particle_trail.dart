import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _SingleParticleModel extends f.Model {
  static const topOffset = 20.0;

  c.Particle particle;
  bool mouseDown = false;

  _SingleParticleModel.init({required super.size})
      : particle = c.Particle(
          position: f.Vector2(size.width * 0.5, topOffset),
        );

  _SingleParticleModel.update({
    required super.size,
    required this.particle,
    required this.mouseDown,
  });
}

class _SingleParticleIud<M extends _SingleParticleModel> extends f.IudBase<M>
    implements f.Iud<M> {
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
          position: f.Vector2(
            size.width * 0.5,
            _SingleParticleModel.topOffset,
          ),
        );
      }
    }
    return _SingleParticleModel.update(
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
    return model.mouseDown
        ? model.particle.draw(model.size)
        : const f.Drawing(canvasOps: []);
  }
}

const String title = 'Single Particle Trail';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _SingleParticleModel.init,
        iud: _SingleParticleIud(),
        clearCanvas: f.NoClearCanvas(
          paint: f.Paint()
            ..color = u.transparentWhite
            ..blendMode = p.BlendMode.srcOver,
        ),
      ),
    );
