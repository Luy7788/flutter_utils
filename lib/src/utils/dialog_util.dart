import 'package:flutter/material.dart';

class DialogUtil {

  /// 居中的弹窗
  /// widget 想要显示的 widget
  /// barrierDismissible 能否点击背景消失
  /// barrierColor 背景色
  /// useSafeArea 安全区域，默认false
  /// useRootNavigator 在flutter_boost模式下 传false
  static Future popCenterDialog({
    required BuildContext context,
    required Widget widget,
    bool? barrierDismissible,
    Color? barrierColor,
    bool? useSafeArea,
    bool? useRootNavigator,
  }) {
    return popCustom(
        context: context,
        useRootNavigator: useRootNavigator ?? false,
        barrierDismissible: barrierDismissible ?? false,
        barrierColor: barrierColor,
        useSafeArea: useSafeArea ?? false,
        dialog: Dialog(
          insetPadding: EdgeInsets.zero,
          child: widget,
        )
    );
  }

  /// 自定义弹窗 (widget | dialog)
  /// widget 想要显示的 widget | dialog
  /// barrierDismissible 能否点击背景消失
  /// barrierColor 背景色
  /// useSafeArea 安全区域，默认false
  /// useRootNavigator 在flutter_boost模式下 传false
  static Future popCustom({
    required BuildContext context,
    required Widget dialog,
    bool? barrierDismissible,
    Color? barrierColor,
    bool? useSafeArea,
    bool? useRootNavigator,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? false,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea ?? false,
      useRootNavigator: useRootNavigator ?? false,
      builder: (ctx) {
        return dialog;
      },
    );
  }
}
