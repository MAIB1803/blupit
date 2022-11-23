import 'dart:io';
import 'dart:ui';
import 'package:blupit/models/text_info.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:blupit/widgets/edit_image_viewmodel.dart';
import 'package:blupit/widgets/image_text.dart';
import 'package:screenshot/screenshot.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({Key? key, required this.selectedImage})
      : super(key: key);
  final String selectedImage;
  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
  ];
  List<DrawingPoint?> drawingPoints = [];
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        appBar: _appBar,
        body: Screenshot(
          controller: screenshotController,
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              child: Stack(
                children: [
                  _selectedImage,
                  GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        drawingPoints.add(
                          DrawingPoint(
                            details.localPosition,
                            Paint()
                              ..color = selectedColor
                              ..isAntiAlias = true
                              ..strokeWidth = strokeWidth
                              ..strokeCap = StrokeCap.round,
                          ),
                        );
                      });
                    },
                    onPanStart: (details) {
                      setState(() {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        drawingPoints.add(
                          DrawingPoint(
                              details.globalPosition,
                              Paint()
                                ..color = selectedColor
                                ..isAntiAlias = true
                                ..strokeWidth = strokeWidth
                                ..strokeCap = StrokeCap.round),
                        );
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        drawingPoints.add(null);
                      });
                    },
                    child: CustomPaint(
                      painter: _DrawingPainter(drawingPoints: drawingPoints),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  for (int i = 0; i < texts.length; i++)
                    Positioned(
                      left: texts[i].left,
                      top: texts[i].top,
                      child: GestureDetector(
                        onLongPress: () {
                          setState(() {
                            currentIndex = i;
                            removeText(context);
                          });
                        },
                        onTap: () => setCurrentIndex(context, i),
                        child: CustomPaint(
                          child: Draggable(
                            feedback: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.0, color: Colors.pink),
                              ),
                              child: ImageText(textInfo: texts[i]),
                            ),
                            child: ImageText(textInfo: texts[i]),
                            onDragEnd: (drag) {
                              final renderBox =
                                  context.findRenderObject() as RenderBox;
                              Offset off = renderBox.globalToLocal(drag.offset);

                              print(texts[i].top);
                              setState(() {
                                texts[i].top = off.dy - 85;
                                texts[i].left = off.dx;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  creatorText.text.isNotEmpty
                      ? Positioned(
                          left: 0,
                          bottom: 0,
                          child: Text(
                            creatorText.text,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 203, 51, 51)
                                    .withOpacity(
                                  0.3,
                                )),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _addnewTextFab,
                IconButton(
                  icon: const Icon(
                    Icons.save,
                    color: Colors.black,
                  ),
                  onPressed: () => saveToGallery(context),
                  tooltip: 'Save Image',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: increaseFontSize,
                  tooltip: 'Increase font size',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                  onPressed: decreaseFontSize,
                  tooltip: 'Decrease font size',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_align_left,
                    color: Colors.black,
                  ),
                  onPressed: alignLeft,
                  tooltip: 'Align left',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_align_center,
                    color: Colors.black,
                  ),
                  onPressed: alignCenter,
                  tooltip: 'Align Center',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_align_right,
                    color: Colors.black,
                  ),
                  onPressed: alignRight,
                  tooltip: 'Align Right',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_bold,
                    color: Colors.black,
                  ),
                  onPressed: boldText,
                  tooltip: 'Bold',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_italic,
                    color: Colors.black,
                  ),
                  onPressed: italicText,
                  tooltip: 'Italic',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.space_bar,
                    color: Colors.black,
                  ),
                  onPressed: addLinesToText,
                  tooltip: 'Add New Line',
                ),
                Tooltip(
                  message: 'Red',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.red),
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'White',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.white),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Black',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.black),
                      child: const CircleAvatar(
                        backgroundColor: Colors.black,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Blue',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.blue),
                      child: const CircleAvatar(
                        backgroundColor: Colors.blue,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Yellow',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.yellow),
                      child: const CircleAvatar(
                        backgroundColor: Colors.yellow,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Green',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.green),
                      child: const CircleAvatar(
                        backgroundColor: Colors.green,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Orange',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.orange),
                      child: const CircleAvatar(
                        backgroundColor: Colors.orange,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Pink',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.pink),
                      child: const CircleAvatar(
                        backgroundColor: Colors.pink,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }

  Widget get _selectedImage => Center(
        child: Image.file(
          File(
            widget.selectedImage,
          ),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
      );

  Widget get _addnewTextFab => TextButton(
        onPressed: () => addNewDialog(context),
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      );

  AppBar get _appBar => AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    Slider(
                      min: 0,
                      max: 50,
                      value: strokeWidth,
                      onChanged: (val) => setState(() => strokeWidth = val),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => drawingPoints = []),
                      icon: const Icon(Icons.clear),
                      label: const Text("Clear Board"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    colors.length,
                    (index) => _buildColorChose(colors[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _DrawingPainter extends CustomPainter {
  _DrawingPainter({required this.drawingPoints});
  List<DrawingPoint?> drawingPoints;
  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 1; i < drawingPoints.length; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i]!.offset);
        canvas.drawPoints(
            PointMode.lines, offsetsList, drawingPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
