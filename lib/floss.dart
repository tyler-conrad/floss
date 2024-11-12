/// Floss is a vector graphics abstraction library for Flutter.
///
/// It allows for data driven processing of input events and a tree data
/// structure for rendering. It is partially inspired by the
/// [gloss](https://github.com/benl23x5/gloss) library for Haskell. Typical use
/// of the library involves creating a `FlossWidget` as part of the build method
/// of a `Widget`.
///
/// The `FlossWidget` uses the `Iud` interface to manage the application state
/// and rendering. This class is a minimal interface that provides methods for
/// initializing the model, updating the model, and drawing the model. The model
/// is used to draw the `Drawing` tree data structure on the canvas. The
/// `Drawing` tree data structure is composed of `Drawing` nodes that represent
/// the different types of shapes and composite operations like translations,
/// rotations, and scaling.
library;

export 'src/logger.dart' show l;
export 'src/input_event.dart';
export 'src/canvas_ops.dart';
export 'src/config.dart';
export 'src/miud.dart';
export 'src/floss_widget.dart' show FlossWidget;
