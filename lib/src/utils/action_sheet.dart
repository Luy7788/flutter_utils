import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

///从屏幕底部弹出
class ActionSheet {
  static const double _itemH = 50.0;

  ///自定义视图
  static Future showCustom({
    required BuildContext context,
    Widget? child,
    bool enableDrag = true,
    ShapeBorder? shape,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet(
      context: context,
      enableDrag: enableDrag,
      shape: shape,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return child!;
      },
    );
  }

  static Future showListView({
    required BuildContext context,
    Widget? child,
    bool enableDrag = true,
    Color? barrierColor,
    double? closeProgressThreshold,
    Duration? duration,
    bool expand = false,
    bool bounce = true,
  }) {
    return showCupertinoModalBottomSheet(
      context: context,
      expand: expand,
      // animationCurve: Curves.linear,
      duration: duration ?? const Duration(milliseconds: 200),
      closeProgressThreshold: closeProgressThreshold ?? 0.8,
      bounce: bounce,
      enableDrag: enableDrag,
      // backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      builder: (BuildContext context) => Material(
        child: child ?? Container(),
      ),
    );
  }

  ///默认样式，根据titles生成，底部弹窗
  static Future showDefault(
    BuildContext context, {
    List<String>? titles,
    void Function(String title)? onTap,
    bool enableDrag = true,
    bool useRootNavigator = false,
    bool isDismissible = true,
  }) {
    List<Widget> itemList(List<String> titleList) {
      List list = titleList
          .map((item) => actionSubItem(item, context, onTap, _itemH))
          .toList();
      return list as List<Widget>;
    }

    return showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      duration: const Duration(milliseconds: 200),
      // closeProgressThreshold: 0.8,
      bounce: false,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      topRadius: Radius.zero,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        final double height = _itemH * titles!.length + (titles.length + 1);
        return Material(
          child: SafeArea(
            bottom: true,
            child: Ink(
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: itemList(titles),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget actionSubItem(
    String title, BuildContext context, Function? onTap, double itemH) {
  return Ink(
    height: itemH,
    color: Colors.white,
    child: InkWell(
      onTap: () {
        Navigator.of(context).pop();
        if (onTap != null) {
          onTap(title);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title),
        ],
      ),
    ),
  );
}
