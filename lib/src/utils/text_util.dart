import 'package:flutter/material.dart';

class TextUtil {
  ///限制文字长度
  ///text 需要限制的文本
  ///length 限制的长度，超出变成…, 默认12个字符
  static String limitTextLength(
    String? text, {
    int length = 12,
  }) {
    if (text?.isNotEmpty == true && text!.length > length) {
      return "${text.substring(0, length)}…";
    }
    return text ?? "";
  }

  ///text: 文本内容；
  ///fontSize : 文字的大小；
  ///fontWeight：文字权重；
  ///maxWidth：文本框的最大宽度；
  ///maxLines：文本支持最大多少行
  static Size calculateTextHeight({
    required String text,
    required double fontSize,
    required double maxWidth,
    double? height,
    FontWeight fontWeight = FontWeight.normal,
    int maxLines = 1,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
  }) {
    String value = text; //_filterText(text);
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
      locale: const Locale('zh', 'CN'), //Localizations.localeOf(mainContext),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: value,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          height: height,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          fontStyle: fontStyle,
          // textBaseline: TextBaseline.ideographic,
        ),
      ),
    );
    painter.layout(minWidth: 0,maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.size;
  }

  static String _filterText(String text) {
    String tag = '<br>';
    while (text.contains('<br>')) {
      // flutter 算高度,单个\n算不准,必须加两个
      text = text.replaceAll(tag, '\n\n');
    }
    return text;
  }

  static String breakWord(String? word){
    if(word == null || word.isEmpty){
      return '';
    }
    String breakWord = '';
    for (var element in word.runes) {
      breakWord += String.fromCharCode(element);
      breakWord +='\u200B';
    }
    return breakWord;
  }

  ///处理显示emoji
  static String displayEmojiText(String? text) {
    String _text = text ?? "";
    //解决iOS部分数字emoji显示问题
    // if (Config.isIOS == true) {
      // _text = _text.replaceAll("\ufe0f\u20e3", "\u20e3");
      _text = _text.replaceAll("\ufe0f\u20e3", "\u20e3\ufe0f");
      // _text = _text.replaceAll("⏏️️️", "\u23cf\ufe0f");
      // _text = _text.replaceAll("\u23cf\ufe0f", "\u23cf\u20e3");
      // _text = _text.replaceAll("️▶️", "\u25b6\ufe0f");
      // _text = _text.replaceAll("️\u25b6\ufe0f️", "\u25b6\u20e3");
    // }
    return _text;
  }

  //格式化城市, eg：广西 · 雨林
  static String formatCity({required String? city, required String? province}){
    if (province?.isNotEmpty==true && city?.isNotEmpty==true && city!=province) {
      return "$province · $city";
    }
    return city ?? province ?? "";
  }

}
