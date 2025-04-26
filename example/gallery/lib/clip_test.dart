import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

class _Model {
  final ui.Size size;
  final f.InputEventList inputEvents;
  _Model({required this.size, required this.inputEvents});

  _Model.update({required this.size, required this.inputEvents});
}

class _ClipTestIud<M> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    return _Model.update(size: size, inputEvents: inputEvents) as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    return f.Drawing(
      ops: [
        f.ClipPath(
          path:
              ui.Path()..addOval(
                ui.Rect.fromCircle(center: ui.Offset(100, 100), radius: 50),
              ),
          ops: [
            f.Rect(
              rect: ui.Rect.fromCenter(
                center: ui.Offset(0.0, 0.0),
                width: 200.0,
                height: 200.0,
              ),
              paint: ui.Paint()..color = const ui.Color(0xFF00FF00),
            ),
            f.Oval(
              rect: ui.Rect.fromCenter(
                center: ui.Offset(125.0, 125.0),
                width: 300.0,
                height: 100.0,
              ),
              paint: ui.Paint()..color = const ui.Color(0xFFFF0000),
            ),
          ],
        ),
        f.ClipRect(
          rect: ui.Rect.fromCenter(
            center: ui.Offset(400.0, 400.0),
            width: 100.0,
            height: 100.0,
          ),
          clipOp: ui.ClipOp.intersect,
          ops: [
            f.Rect(
              rect: ui.Rect.fromCenter(
                center: ui.Offset(400.0, 400.0),
                width: 200.0,
                height: 200.0,
              ),
              paint: ui.Paint()..color = const ui.Color(0xFF0000FF),
            ),
            f.Circle(
              center: ui.Offset(450.0, 450.0),
              radius: 100.0,
              paint: ui.Paint()..color = const ui.Color(0xFFFF0000),
            ),
          ],
        ),
        f.ClipRRect(
          rrect: ui.RRect.fromRectAndRadius(
            ui.Rect.fromCenter(
              center: ui.Offset(500.0, 200.0),
              width: 100.0,
              height: 100.0,
            ),
            const ui.Radius.circular(20.0),
          ),
          ops: [
            f.Rect(
              rect: ui.Rect.fromCenter(
                center: ui.Offset(500.0, 200.0),
                width: 200.0,
                height: 200.0,
              ),
              paint: ui.Paint()..color = const ui.Color(0xFFFF0000),
            ),
            f.Circle(
              center: ui.Offset(550.0, 250.0),
              radius: 100.0,
              paint: ui.Paint()..color = const ui.Color(0xFF0000FF),
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  w.runApp(
    w.WidgetsApp(
      color: const w.Color(0xFF000000),
      builder: (context, child) {
        return f.FlossWidget(
          focusNode: w.FocusNode(),
          config: f.Config(
            modelCtor: _Model.new,
            iud: _ClipTestIud<_Model>(),
            clearCanvas: const f.ClearCanvas(),
          ),
        );
      },
    ),
  );
}
