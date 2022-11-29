import 'package:edi/constants/constant_ui.dart';
import 'package:edi/utils/utils.dart';
import 'package:flutter/material.dart';

class DragWidget extends StatefulWidget {
  final void Function(Offset, bool) onDrag;
  final void Function(bool) onDragEnd;
  final void Function(Offset, Offset) paintCoord;
  final String inputText;
  final int curerntIndex;
  final List<GlobalKey<DragWidgetState>> globalKeys;
  final ValueNotifier<List<Offset>> dragOffsets;

  const DragWidget({
    super.key,
    required this.onDrag,
    required this.inputText,
    required this.globalKeys,
    required this.dragOffsets,
    required this.curerntIndex,
    required this.paintCoord,
    required this.onDragEnd,
  });

  @override
  State<DragWidget> createState() => DragWidgetState();
}

class DragWidgetState extends State<DragWidget> {
  bool dragging = false;

  void findMinDist(double minDist) {
    for (int i = 0; i < widget.globalKeys.length; i++) {
      if (i == widget.curerntIndex) continue;
      Size cur = widget.globalKeys[widget.curerntIndex].currentContext!.size!;
      Size next = widget.globalKeys[i].currentContext!.size!;
      Offset curOff = widget.dragOffsets.value[widget.curerntIndex];
      Offset nextOff = widget.dragOffsets.value[i];
      late Offset min1 = Offset.zero;
      late Offset min2 = Offset.zero;

      double a =
          Utils.findDistance(cur.topLeft(curOff), next.topRight(nextOff));
      double b =
          Utils.findDistance(cur.topLeft(curOff), next.bottomLeft(nextOff));
      double c =
          Utils.findDistance(cur.topLeft(curOff), next.bottomRight(nextOff));

      if (a < b) {
        if (a < c) {
          if (a < minDist) {
            minDist = a;
            min1 = cur.topLeft(curOff);
            min2 = next.topRight(nextOff);
          }
        } else {
          if (c < minDist) {
            minDist = c;
            min1 = cur.topLeft(curOff);
            min2 = next.bottomRight(nextOff);
          }
        }
      } else {
        if (b < c) {
          if (b < minDist) {
            minDist = b;
            min1 = cur.topLeft(curOff);
            min2 = next.bottomLeft(nextOff);
          }
        } else {
          if (c < minDist) {
            minDist = c;
            min1 = cur.topLeft(curOff);
            min2 = next.bottomRight(nextOff);
          }
        }
      }

      a = Utils.findDistance(cur.topRight(curOff), next.topLeft(nextOff));
      b = Utils.findDistance(cur.topRight(curOff), next.bottomLeft(nextOff));
      c = Utils.findDistance(cur.topRight(curOff), next.bottomRight(nextOff));

      if (a < b) {
        if (a < c) {
          if (a < minDist) {
            minDist = a;
            min1 = cur.topRight(curOff);
            min2 = next.topLeft(nextOff);
          }
        } else {
          if (c < minDist) {
            minDist = c;
            min1 = cur.topRight(curOff);
            min2 = next.bottomRight(nextOff);
          }
        }
      } else {
        if (b < c) {
          if (b < minDist) {
            minDist = b;
            min1 = cur.topRight(curOff);
            min2 = next.bottomLeft(nextOff);
          }
        } else {
          if (c < minDist) {
            minDist = c;
            min1 = cur.topRight(curOff);
            min2 = next.bottomRight(nextOff);
          }
        }
      }

      a = Utils.findDistance(cur.bottomLeft(curOff), next.topLeft(nextOff));
      b = Utils.findDistance(cur.bottomLeft(curOff), next.topRight(nextOff));
      c = Utils.findDistance(cur.bottomLeft(curOff), next.bottomRight(nextOff));

      if (a < b) {
        if (a < c) {
          if (a < minDist) {
            minDist = a;
            min1 = cur.bottomLeft(curOff);
            min2 = next.topLeft(nextOff);
          }
        } else {
          if (c < minDist) {
            minDist = c;
            min1 = cur.bottomLeft(curOff);
            min2 = next.bottomRight(nextOff);
          }
        }
      } else {
        if (b < c) {
          if (b < minDist) {
            minDist = b;
            min1 = cur.bottomLeft(curOff);
            min2 = next.topRight(nextOff);
          }
        } else {
          if (c < minDist) {
            minDist = c;
            min1 = cur.bottomLeft(curOff);
            min2 = next.bottomRight(nextOff);
          }
        }
      }

      a = Utils.findDistance(cur.bottomRight(curOff), next.topLeft(nextOff));
      b = Utils.findDistance(cur.bottomRight(curOff), next.topRight(nextOff));
      c = Utils.findDistance(cur.bottomRight(curOff), next.bottomLeft(nextOff));

      if (a < b) {
        if (a < c) {
          if (a < minDist) {
            minDist = a;
            min1 = cur.bottomRight(curOff);
            min2 = next.topLeft(nextOff);
          }
        } else {
          if (c < minDist) {
            minDist = c;
            min1 = cur.bottomRight(curOff);
            min2 = next.bottomLeft(nextOff);
          }
        }
      } else {
        if (b < c) {
          if (b < minDist) {
            minDist = b;
            min1 = cur.bottomRight(curOff);
            min2 = next.topRight(nextOff);
          }
        } else {
          if (c < minDist) {
            minDist = c;
            min1 = cur.bottomRight(curOff);
            min2 = next.bottomLeft(nextOff);
          }
        }
      }

      if (min1 != Offset.zero && min2 != Offset.zero) {
        widget.paintCoord(min1, min2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressMoveUpdate: ((details) {
        widget.onDrag(details.globalPosition, true);
        setState(() {
          dragging = true;
        });
        double minDist = 100000;
        findMinDist(minDist);
      }),
      onLongPressEnd: (details) {
        widget.onDragEnd(false);
        setState(() {
          dragging = false;
        });
      },
      child: Text(
        widget.inputText,
        style: ConstantUi.textStyle1,
      ),
    );
  }
}
