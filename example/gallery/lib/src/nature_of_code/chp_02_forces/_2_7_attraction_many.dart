import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_7_attraction_many.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Attraction Many',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.AttractionManyModel.init,
          iur: e.AttractionManyIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
