# floss

**Floss** is a declarative vector graphics abstraction library for Flutter,
inspired by the [Gloss](https://github.com/benl23x5/gloss) library in Haskell.
It provides a composable, tree-structured DSL for describing 2D graphics using
`CustomPainter`, built around immutable data structures and functional-style
state management.

![Example](example.gif)

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

## Basic `CanvasOp` Subclasses

| Class        | Basic Usage                                                                    |
| :----------- | :----------------------------------------------------------------------------- |
| `Picture`    | Draw a recorded `ui.Picture` onto the canvas.                                  |
| `Arc`        | Draw an arc within a rectangle, defined by start and sweep angles.             |
| `Atlas`      | Render multiple parts of an image using transforms and optional colors.        |
| `Circle`     | Draw a circle given a center point and radius.                                 |
| `Color`      | Fill the canvas with a solid color using a blend mode.                         |
| `DRRect`     | Draw the area between two rounded rectangles.                                  |
| `Image`      | Draw an image at a specific offset.                                            |
| `ImageNine`  | Draw a 9-slice scalable image (like a stretchable box).                        |
| `ImageRect`  | Draw a specific rectangle section of an image into a destination rectangle.    |
| `Line`       | Draw a straight line between two points.                                       |
| `Oval`       | Draw an oval inside a rectangle.                                               |
| `Fill`       | Fill the entire canvas with a given paint.                                     |
| `Paragraph`  | Draw a paragraph of text at an offset.                                         |
| `Path`       | Draw a path with a specified paint.                                            |
| `Points`     | Draw multiple points with a paint and point mode.                              |
| `RawAtlas`   | Draw sections of an image atlas with raw transform data (faster, lower-level). |
| `RawPoints`  | Draw multiple points with raw coordinate data.                                 |
| `Rect`       | Draw a rectangle with paint.                                                   |
| `RRect`      | Draw a rounded rectangle with paint.                                           |
| `Shadow`     | Draw a shadow for a given path with elevation and color.                       |
| `Vertices`   | Draw complex shapes made of vertices (custom meshes).                          |

---

## Composite `Drawing` Subclasses

| Class                | Basic Usage |
| :------------------- | :------------------------------------------------------------------------------------------ |
| `Drawing`            | Composite of multiple `CanvasOp`s; runs each op in order.                                   |
| `Noop`               | Does nothing when drawn; useful for conditional drawing branches.                           |
| `Translate`          | Moves the canvas origin by (`dx`, `dy`), draws child ops, then restores.                    |
| `Rotate`             | Rotates the canvas by a specified radians angle, draws child ops, restores.                 |
| `Scale`              | Scales the canvas by `sx` (and optionally `sy`), draws child ops, restores.                 |
| `Skew`               | Skews the canvas along x and y axes, draws child ops, restores.                             |
| `Transform`          | Applies a full matrix transform to the canvas, draws child ops, restores.                   |
| `ClipPath`           | Clips subsequent drawing to a path region, then draws child ops.                            |
| `ClipRect`           | Clips drawing to a rectangle area (with optional ClipOp), draws child ops.                  |
| `ClipRRect`          | Clips drawing to a rounded rectangle area, draws child ops.                                 |
| `Save`               | Saves the canvas state, draws child ops, but doesn't restore afterward itself.              |
| `SaveLayer`          | Saves the canvas into an offscreen layer (with optional bounds and paint), draws child ops. |
| `Restore`            | Forces a manual restore of the last saved canvas state, then draws child ops.               |
| `RestoreToCount`     | Restores to a specific canvas state save count, then draws child ops.                       |
| `BackgroundPicture`  | Renders a background into a `BackgroundPictureType` for "ghosting" effects.                 |



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

## Usage
This library is hosted on [pub.dev](https://pub.dev/packages/floss) and can be
installed by adding the following to your `pubspec.yaml`:

```yaml
dependencies:
  floss: ^0.2.1
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
