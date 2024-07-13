import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_3_vector_subtraction.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Vector Subtraction',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.VecSubModel.init,
          iur: e.VecSubIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
