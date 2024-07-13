import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_2_bouncingball_vectors_object.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Bouncing Ball Vectors Object',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.BallModel.init,
          iur: e.BallIur(),
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
