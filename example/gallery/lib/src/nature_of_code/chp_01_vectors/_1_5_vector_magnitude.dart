import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_5_vector_magnitude.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Vector Magnitude',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.VecMagModel.init,
          iur: e.VecMagIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
