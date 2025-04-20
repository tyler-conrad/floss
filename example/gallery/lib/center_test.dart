import 'dart:math' as math;
import 'dart:typed_data' as td;
import 'dart:ui' as ui;

import 'package:flutter/services.dart' as s;
import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

Future<ui.Image> loadImage(String path) async {
  final byteData = await s.rootBundle.load(path);
  final buffer = byteData.buffer.asUint8List();
  return p.decodeImageFromList(buffer);
}

class _Model {
  static const gridResX = 12;
  static const gridResY = 12;

  ui.Image? image;

  ui.Size size;
  f.InputEventList inputEvents;

  _Model({required this.size, required this.inputEvents}) {
    loadImage(
      'assets/test_image.jpg',
    ).then((i) => {print('Image loaded: $i'), image = i});
  }

  void update({required size, required inputEvents, required image}) {
    this.size = size;
    this.inputEvents = inputEvents;
    this.image = image;
  }
}

Iterable<ui.Rect> _gridRects({
  required ui.Size size,
  required int gridResX,
  required int gridResY,
}) sync* {
  final stepX = size.width / gridResX;
  final stepY = size.height / gridResY;
  for (int y = 0; y < gridResY; y++) {
    for (int x = 0; x < gridResX; x++) {
      if (((y % 2) + (x % 2)) % 2 == 0) {
        yield ui.Rect.fromLTWH(x * stepX, y * stepY, stepX, stepY);
      }
    }
  }
}

Iterable<f.CanvasOp> _positionedCanvasOps({
  required ui.Image? image,
  required ui.Size size,
  required int gridResX,
  required int gridResY,
}) sync* {
  final stepX = size.width / gridResX;
  final stepY = size.height / gridResY;

  int index = 0;
  for (int y = 0; y < gridResY; y += 2) {
    for (int x = 0; x < gridResX; x += 2) {
      final centerX = x * stepX + stepX;
      final centerY = y * stepY + stepY;
      final hue =
          (1080.0 * (index / ((gridResX ~/ 2) * (gridResY ~/ 2)))) % 360.0;
      yield switch (index) {
        0 => f.Arc(
          rect: ui.Rect.fromLTWH(centerX, centerY, stepX, stepY),
          startAngle: 0.0,
          sweepAngle: math.pi,
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        1 => f.Arc(
          rect: ui.Rect.fromCenter(
            center: ui.Offset(centerX, centerY),
            width: stepX,
            height: stepY,
          ),
          startAngle: 0.0,
          sweepAngle: math.pi,
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        2 => f.Circle(
          center: ui.Offset(centerX + stepX * 0.5, centerY + stepY * 0.5),
          radius: stepX * 0.5,
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        3 => f.Circle(
          center: ui.Offset(centerX, centerY),
          radius: stepX * 0.5,
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        4 => f.DRRect(
          outer: ui.RRect.fromRectXY(
            ui.Rect.fromLTWH(centerX, centerY, stepX, stepY),
            stepX * 0.2,
            stepY * 0.2,
          ),
          inner: ui.RRect.fromRectXY(
            ui.Rect.fromLTWH(
              centerX + stepX * 0.25,
              centerY + stepY * 0.25,
              stepX * 0.5,
              stepY * 0.5,
            ),
            stepX * 0.1,
            stepY * 0.1,
          ),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        5 => f.DRRect(
          outer: ui.RRect.fromRectXY(
            ui.Rect.fromCenter(
              center: ui.Offset(centerX, centerY),
              width: stepX,
              height: stepY,
            ),
            stepX * 0.2,
            stepY * 0.2,
          ),
          inner: ui.RRect.fromRectXY(
            ui.Rect.fromCenter(
              center: ui.Offset(centerX, centerY),
              width: stepX * 0.5,
              height: stepY * 0.5,
            ),
            stepX * 0.1,
            stepY * 0.1,
          ),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        6 when image != null => f.Image(
          image: image,
          offset: ui.Offset(centerX, centerY),
          paint: p.Paint(),
        ),
        7 when image != null => f.Image(
          image: image,
          offset: ui.Offset(
            centerX - image.width * 0.5,
            centerY - image.height * 0.5,
          ),
          paint: p.Paint(),
        ),
        8 when image != null => f.ImageNine(
          image: image,
          center: ui.Rect.fromLTWH(16.0, 16.0, 32.0, 32.0),
          dst: ui.Rect.fromLTWH(centerX, centerY, stepX, stepY),
          paint: p.Paint(),
        ),
        9 when image != null => f.ImageNine(
          image: image,
          center: ui.Rect.fromLTWH(16.0, 16.0, 32.0, 32.0),
          dst: ui.Rect.fromCenter(
            center: ui.Offset(centerX, centerY),
            width: stepX,
            height: stepY,
          ),
          paint: p.Paint(),
        ),
        10 when image != null => f.ImageRect(
          image: image,
          src: ui.Rect.fromLTWH(
            0.0,
            0.0,
            image.width.toDouble(),
            image.height.toDouble(),
          ),
          dst: ui.Rect.fromLTWH(centerX, centerY, stepX, stepY),
          paint: p.Paint(),
        ),
        11 when image != null => f.ImageRect(
          image: image,
          src: ui.Rect.fromLTWH(
            0.0,
            0.0,
            image.width.toDouble(),
            image.height.toDouble(),
          ),
          dst: ui.Rect.fromCenter(
            center: ui.Offset(centerX, centerY),
            width: stepX,
            height: stepY,
          ),
          paint: p.Paint(),
        ),
        12 => f.Line(
          p1: ui.Offset(centerX, centerY),
          p2: ui.Offset(centerX + stepX, centerY + stepY),
          paint:
              p.Paint()
                ..strokeWidth = 8.0
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        13 => f.Line(
          p1: ui.Offset(centerX + stepX * 0.5, centerY + stepY * 0.5),
          p2: ui.Offset(centerX + stepX, centerY + stepY),
          paint:
              p.Paint()
                ..strokeWidth = 8.0
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        14 => f.Oval(
          rect: ui.Rect.fromLTWH(centerX, centerY, stepX, stepY),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        15 => f.Oval(
          rect: ui.Rect.fromCenter(
            center: ui.Offset(centerX, centerY),
            width: stepX,
            height: stepY,
          ),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),

        16 => f.Paragraph(
          paragraph:
              (ui.ParagraphBuilder(
                      ui.ParagraphStyle(textAlign: ui.TextAlign.left),
                    )
                    ..pushStyle(
                      ui.TextStyle(
                        color:
                            p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
                        fontSize: 14.0,
                      ),
                    )
                    ..addText(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing '
                      'elit. Sed do eiusmod tempor incididunt ut labore et '
                      'dolore magna aliqua.',
                    ))
                  .build()
                ..layout(ui.ParagraphConstraints(width: stepX)),
          offset: ui.Offset(centerX, centerY),
        ),
        17 => f.Paragraph(
          paragraph:
              (ui.ParagraphBuilder(
                      ui.ParagraphStyle(textAlign: ui.TextAlign.center),
                    )
                    ..pushStyle(
                      ui.TextStyle(
                        color:
                            p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
                        fontSize: 14.0,
                      ),
                    )
                    ..addText(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing '
                      'elit. Sed do eiusmod tempor incididunt ut labore et '
                      'dolore magna aliqua.',
                    ))
                  .build()
                ..layout(ui.ParagraphConstraints(width: stepX)),
          offset: ui.Offset(centerX - stepX * 0.5, centerY - stepY * 0.5),
        ),
        18 => f.Path(
          path:
              ui.Path()
                ..addRect(ui.Rect.fromLTWH(centerX, centerY, stepX, stepY)),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        19 => f.Path(
          path:
              ui.Path()..addRect(
                ui.Rect.fromCenter(
                  center: ui.Offset(centerX, centerY),
                  width: stepX,
                  height: stepY,
                ),
              ),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        20 => f.Points(
          pointMode: ui.PointMode.points,
          points: [
            ui.Offset(centerX, centerY),
            ui.Offset(centerX + stepX, centerY + stepY),
          ],
          paint:
              p.Paint()
                ..strokeWidth = 8.0
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        21 => f.Points(
          pointMode: ui.PointMode.points,
          points: [
            ui.Offset(centerX + stepX * 0.5, centerY + stepY * 0.5),
            ui.Offset(centerX + stepX, centerY + stepY),
          ],
          paint:
              p.Paint()
                ..strokeWidth = 8.0
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        22 => f.RawPoints(
          pointMode: ui.PointMode.points,
          points: td.Float32List.fromList([
            centerX,
            centerY,
            centerX + stepX,
            centerY + stepY,
          ]),
          paint:
              p.Paint()
                ..strokeWidth = 8.0
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        23 => f.RawPoints(
          pointMode: ui.PointMode.points,
          points: td.Float32List.fromList([
            centerX + stepX * 0.5,
            centerY + stepY * 0.5,
            centerX + stepX,
            centerY + stepY,
          ]),
          paint:
              p.Paint()
                ..strokeWidth = 8.0
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        24 => f.Rect(
          rect: ui.Rect.fromLTWH(centerX, centerY, stepX, stepY),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        25 => f.Rect(
          rect: ui.Rect.fromCenter(
            center: ui.Offset(centerX, centerY),
            width: stepX,
            height: stepY,
          ),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        26 => f.RRect(
          rrect: ui.RRect.fromRectXY(
            ui.Rect.fromLTWH(centerX, centerY, stepX, stepY),
            stepX * 0.2,
            stepY * 0.2,
          ),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        27 => f.RRect(
          rrect: ui.RRect.fromRectXY(
            ui.Rect.fromCenter(
              center: ui.Offset(centerX, centerY),
              width: stepX,
              height: stepY,
            ),
            stepX * 0.2,
            stepY * 0.2,
          ),
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        28 => f.Shadow(
          color: p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
          elevation: 4.0,
          path:
              ui.Path()..addRect(
                ui.Rect.fromLTWH(
                  centerX + 4.0,
                  centerY,
                  stepX - 8.0,
                  stepY - 8.0,
                ),
              ),
        ),
        29 => f.Shadow(
          color: p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
          elevation: 4.0,
          path:
              ui.Path()..addRect(
                ui.Rect.fromCenter(
                  center: ui.Offset(centerX, centerY),
                  width: stepX + 4.0,
                  height: stepY + 4.0,
                ),
              ),
        ),
        30 => f.Vertices(
          vertices: ui.Vertices(ui.VertexMode.triangles, [
            ui.Offset(centerX, centerY),
            ui.Offset(centerX + stepX, centerY),
            ui.Offset(centerX, centerY + stepY),
          ], indices: td.Uint16List.fromList([0, 1, 2])),
          blendMode: ui.BlendMode.dstIn,
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        31 => f.Vertices(
          vertices: ui.Vertices(ui.VertexMode.triangles, [
            ui.Offset(centerX + stepX * 0.5, centerY + stepY * 0.5),
            ui.Offset(centerX + stepX, centerY + stepY * 0.5),
            ui.Offset(centerX + stepX * 0.5, centerY + stepY),
          ], indices: td.Uint16List.fromList([0, 1, 2])),
          blendMode: ui.BlendMode.dstIn,
          paint:
              p.Paint()
                ..color = p.HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor(),
        ),
        _ => f.Drawing(ops: []),
      };
      index++;
    }
  }
}

class _CenterTestIud<M extends _Model> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M init({
    required f.ModelCtor<M> modelCtor,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    return modelCtor(size: size, inputEvents: inputEvents);
  }

  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.update(size: size, inputEvents: inputEvents, image: model.image);
    return model;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) {
    return f.Drawing(
      ops: [
        ..._gridRects(
          size: model.size,
          gridResX: _Model.gridResX,
          gridResY: _Model.gridResY,
        ).map(
          (rect) => f.Rect(
            rect: rect,
            paint: p.Paint()..color = const p.Color.fromARGB(255, 31, 31, 31),
          ),
        ),
        ..._positionedCanvasOps(
          image: model.image,
          size: model.size,
          gridResX: _Model.gridResX,
          gridResY: _Model.gridResY,
        ),
      ],
    );
  }
}

void main() {
  w.runApp(
    w.WidgetsApp(
      color: const p.HSVColor.fromAHSV(1.0, 240.0, 1.0, 0.5).toColor(),
      builder: (context, child) {
        return f.FlossWidget(
          focusNode: w.FocusNode(),
          config: f.Config(
            modelCtor: _Model.new,
            iud: _CenterTestIud<_Model>(),
            clearCanvas: const f.ClearCanvas(),
          ),
        );
      },
    ),
  );
}
