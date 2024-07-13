import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_7_motion101.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Motion 101',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.MotionModel.init,
          iur: e.MotionIur(),
          clearCanvas: f.NoClearCanvas(
            paint: f.Paint()
              ..color = u.transparentWhite
              ..blendMode = m.BlendMode.srcOver,
          ),
        ),
      ),
    ),
  );
}
