import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_1_bouncingball_novectors.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Bouncing Ball No Vectors',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.BallModel.init,
          iur: e.BallIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
