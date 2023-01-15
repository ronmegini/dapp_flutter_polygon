import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ArtPainter extends CustomPainter {
  ArtWork artWork;
  ArtPainter(this.artWork);
  @override
  void paint(Canvas canvas, Size size) {
    drawArt(artWork, canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Future<Uint8List> getPng(ArtWork artWork) async {
  ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  Canvas canvas = Canvas(pictureRecorder,
      Rect.fromLTWH(0, 0, artWork.artSize.width, artWork.artSize.height));
  drawArt(artWork, canvas, artWork.artSize);
  final ui.Picture picture = pictureRecorder.endRecording();
  ui.Image img = await picture.toImage(
      artWork.artSize.width.toInt(), artWork.artSize.height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData!.buffer.asUint8List();
  return pngBytes;
}

void drawArt(ArtWork artWork, Canvas canvas, Size size) {
  canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
  List<Color> colorValues = Colors.primaries;
  Color bgColor = colorValues[artWork.backgroundIndex];
  canvas.drawColor(bgColor, BlendMode.src);
  Offset center = Offset(size.width / 2, size.height / 2);
  double radius = size.width * artWork.radiusIndex.toDouble() / 20.0;
  Color fgColor = colorValues[artWork.forgroundIndex];
  Paint paint = Paint()..color = fgColor;
  canvas.drawCircle(center, radius, paint);
}

class ArtWork {
  String title;
  Size artSize;
  int backgroundIndex;
  int forgroundIndex;
  int radiusIndex;

  ArtWork(
      {this.title = 'Generate art',
      this.artSize = const Size(500, 1000),
      this.backgroundIndex = 0,
      this.forgroundIndex = 2,
      this.radiusIndex = 5});
}
