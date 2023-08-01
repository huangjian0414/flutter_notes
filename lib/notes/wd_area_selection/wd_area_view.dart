import 'package:flutter/material.dart';
import 'wd_area_selection_defines.dart';
import 'manager/wd_area_manager.dart';

class WDAreaView extends StatefulWidget {
  WDAreaView(
      {Key? key,
      required this.child,
      this.areaManager,
      this.onDoubleTap,
      this.refreshCallback})
      : super(key: key);

  Widget child;
  WDAreaSelectionProtocol? areaManager;
  GestureTapCallback? onDoubleTap;

  ///需要刷新的回调，外界刷新
  VoidCallback? refreshCallback;

  @override
  State<WDAreaView> createState() => _WDAreaViewState();
}

class _WDAreaViewState extends State<WDAreaView> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (detail) {
        WDAreaLog(
            'onPointerDown-- ${detail.position} - ${detail.localPosition} -'
            ' - ${widget.areaManager}');
        if (widget.areaManager != null) {
          widget.areaManager!.pointerDownAction(detail,
              refreshCallback: widget.refreshCallback);
        }
      },
      onPointerUp: (event) {
        WDAreaLog('onPointerUp -- ${widget.areaManager}');
        if (widget.areaManager != null) {
          widget.areaManager!
              .pointerUpAction(refreshCallback: widget.refreshCallback);
        }
      },
      onPointerMove: (detail) {
        WDAreaLog(
            'onPointerMove-- ${detail.position} - ${detail.localPosition}'
            ' - ${detail.localDelta} - ${widget.areaManager}');
        if (widget.areaManager != null) {
          widget.areaManager!.pointerMoveAction(detail,
              refreshCallback: widget.refreshCallback);
        }
      },
      child: GestureDetector(
        onDoubleTap: widget.onDoubleTap,
        child: widget.child,
      ),
    );
  }
}
