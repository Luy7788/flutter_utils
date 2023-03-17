import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Widget Util.
/// 适用于RenderBox
class WidgetUtil {
  bool _hasMeasured = false;
  double _width = 0;
  double _height = 0;

  /// Widget渲染监听.获取大小
  /// context: context.
  /// isOnce: 是否只监听一次
  /// onCallBack:  callBack.
  void asyncPrepare(
      BuildContext context,
      bool isOnce,
      ValueChanged<Rect> onCallBack,
      {
        bool? isSliver,
      }) {
    if (_hasMeasured) return;
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (isSliver == true) {
        RenderSliver? sliver = getRenderSliver(context);
        if (sliver != null) {
          if (isOnce) _hasMeasured = true;
          double width = sliver.semanticBounds.width;
          double height = sliver.semanticBounds.height;
          if (_width != width || _height != height) {
            _width = width;
            _height = height;
            onCallBack(sliver.semanticBounds);
          }
        }
      } else {
        RenderBox? box = getRenderBox(context);
        if (box != null) {
          if (isOnce) _hasMeasured = true;
          double width = box.semanticBounds.width;
          double height = box.semanticBounds.height;
          if (_width != width || _height != height) {
            _width = width;
            _height = height;
            onCallBack(box.semanticBounds);
          }
        }
      }
    });
  }

  /// Widget渲染监听
  void asyncPrepares(
    bool isOnce,
    ValueChanged<void> onCallBack,
  ) {
    if (_hasMeasured) return;
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (isOnce) _hasMeasured = true;
      onCallBack(null);
    });
  }

  ///获取widget在屏幕上的坐标, widget必须渲染完成
  static Offset getWidgetLocalToGlobal(BuildContext context) {
    RenderBox? box = getRenderBox(context);
    return box == null ? Offset.zero : box.localToGlobal(Offset.zero);
  }

  ///获取widget Rect,必须渲染完成
  static Rect getWidgetBounds(BuildContext context) {
    RenderBox box = getRenderBox(context)!;
    return box.semanticBounds;
  }

  ///获取RenderBox
  static RenderBox? getRenderBox(BuildContext context) {
    RenderObject? renderObject = context.findRenderObject();
    RenderBox? box;
    if (renderObject != null) {
      box = renderObject as RenderBox;
    }
    return box;
  }

  static RenderSliver? getRenderSliver(BuildContext context) {
    RenderObject? renderObject = context.findRenderObject();
    RenderSliver? sliver;
    if (renderObject != null) {
      sliver = renderObject as RenderSliver;
    }
    return sliver;
  }

  ///获取两个weidget的相对位置
  ///fatherKey 传入父类对应的GlobalKey
  ///childKey 传入之类对应的GlobalKey
  static Offset getRenderBoxPosition({required GlobalKey fatherKey, required GlobalKey childKey,}) {
    RenderBox fatherBox = fatherKey.currentContext!.findRenderObject() as RenderBox;
    RenderBox childBox = childKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = childBox.localToGlobal(Offset.zero, ancestor: fatherBox);
    return offset;
  }

}
