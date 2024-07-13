import 'dart:ui' as ui;

import 'package:flutter/material.dart' as m;
import 'package:flutter/scheduler.dart' as s;

import 'logger.dart';
import 'math/geometry.dart' as g;
import 'input_event.dart' as ie;
import 'paint.dart' as pt;
import 'canvas_ops.dart' as go;
import 'config.dart' as c;
import 'miur.dart' as miur;

class _ModelWrapper<M> {
  M _model;

  _ModelWrapper({required M model}) : _model = model;
}

class _FlossPainter<M, IUR extends miur.Iur<M>> extends m.CustomPainter {
  final c.Config _config;
  m.Size _size;
  final _ModelWrapper<M> _modelWrapper;
  final m.ValueNotifier<Duration> _elapsed;
  final ie.InputEventList _inputEvents;

  ui.Image? _background;

  _FlossPainter({
    required m.Size size,
    required m.ValueNotifier<Duration> elapsed,
    required ie.InputEventList inputEvents,
    required c.Config config,
    required m.Listenable super.repaint,
  })  : _size = size,
        _elapsed = elapsed,
        _inputEvents = inputEvents,
        _config = config,
        _modelWrapper = _ModelWrapper(
          model: config.iur.init(
            modelCtor: config.modelCtor,
            size: g.Size.fromSize(size),
          ),
        );

  void _tick(Duration elapsed) {
    _elapsed.value = elapsed;
    _modelWrapper._model = _config.iur.update(
      model: _modelWrapper._model,
      time: elapsed,
      size: g.Size.fromSize(_size),
      inputEvents: _inputEvents,
    );
    _inputEvents.clear();
  }

  void _paint(m.Canvas canvas, m.Size size) {
    _size = size;
    _config.iur
        .render(model: _modelWrapper._model)
        .draw(canvas: canvas)
        .toList();
  }

  void _paintWithBackground(
    m.Canvas canvas,
    m.Size size,
    pt.Paint paint,
  ) {
    _size = size;

    final drawing = _config.iur.render(model: _modelWrapper._model);

    try {
      assert(
        drawing.walk().whereType<go.BackgroundPicture>().isEmpty,
        'BackgroundPicture found in Drawing which is inconsistent with a Config containing "clearBackground: false".',
      );
    } on AssertionError {
      l.e(
        drawing,
      );
      rethrow;
    }

    final pictures = go.Drawing(
      canvasOps: [
        if (_background != null)
          go.Image(
            image: _background!,
            offset: g.Offset.zero,
            paint: paint,
          ),
        go.BackgroundPicture(
          size: g.Size.fromSize(size),
          canvasOps: [
            if (_background != null)
              go.Image(
                image: _background!,
                offset: g.Offset.zero,
                paint: paint,
              ),
            drawing,
          ],
        ),
      ],
    ).draw(canvas: canvas);
    for (final p in pictures) {
      switch (p) {
        case go.BackgroundPictureType(:final picture):
          picture.toImage(size.width.round(), size.height.round()).then(
            (i) {
              _background = i;
            },
          );
        case go.CanvasPictureType():
          break;
      }
    }
  }

  @override
  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    switch (_config.clearCanvas) {
      case c.ClearCanvas():
        _paint(canvas, size);

      case c.NoClearCanvas(:final paint):
        _paintWithBackground(canvas, size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      this != oldDelegate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _FlossPainter &&
          _size == other._size &&
          _elapsed == other._elapsed &&
          _inputEvents == other._inputEvents &&
          _modelWrapper == other._modelWrapper &&
          _config == other._config;

  @override
  int get hashCode => Object.hash(
        _size,
        _elapsed,
        _inputEvents,
        _modelWrapper,
        _config,
      );
}

class _CanvasTicker<IUR> extends m.StatefulWidget {
  final c.Config _config;
  final m.Size _size;
  final ie.InputEventList _inputEvents;
  final _time = m.ValueNotifier(Duration.zero);

  _CanvasTicker({
    super.key,
    required c.Config config,
    required m.Size size,
    required ie.InputEventList inputEvents,
  })  : _config = config,
        _size = size,
        _inputEvents = inputEvents;

  @override
  m.State<_CanvasTicker> createState() => _CanvasTickerState();
}

class _CanvasTickerState<M> extends m.State<_CanvasTicker>
    with m.SingleTickerProviderStateMixin {
  late final s.Ticker _ticker;
  late final _FlossPainter _painter;

  @override
  void initState() {
    super.initState();
    _painter = _FlossPainter(
      repaint: widget._time,
      config: widget._config,
      size: widget._size,
      elapsed: widget._time,
      inputEvents: widget._inputEvents,
    );

    _ticker = createTicker(_painter._tick);
    _ticker.start();
  }

  @override
  void dispose() {
    widget._time.dispose();
    _ticker.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.RepaintBoundary(
      child: m.ClipRect(
        child: m.CustomPaint(
          size: widget._size,
          isComplex: true,
          willChange: true,
          painter: _painter,
          child: m.Container(),
        ),
      ),
    );
  }
}

class FlossWidget extends m.StatefulWidget {
  final _focusNode = m.FocusNode();
  final _inputEvents = ie.InputEventList(list: []);

  final c.Config _config;

  FlossWidget({
    super.key,
    required c.Config config,
  }) : _config = config;

  @override
  m.State<FlossWidget> createState() => _FlossApp();
}

class _FlossApp extends m.State<FlossWidget>
    with m.SingleTickerProviderStateMixin {
  @override
  void dispose() {
    widget._focusNode.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.KeyboardListener(
      focusNode: widget._focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        widget._inputEvents.list.add(
          ie.KeyEvent(
            event: event,
          ),
        );
      },
      child: m.Listener(
        behavior: m.HitTestBehavior.deferToChild,
        onPointerDown: (event) {
          widget._inputEvents.list.add(
            ie.PointerDown(
              event: event,
            ),
          );
        },
        onPointerMove: (event) {
          widget._inputEvents.list.add(
            ie.PointerMove(
              event: event,
            ),
          );
        },
        onPointerUp: (event) {
          widget._inputEvents.list.add(
            ie.PointerUp(
              event: event,
            ),
          );
        },
        onPointerHover: (event) {
          widget._inputEvents.list.add(
            ie.PointerHover(
              event: event,
            ),
          );
        },
        onPointerCancel: (event) {
          widget._inputEvents.list.add(
            ie.PointerCancel(
              event: event,
            ),
          );
        },
        onPointerPanZoomStart: (event) {
          widget._inputEvents.list.add(
            ie.PointerPanZoomStart(
              event: event,
            ),
          );
        },
        onPointerPanZoomUpdate: (event) {
          widget._inputEvents.list.add(
            ie.PointerPanZoomUpdate(
              event: event,
            ),
          );
        },
        onPointerPanZoomEnd: (event) {
          widget._inputEvents.list.add(
            ie.PointerPanZoomEnd(
              event: event,
            ),
          );
        },
        onPointerSignal: (event) {
          widget._inputEvents.list.add(
            ie.PointerSignal(
              event: event,
            ),
          );
        },
        child: m.GestureDetector(
          behavior: m.HitTestBehavior.deferToChild,
          onTapDown: (details) {
            widget._inputEvents.list.add(
              ie.TapDown(
                details: details,
              ),
            );
          },
          onTapUp: (details) {
            widget._inputEvents.list.add(
              ie.TapUp(
                details: details,
              ),
            );
          },
          onTap: () {
            widget._inputEvents.list.add(
              const ie.Tap(),
            );
          },
          onTapCancel: () {
            widget._inputEvents.list.add(
              const ie.TapCancel(),
            );
          },
          onSecondaryTap: () {
            widget._inputEvents.list.add(
              const ie.SecondaryTap(),
            );
          },
          onSecondaryTapDown: (details) {
            widget._inputEvents.list.add(
              ie.SecondaryTapDown(
                details: details,
              ),
            );
          },
          onSecondaryTapUp: (details) {
            widget._inputEvents.list.add(
              ie.SecondaryTapUp(
                details: details,
              ),
            );
          },
          onSecondaryTapCancel: () {
            widget._inputEvents.list.add(
              const ie.SecondaryTapCancel(),
            );
          },
          onTertiaryTapDown: (details) {
            widget._inputEvents.list.add(
              ie.TertiaryTapDown(
                details: details,
              ),
            );
          },
          onTertiaryTapUp: (details) {
            widget._inputEvents.list.add(
              ie.TertiaryTapUp(
                details: details,
              ),
            );
          },
          onTertiaryTapCancel: () {
            widget._inputEvents.list.add(
              const ie.TertiaryTapCancel(),
            );
          },
          onDoubleTapDown: (details) {
            widget._inputEvents.list.add(
              ie.DoubleTapDown(
                details: details,
              ),
            );
          },
          onDoubleTap: () {
            widget._inputEvents.list.add(
              const ie.DoubleTap(),
            );
          },
          onDoubleTapCancel: () {
            widget._inputEvents.list.add(
              const ie.DoubleTapCancel(),
            );
          },
          onLongPressDown: (details) {
            widget._inputEvents.list.add(
              ie.LongPressDown(
                details: details,
              ),
            );
          },
          onLongPressCancel: () {
            widget._inputEvents.list.add(
              const ie.LongPressCancel(),
            );
          },
          onLongPress: () {
            widget._inputEvents.list.add(
              const ie.LongPress(),
            );
          },
          onLongPressStart: (details) {
            widget._inputEvents.list.add(
              ie.LongPressStart(
                details: details,
              ),
            );
          },
          onLongPressMoveUpdate: (details) {
            widget._inputEvents.list.add(
              ie.LongPressMoveUpdate(
                details: details,
              ),
            );
          },
          onLongPressUp: () {
            widget._inputEvents.list.add(
              const ie.LongPressUp(),
            );
          },
          onLongPressEnd: (details) {
            widget._inputEvents.list.add(
              ie.LongPressEnd(
                details: details,
              ),
            );
          },
          onSecondaryLongPressDown: (details) {
            widget._inputEvents.list.add(
              ie.SecondaryLongPressDown(
                details: details,
              ),
            );
          },
          onSecondaryLongPressCancel: () {
            widget._inputEvents.list.add(
              const ie.SecondaryLongPressCancel(),
            );
          },
          onSecondaryLongPress: () {
            widget._inputEvents.list.add(
              const ie.SecondaryLongPress(),
            );
          },
          onSecondaryLongPressStart: (details) {
            widget._inputEvents.list.add(
              ie.SecondaryLongPressStart(
                details: details,
              ),
            );
          },
          onSecondaryLongPressMoveUpdate: (details) {
            widget._inputEvents.list.add(
              ie.SecondaryLongPressMoveUpdate(
                details: details,
              ),
            );
          },
          onSecondaryLongPressUp: () {
            widget._inputEvents.list.add(
              const ie.SecondaryLongPressUp(),
            );
          },
          onSecondaryLongPressEnd: (details) {
            widget._inputEvents.list.add(
              ie.SecondaryLongPressEnd(
                details: details,
              ),
            );
          },
          onTertiaryLongPressDown: (details) {
            widget._inputEvents.list.add(
              ie.TertiaryLongPressDown(
                details: details,
              ),
            );
          },
          onTertiaryLongPressCancel: () {
            widget._inputEvents.list.add(
              const ie.TertiaryLongPressCancel(),
            );
          },
          onTertiaryLongPress: () {
            widget._inputEvents.list.add(
              const ie.TertiaryLongPress(),
            );
          },
          onTertiaryLongPressStart: (details) {
            widget._inputEvents.list.add(
              ie.TertiaryLongPressStart(
                details: details,
              ),
            );
          },
          onTertiaryLongPressMoveUpdate: (details) {
            widget._inputEvents.list.add(
              ie.TertiaryLongPressMoveUpdate(
                details: details,
              ),
            );
          },
          onTertiaryLongPressUp: () {
            widget._inputEvents.list.add(
              const ie.TertiaryLongPressUp(),
            );
          },
          onTertiaryLongPressEnd: (details) {
            widget._inputEvents.list.add(
              ie.TertiaryLongPressEnd(
                details: details,
              ),
            );
          },
          onForcePressStart: (details) {
            widget._inputEvents.list.add(
              ie.ForcePressStart(
                details: details,
              ),
            );
          },
          onForcePressPeak: (details) {
            widget._inputEvents.list.add(
              ie.ForcePressPeak(
                details: details,
              ),
            );
          },
          onForcePressUpdate: (details) {
            widget._inputEvents.list.add(
              ie.ForcePressUpdate(
                details: details,
              ),
            );
          },
          onForcePressEnd: (details) {
            widget._inputEvents.list.add(
              ie.ForcePressEnd(
                details: details,
              ),
            );
          },
          onScaleStart: (details) {
            widget._inputEvents.list.add(
              ie.ScaleStart(
                details: details,
              ),
            );
          },
          onScaleUpdate: (details) {
            widget._inputEvents.list.add(
              ie.ScaleUpdate(
                details: details,
              ),
            );
          },
          onScaleEnd: (details) {
            widget._inputEvents.list.add(
              ie.ScaleEnd(
                details: details,
              ),
            );
          },
          child: m.LayoutBuilder(
            builder: (context, constraints) {
              return _CanvasTicker(
                size: constraints.biggest,
                inputEvents: widget._inputEvents,
                config: widget._config,
              );
            },
          ),
        ),
      ),
    );
  }
}
