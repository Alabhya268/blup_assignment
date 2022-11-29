import 'package:edi/constants/constant_ui.dart';
import 'package:flutter/material.dart';

import '../widgets/drag_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/draggable-test';

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ValueNotifier<List<Offset>> dragOffsets = ValueNotifier([]);
  List<String> texts = [];
  TextEditingController textEditingController = TextEditingController();
  List<GlobalKey<DragWidgetState>> globalKeys = [];
  List<String> renderId = [];
  bool dragging = false;
  Offset p1 = Offset.zero;
  Offset p2 = Offset.zero;

  void fixOffsets({
    required Offset offset1,
    required Offset offset2,
  }) {
    double minx = (offset1.dx - offset2.dx).abs();
    double miny = (offset1.dy - offset2.dy).abs();
    setState(() {
      if (minx < miny) {
        p1 = Offset(offset1.dx, offset1.dy);
        p2 = Offset(offset1.dx, offset2.dy);
      } else {
        p1 = Offset(offset1.dx, offset1.dy);
        p2 = Offset(offset2.dx, offset1.dy);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          for (int index = 0; index < dragOffsets.value.length; index++) ...[
            ValueListenableBuilder<List<Offset>>(
              valueListenable: dragOffsets,
              builder: (context, value, child) => Positioned(
                left: dragOffsets.value[index].dx,
                top: dragOffsets.value[index].dy,
                child: Container(
                  decoration: dragging
                      ? BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        )
                      : const BoxDecoration(),
                  child: DragWidget(
                    dragOffsets: dragOffsets,
                    key: globalKeys[index],
                    globalKeys: globalKeys,
                    inputText: texts[index],
                    curerntIndex: index,
                    onDrag: (Offset offset, bool drag) {
                      setState(() {
                        dragOffsets.value[index] = offset;
                        dragging = drag;
                      });
                    },
                    onDragEnd: (drag) {
                      setState(() {
                        dragging = false;
                      });
                    },
                    paintCoord: (
                      Offset min1,
                      Offset min2,
                    ) {
                      fixOffsets(
                        offset1: min2,
                        offset2: min1,
                      );
                    },
                  ),
                ),
              ),
            ),
            if (dragging &&
                ((p1.dx - p2.dx).abs() < 100 && (p1.dy - p2.dy).abs() < 100))
              CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: MyPainter(
                  p1: p1,
                  p2: p2,
                ),
              ),
          ]
        ],
      ),
      floatingActionButton: floatingButtonWidget(context),
    );
  }

  FloatingActionButton floatingButtonWidget(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add Text'),
              content: TextField(
                controller: textEditingController,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    textEditingController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (textEditingController.text.isNotEmpty) {
                      texts.add(textEditingController.text);
                      textEditingController.clear();
                      setState(() {
                        dragOffsets.value.add(const Offset(100, 100));
                        globalKeys.add(GlobalKey<DragWidgetState>());
                        renderId.add(renderId.length.toString());
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

class MyPainter extends CustomPainter {
  final Offset p1;
  final Offset p2;

  MyPainter({
    required this.p1,
    required this.p2,
  });
  //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ConstantUi.guildLineColor
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
