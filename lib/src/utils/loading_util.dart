import 'package:flutter_easyloading/flutter_easyloading.dart';

///加载弹窗
class LoadingUtil {

  ///显示loading
  static void showLoading({bool? isCancel, String? loadTxt}) {
    EasyLoading.show(status: loadTxt ?? '正在加载...');
  }

  ///隐藏loading
  static void hideLoading() {
    EasyLoading.dismiss();
  }

}
