# Floss

**Floss** is a declarative vector graphics abstraction library for Flutter,
inspired by the [Gloss](https://github.com/benl23x5/gloss) library in Haskell.
It provides a composable, tree-structured DSL for describing 2D graphics using
`CustomPainter`, built around immutable data structures and functional-style
state management.

---

## Features

- **Declarative graphics tree** using `Drawing` and `CanvasOp` nodes
- **Data-driven input handling** with an extensible `InputEvent` model
- **Composable canvas operations**: transform, clip, paint, shape primitives,
  images, paragraphs, shadows, etc.
- **Reactive input** integrated with Flutter’s gesture and pointer systems
- **Optional non-clearing canvas** mode to enable "ghosting"/feedback effects
- **Frame-by-frame update loop** driven by a `Ticker`
- **Minimal interface (`Iud`)** for state, updates, and rendering logic

---

## Architecture

```text
            ┌──────────────┐
            │ FlossWidget  │ <─── Flutter widget tree
            └─────┬────────┘
                  │
     ┌────────────┴────────────┐
     │       Config<M>         │
     └────────┬──────┬─────────┘
              │      │
              ▼      |
        ModelCtor<M> │
                     │
              ┌──────┴─────┐
              │   Iud<M>   │ <── App logic: init, update, draw
              └────┬───────┘
                   ▼
          ┌──────────────────┐
          │   Drawing Tree   │ <─── CanvasOp nodes (e.g., Rect, Translate, Paint)
          └──────────────────┘
```

---

## Core Concepts

- [API Reference](https://tyler-conrad.github.io/doc/floss/)

### `Drawing` Tree

- A `Drawing` is a recursive tree of canvas operations (`CanvasOp`)
- Composite operations like `Translate`, `Rotate`, `ClipRect`, etc. apply
  transformations to nested children
- Leaf operations like `Rect`, `Line`, `Image`, etc. perform direct drawing on
  the canvas

### `Iud<M>`

Your application logic lives in an implementation of the `Iud<M>` interface:

- `init` — creates your model
- `update` — updates your model with time and input
- `draw` — builds a `Drawing` tree from your model
- `dispose` / `onExitRequested` — lifecycle hooks

`M` is parametrically polymorphic, the only requirement is that it can be
constructed using the `ModelCtor<M>` function:

```dart
import 'package:floss/floss.dart' as floss;

typedef ModelCtor<M> =
    M Function({
      required ui.Size size,
      required floss.InputEventList inputEvents
  });
```

---

## Example

```dart
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
```

---

## Included Modules

| Module              | Description                                            |
| ------------------- | ------------------------------------------------------ |
| `canvas_ops.dart`   | Core canvas primitives and `Drawing` structure         |
| `floss_widget.dart` | Flutter widget integrating the rendering loop          |
| `input_event.dart`  | Input abstraction layer over Flutter gestures          |
| `config.dart`       | Configuration container for model/Iud/canvas behavior  |
| `miud.dart`         | Iud interface and base classes for model logic         |
| `utils.dart`        | Vector math utilities (`Offset.norm()`, `.clampLen()`) |
| `logger.dart`       | Optional logger abstraction based on `package:logger`  |

---

## Status

Floss is a **work-in-progress** library for experimental canvas-heavy or
simulation-based UI in Flutter. It is designed to enable rich, purely
declarative drawing via trees of composable operations and model-driven
input-handling.

---

## License

MIT © 2025 — Contributions welcome!

## Tested On

- macOS 15.4.1
- Flutter 3.29.3 • channel stable • https://github.com/flutter/flutter.git
- Framework • revision ea121f8859 (8 days ago) • 2025-04-11 19:10:07 +0000
- Engine • revision cf56914b32
- Tools • Dart 3.7.2 • DevTools 2.42.3
