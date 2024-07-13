import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_11_motion101_acceleration_array.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Motion 101: Acceleration Array',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.AccArrayModel.init,
          iur: e.AccArrayIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
