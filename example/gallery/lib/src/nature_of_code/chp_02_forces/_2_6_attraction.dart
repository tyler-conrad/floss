import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_6_attraction.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Attraction',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.AttractionModel.init,
          iur: e.AttractionrIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
