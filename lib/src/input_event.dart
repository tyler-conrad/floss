import 'package:flutter/gestures.dart' as g;
import 'package:flutter/services.dart' as s;

sealed class InputEvent {
  const InputEvent();
}

class TapDown extends InputEvent {
  final g.TapDownDetails details;

  TapDown({required this.details});
}

class TapUp extends InputEvent {
  final g.TapUpDetails details;

  TapUp({required this.details});
}

class Tap extends InputEvent {
  const Tap();
}

class TapCancel extends InputEvent {
  const TapCancel();
}

class SecondaryTap extends InputEvent {
  const SecondaryTap();
}

class SecondaryTapDown extends InputEvent {
  final g.TapDownDetails details;

  SecondaryTapDown({required this.details});
}

class SecondaryTapUp extends InputEvent {
  final g.TapUpDetails details;

  SecondaryTapUp({required this.details});
}

class SecondaryTapCancel extends InputEvent {
  const SecondaryTapCancel();
}

class TertiaryTapDown extends InputEvent {
  final g.TapDownDetails details;

  TertiaryTapDown({required this.details});
}

class TertiaryTapUp extends InputEvent {
  final g.TapUpDetails details;

  TertiaryTapUp({required this.details});
}

class TertiaryTapCancel extends InputEvent {
  const TertiaryTapCancel();
}

class DoubleTapDown extends InputEvent {
  final g.TapDownDetails details;

  DoubleTapDown({required this.details});
}

class DoubleTap extends InputEvent {
  const DoubleTap();
}

class DoubleTapCancel extends InputEvent {
  const DoubleTapCancel();
}

class LongPressDown extends InputEvent {
  final g.LongPressDownDetails details;

  LongPressDown({required this.details});
}

class LongPressCancel extends InputEvent {
  const LongPressCancel();
}

class LongPress extends InputEvent {
  const LongPress();
}

class LongPressStart extends InputEvent {
  final g.LongPressStartDetails details;

  LongPressStart({required this.details});
}

class LongPressMoveUpdate extends InputEvent {
  final g.LongPressMoveUpdateDetails details;

  LongPressMoveUpdate({required this.details});
}

class LongPressUp extends InputEvent {
  const LongPressUp();
}

class LongPressEnd extends InputEvent {
  final g.LongPressEndDetails details;

  LongPressEnd({required this.details});
}

class SecondaryLongPressDown extends InputEvent {
  final g.LongPressDownDetails details;

  SecondaryLongPressDown({required this.details});
}

class SecondaryLongPressCancel extends InputEvent {
  const SecondaryLongPressCancel();
}

class SecondaryLongPress extends InputEvent {
  const SecondaryLongPress();
}

class SecondaryLongPressStart extends InputEvent {
  final g.LongPressStartDetails details;

  SecondaryLongPressStart({required this.details});
}

class SecondaryLongPressMoveUpdate extends InputEvent {
  final g.LongPressMoveUpdateDetails details;

  SecondaryLongPressMoveUpdate({required this.details});
}

class SecondaryLongPressUp extends InputEvent {
  const SecondaryLongPressUp();
}

class SecondaryLongPressEnd extends InputEvent {
  final g.LongPressEndDetails details;

  SecondaryLongPressEnd({required this.details});
}

class TertiaryLongPressDown extends InputEvent {
  final g.LongPressDownDetails details;

  TertiaryLongPressDown({required this.details});
}

class TertiaryLongPressCancel extends InputEvent {
  const TertiaryLongPressCancel();
}

class TertiaryLongPress extends InputEvent {
  const TertiaryLongPress();
}

class TertiaryLongPressStart extends InputEvent {
  final g.LongPressStartDetails details;

  TertiaryLongPressStart({required this.details});
}

class TertiaryLongPressMoveUpdate extends InputEvent {
  final g.LongPressMoveUpdateDetails details;

  TertiaryLongPressMoveUpdate({required this.details});
}

class TertiaryLongPressUp extends InputEvent {
  const TertiaryLongPressUp();
}

class TertiaryLongPressEnd extends InputEvent {
  final g.LongPressEndDetails details;

  TertiaryLongPressEnd({required this.details});
}

class ForcePressStart extends InputEvent {
  final g.ForcePressDetails details;

  ForcePressStart({required this.details});
}

class ForcePressPeak extends InputEvent {
  final g.ForcePressDetails details;

  ForcePressPeak({required this.details});
}

class ForcePressUpdate extends InputEvent {
  final g.ForcePressDetails details;

  ForcePressUpdate({required this.details});
}

class ForcePressEnd extends InputEvent {
  final g.ForcePressDetails details;

  ForcePressEnd({required this.details});
}

class ScaleStart extends InputEvent {
  final g.ScaleStartDetails details;

  ScaleStart({required this.details});
}

class ScaleUpdate extends InputEvent {
  final g.ScaleUpdateDetails details;

  ScaleUpdate({required this.details});
}

class ScaleEnd extends InputEvent {
  final g.ScaleEndDetails details;

  ScaleEnd({required this.details});
}

////////////////////////////////////////////////////////////////////////////////

class PointerDown extends InputEvent {
  final g.PointerDownEvent event;

  PointerDown({required this.event});
}

class PointerMove extends InputEvent {
  final g.PointerMoveEvent event;

  PointerMove({required this.event});
}

class PointerUp extends InputEvent {
  final g.PointerUpEvent event;

  PointerUp({required this.event});
}

class PointerHover extends InputEvent {
  final g.PointerHoverEvent event;

  PointerHover({required this.event});
}

class PointerCancel extends InputEvent {
  final g.PointerCancelEvent event;

  PointerCancel({required this.event});
}

class PointerPanZoomStart extends InputEvent {
  final g.PointerPanZoomStartEvent event;

  PointerPanZoomStart({required this.event});
}

class PointerPanZoomUpdate extends InputEvent {
  final g.PointerPanZoomUpdateEvent event;

  PointerPanZoomUpdate({required this.event});
}

class PointerPanZoomEnd extends InputEvent {
  final g.PointerPanZoomEndEvent event;

  PointerPanZoomEnd({required this.event});
}

class PointerSignal extends InputEvent {
  final g.PointerSignalEvent event;

  PointerSignal({required this.event});
}

////////////////////////////////////////////////////////////////////////////////

class PointerEnter extends InputEvent {
  final g.PointerEnterEvent event;

  PointerEnter({required this.event});
}

class PointerExit extends InputEvent {
  final g.PointerExitEvent event;

  PointerExit({required this.event});
}

class PointerHoverEnter extends InputEvent {
  final g.PointerHoverEvent event;

  PointerHoverEnter({required this.event});
}

////////////////////////////////////////////////////////////////////////////////

class KeyEvent extends InputEvent {
  final s.KeyEvent event;

  KeyEvent({required this.event});
}

////////////////////////////////////////////////////////////////////////////////

class InputEventList {
  final List<InputEvent> list;
  InputEventList({required this.list});

  void clear() => list.clear();
}
