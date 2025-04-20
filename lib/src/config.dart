import 'dart:ui' as ui;

import 'miud.dart' as miud;

/// Represents a sealed class for clearing the canvas.
///
/// This class serves as a base class for different types of canvas clearing
/// operations. It is intended to be extended by subclasses that define specific
/// canvas clearing behaviors.
sealed class ClearCanvasType {
  const ClearCanvasType();
}

/// Represents a type of canvas that does not clear itself before drawing.
///
/// This class extends the [ClearCanvasType] class.
///
/// The [NoClearCanvas] class requires a [paint] object of type [ui.Paint] to be
/// provided. This class is used to configure the `FlossWidget` to keep that
/// last drawn frame and draw on top of it.
class NoClearCanvas extends ClearCanvasType {
  final ui.Paint paint;

  const NoClearCanvas({required this.paint});
}

/// Represents a clear canvas configuration.
///
/// Use this class to configure the `FlossWidget` to clear the canvas on every
/// frame (this is the default Flutter behavior).
class ClearCanvas extends ClearCanvasType {
  const ClearCanvas();
}

/// Represents a `FlossWidget` configuration for a specific model type.
///
/// The [Config] class holds information passed to the `FlossWidget`
/// constructor. The [modelCtor] parameter is a function that constructs an
/// instance of the model type [M] from a widget [ui.Size] and the initial
/// `InputEventList`. The type of the model constructor must match the type
/// alias [miud.ModelCtor].
///
/// The [iud] parameter is an object that provides the initialize, update, and
/// draw methods and implements the [miud.Iud] interface.
///
/// The [clearCanvas] parameter specifies the type of canvas clearing. It can be
/// either [NoClearCanvas] or [ClearCanvas].
class Config<M> {
  final miud.ModelCtor<M> modelCtor;
  final miud.Iud<M> iud;
  final ClearCanvasType clearCanvas;

  Config({
    required this.modelCtor,
    required this.iud,
    required this.clearCanvas,
  });
}
