import 'dart:collection';

import 'package:flutter/gestures.dart' as g;
import 'package:flutter/services.dart' as s;

/// Represents an input event.
///
/// This is the base class for all input events in the application. The main
/// reason for wrapping the event types generated by the Flutter framework is to
/// provide a data-driven interface for handling input events.
sealed class InputEvent {
  const InputEvent();
}

/// Represents a tap down event.
class TapDown extends InputEvent {
  final g.TapDownDetails details;

  TapDown({required this.details});
}

/// Represents a tap up event.
class TapUp extends InputEvent {
  final g.TapUpDetails details;

  TapUp({required this.details});
}

/// Represents a tap event.
class Tap extends InputEvent {
  const Tap();
}

/// Represents a tap cancel event.
class TapCancel extends InputEvent {
  const TapCancel();
}

/// Represents a secondary tap event.
class SecondaryTap extends InputEvent {
  const SecondaryTap();
}

/// Represents a secondary tap down event.
class SecondaryTapDown extends InputEvent {
  final g.TapDownDetails details;

  SecondaryTapDown({required this.details});
}

/// Represents a secondary tap up event.
class SecondaryTapUp extends InputEvent {
  final g.TapUpDetails details;

  SecondaryTapUp({required this.details});
}

/// Represents a secondary tap cancel event.
class SecondaryTapCancel extends InputEvent {
  const SecondaryTapCancel();
}

/// Represents a tertiary tap down event.
class TertiaryTapDown extends InputEvent {
  final g.TapDownDetails details;

  TertiaryTapDown({required this.details});
}

/// Represents a tertiary tap up event.
class TertiaryTapUp extends InputEvent {
  final g.TapUpDetails details;

  TertiaryTapUp({required this.details});
}

/// Represents a tertiary tap cancel event.
class TertiaryTapCancel extends InputEvent {
  const TertiaryTapCancel();
}

/// Represents a double tap down event.
class DoubleTapDown extends InputEvent {
  final g.TapDownDetails details;

  DoubleTapDown({required this.details});
}

/// Represents a double tap event.
class DoubleTap extends InputEvent {
  const DoubleTap();
}

/// Represents a double tap cancel event.
class DoubleTapCancel extends InputEvent {
  const DoubleTapCancel();
}

/// Represents a long press down event.
class LongPressDown extends InputEvent {
  final g.LongPressDownDetails details;

  LongPressDown({required this.details});
}

/// Represents a long press cancel event.
class LongPressCancel extends InputEvent {
  const LongPressCancel();
}

/// Represents a long press event.
class LongPress extends InputEvent {
  const LongPress();
}

/// Represents a long press start event.
class LongPressStart extends InputEvent {
  final g.LongPressStartDetails details;

  LongPressStart({required this.details});
}

/// Represents a long press move update event.
class LongPressMoveUpdate extends InputEvent {
  final g.LongPressMoveUpdateDetails details;

  LongPressMoveUpdate({required this.details});
}

/// Represents a long press up event.
class LongPressUp extends InputEvent {
  const LongPressUp();
}

/// Represents a long press end event.
class LongPressEnd extends InputEvent {
  final g.LongPressEndDetails details;

  LongPressEnd({required this.details});
}

/// Represents a secondary long press down event.
class SecondaryLongPressDown extends InputEvent {
  final g.LongPressDownDetails details;

  SecondaryLongPressDown({required this.details});
}

/// Represents a secondary long press cancel event.
class SecondaryLongPressCancel extends InputEvent {
  const SecondaryLongPressCancel();
}

/// Represents a secondary long press event.
class SecondaryLongPress extends InputEvent {
  const SecondaryLongPress();
}

/// Represents a secondary long press start event.
class SecondaryLongPressStart extends InputEvent {
  final g.LongPressStartDetails details;

  SecondaryLongPressStart({required this.details});
}

/// Represents a secondary long press move update event.
class SecondaryLongPressMoveUpdate extends InputEvent {
  final g.LongPressMoveUpdateDetails details;

  SecondaryLongPressMoveUpdate({required this.details});
}

/// Represents a secondary long press up event.
class SecondaryLongPressUp extends InputEvent {
  const SecondaryLongPressUp();
}

/// Represents a secondary long press end event.
class SecondaryLongPressEnd extends InputEvent {
  final g.LongPressEndDetails details;

  SecondaryLongPressEnd({required this.details});
}

/// Represents a tertiary long press down event.
class TertiaryLongPressDown extends InputEvent {
  final g.LongPressDownDetails details;

  TertiaryLongPressDown({required this.details});
}

/// Represents a tertiary long press cancel event.
class TertiaryLongPressCancel extends InputEvent {
  const TertiaryLongPressCancel();
}

/// Represents a tertiary long press event.
class TertiaryLongPress extends InputEvent {
  const TertiaryLongPress();
}

/// Represents a tertiary long press start event.
class TertiaryLongPressStart extends InputEvent {
  final g.LongPressStartDetails details;

  TertiaryLongPressStart({required this.details});
}

/// Represents a tertiary long press move update event.
class TertiaryLongPressMoveUpdate extends InputEvent {
  final g.LongPressMoveUpdateDetails details;

  TertiaryLongPressMoveUpdate({required this.details});
}

/// Represents a tertiary long press up event.
class TertiaryLongPressUp extends InputEvent {
  const TertiaryLongPressUp();
}

/// Represents a tertiary long press end event.
class TertiaryLongPressEnd extends InputEvent {
  final g.LongPressEndDetails details;

  TertiaryLongPressEnd({required this.details});
}

/// Represents a force press start event.
class ForcePressStart extends InputEvent {
  final g.ForcePressDetails details;

  ForcePressStart({required this.details});
}

/// Represents a force press peak event.
class ForcePressPeak extends InputEvent {
  final g.ForcePressDetails details;

  ForcePressPeak({required this.details});
}

/// Represents a force press update event.
class ForcePressUpdate extends InputEvent {
  final g.ForcePressDetails details;

  ForcePressUpdate({required this.details});
}

/// Represents a force press end event.
class ForcePressEnd extends InputEvent {
  final g.ForcePressDetails details;

  ForcePressEnd({required this.details});
}

/// Represents a scale start event.
class ScaleStart extends InputEvent {
  final g.ScaleStartDetails details;

  ScaleStart({required this.details});
}

/// Represents a scale update event.
class ScaleUpdate extends InputEvent {
  final g.ScaleUpdateDetails details;

  ScaleUpdate({required this.details});
}

/// Represents a scale end event.
class ScaleEnd extends InputEvent {
  final g.ScaleEndDetails details;

  ScaleEnd({required this.details});
}

//##############################################################################

/// Represents a pointer down event.
class PointerDown extends InputEvent {
  final g.PointerDownEvent event;

  PointerDown({required this.event});
}

/// Represents a pointer move event.
class PointerMove extends InputEvent {
  final g.PointerMoveEvent event;

  PointerMove({required this.event});
}

/// Represents a pointer up event.
class PointerUp extends InputEvent {
  final g.PointerUpEvent event;

  PointerUp({required this.event});
}

/// Represents a pointer hover event.
class PointerHover extends InputEvent {
  final g.PointerHoverEvent event;

  PointerHover({required this.event});
}

/// Represents a pointer cancel event.
class PointerCancel extends InputEvent {
  final g.PointerCancelEvent event;

  PointerCancel({required this.event});
}

/// Represents a pointer pan zoom start event.
class PointerPanZoomStart extends InputEvent {
  final g.PointerPanZoomStartEvent event;

  PointerPanZoomStart({required this.event});
}

/// Represents a pointer pan zoom update event.
class PointerPanZoomUpdate extends InputEvent {
  final g.PointerPanZoomUpdateEvent event;

  PointerPanZoomUpdate({required this.event});
}

/// Represents a pointer pan zoom end event.
class PointerPanZoomEnd extends InputEvent {
  final g.PointerPanZoomEndEvent event;

  PointerPanZoomEnd({required this.event});
}

/// Represents a pointer signal event.
class PointerSignal extends InputEvent {
  final g.PointerSignalEvent event;

  PointerSignal({required this.event});
}

////////////////////////////////////////////////////////////////////////////////

/// Represents an input event when a pointer enters a target.
class PointerEnter extends InputEvent {
  final g.PointerEnterEvent event;

  PointerEnter({required this.event});
}

/// Represents an input event when a pointer exits a target.
class PointerExit extends InputEvent {
  final g.PointerExitEvent event;

  PointerExit({required this.event});
}

/// Represents an input event when a pointer hovers over a target.
class PointerHoverEnter extends InputEvent {
  final g.PointerHoverEvent event;

  PointerHoverEnter({required this.event});
}

//##############################################################################

/// Represents a key event.
///
/// This class extends the [InputEvent] class and encapsulates a [s.KeyEvent]
/// object.It is used to handle key events in the application.
class KeyEvent extends InputEvent {
  final s.KeyEvent event;

  KeyEvent({required this.event});
}

//##############################################################################

/// Represents a list of input events.
///
/// This class provides a collection of input events and supports operations
/// such as adding events to the list and clearing the list. It implements the
/// [IterableMixin], allowing you to iterate over the input events.
class InputEventList with IterableMixin<InputEvent> {
  final List<InputEvent> _list = [];

  /// Adds an input event to the list.
  ///
  /// The [event] parameter represents the input event to be added.
  void add(InputEvent event) => _list.add(event);

  /// Clears the list of input events.
  ///
  /// This method removes all input events from the list.
  void clear() => _list.clear();

  @override
  Iterator<InputEvent> get iterator => _list.iterator;
}
