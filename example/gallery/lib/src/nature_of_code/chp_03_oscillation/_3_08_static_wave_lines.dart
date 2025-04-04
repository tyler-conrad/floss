import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _StaticWaveLinesModel extends f.Model {
  final double angleVel;
  final List<ui.Offset> vertices;

  _StaticWaveLinesModel.init({required super.size})
      : angleVel = 0.1,
        vertices = [];

  _StaticWaveLinesModel.update({
    required super.size,
    required this.angleVel,
    required this.vertices,
  });
}

class _StaticWaveLinesIud<M extends _StaticWaveLinesModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    double angle = 0.0;
    model.vertices.clear();
    for (var x = 0; x < size.width; x += 5) {
      model.vertices
          .add(ui.Offset(x.toDouble(), 0.5 * size.height * math.sin(angle)));
      angle += model.angleVel;
    }
    return _StaticWaveLinesModel.update(
      size: size,
      angleVel: model.angleVel,
      vertices: model.vertices,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) =>
      f.Translate(
        translation: ui.Offset(0.0, model.size.height * 0.5),
        canvasOps: [
          f.Points(
            pointMode: ui.PointMode.polygon,
            points: model.vertices,
            paint: ui.Paint()
              ..color = u.black
              ..strokeWidth = 2.0,
          ),
        ],
      );
}

const String title = 'Static Wave Lines';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _StaticWaveLinesModel.init,
        iud: _StaticWaveLinesIud<_StaticWaveLinesModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
