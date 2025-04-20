import 'dart:ui' as ui;

import 'package:flutter/material.dart' as m;
import 'package:floss/floss.dart' as f;

// Model with arbitrary state
class MyModel {
  final ui.Offset position;
  final ui.Size size;
  final f.InputEventList inputEvents;
  // Only requirement is that there is a `Function` that takes a `ui.Size` and
  // a `f.InputEventList` and returns a model object.
  MyModel({required this.size, required this.inputEvents})
    : position = ui.Offset(size.width / 2, size.height / 2);

  // Named constructor to allow for immutable state updates
  MyModel.update({
    required this.size,
    required this.inputEvents,
    required this.position,
  });
}

// IUD (Input Update Draw) class
class MyIud extends f.IudBase<MyModel> {
  // `init()` is inherited from `IudBase` and is called when the model is created.

  // This is where the model is updated based on input events
  @override
  MyModel update({
    required MyModel model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final event in inputEvents) {
      switch (event) {
        // update `position` based on mouse events
        case f.PointerMove(:final event):
          return MyModel.update(
            size: size,
            inputEvents: inputEvents,
            position: event.localPosition,
          );
        default:
          break;
      }
    }
    // If no mouse events, return the model unchanged
    return MyModel.update(
      size: size,
      inputEvents: inputEvents,
      position: model.position,
    );
  }

  // This is where the drawing tree is created based on the model
  @override
  f.Drawing draw({required MyModel model, required bool lightThemeActive}) {
    // `f.Drawing` is just a container for other `CanvasOp`s
    return f.Drawing(
      ops: [
        // `Circle` leaf node that draws a circle at the model's position
        f.Circle(
          center: model.position,
          radius: 20,
          paint: ui.Paint()..color = m.Colors.white,
        ),
      ],
    );
  }
}

void main() {
  m.runApp(
    m.MaterialApp(
      color: m.Colors.white,
      title: 'Floss Example',
      builder: (context, child) {
        return f.FlossWidget(
          focusNode: m.FocusNode(),
          config: f.Config(
            modelCtor: MyModel.new,
            iud: MyIud(),
            clearCanvas: const f.ClearCanvas(),
          ),
        );
      },
    ),
  );
}
