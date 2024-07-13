import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_2_forces_many.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Forces Many',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.ForcesManyModel.init,
          iur: e.ForcesManyIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
