import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_9_motion101_acceleration.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Motion 101: Acceleration',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.AccModel.init,
          iur: e.AccIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
