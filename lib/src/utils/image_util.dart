import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_utils/src/utils/screens.dart';
import 'package:image/image.dart' as Image2;
import 'package:image_editor/image_editor.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:palette_generator/palette_generator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// import 'package:image/image.dart';
// import 'package:exif/exif.dart';
// import 'package:metadata/metadata.dart';
// import 'package:flutter_xmp/flutter_xmp.dart';

//图片处理工具
class ImageUtil {
  ///获取图片exif信息
  static void getExif(String? path) async {
    var asa = await rootBundle.load("assets/image/DJ2.jpg");
    Uint8List fileBytes =
        path != null ? File(path).readAsBytesSync() : asa.buffer.asUint8List();
    // final data = await readExifFromBytes(fileBytes, strict: true);
    // if (data.isEmpty) {
    //   debugPrint("No EXIF information found");
    //   return;
    // }
    //
    // if (data.containsKey('JPEGThumbnail')) {
    //   debugPrint('File has JPEG thumbnail');
    //   data.remove('JPEGThumbnail');
    // }
    // if (data.containsKey('TIFFThumbnail')) {
    //   debugPrint('File has TIFF thumbnail');
    //   data.remove('TIFFThumbnail');
    // }
    //
    // for (final entry in data.entries) {
    //   debugPrint("${entry.key}: ${entry.value}");
    // }
  }

  ///获取主题颜色
  ///三选一
  static Future<Color?> getMainColor({
    EncodedImage? encodedImage,
    ui.Image? image,
    ImageProvider? imageProvider,
  }) async {
    if (image != null) {
      var result = await PaletteGenerator.fromImage(
        image,
        // maximumColorCount: 20,
      );
      return result.dominantColor?.color;
    } else if (encodedImage != null) {
      var result = await PaletteGenerator.fromByteData(
        encodedImage,
        // maximumColorCount: 20,
      );
      return result.dominantColor?.color;
    } else if (imageProvider != null) {
      var result = await PaletteGenerator.fromImageProvider(
        imageProvider,
        // maximumColorCount: 20,
        timeout: const Duration(seconds: 5),
      );
      return result.dominantColor?.color;
    }
    return null;
  }

  ///裁剪图片(原生库)
  static Future<Uint8List?> cropImageData({
    required Uint8List rawImage,
    bool? needCrop = true,
    Rect? cropRect,
    bool? needFlip,
    bool? flipHorizontal,
    bool? flipVertical,
    bool? hasRotateAngle,
    int? rotateAngle,
  }) async {
    Uint8List? result;
    debugPrint(
        "cropRect:$cropRect, flipHorizontal:$flipHorizontal, flipVertical:$flipVertical, rotateAngle:$rotateAngle");
    try {
      final ImageEditorOption option = ImageEditorOption();
      if (needCrop == true && cropRect != null) {
        option.addOption(ClipOption.fromRect(cropRect));
      }
      if (needFlip == true) {
        option.addOption(
            FlipOption(horizontal: flipHorizontal!, vertical: flipVertical!));
      }
      if (hasRotateAngle == true) {
        option.addOption(RotateOption(rotateAngle!));
      }
      final DateTime start = DateTime.now();
      result = await ImageEditor.editImage(
        image: rawImage,
        imageEditorOption: option,
      );
      debugPrint('crop image total time: ${DateTime.now().difference(start)}');
    } catch (e) {
      debugPrint("e: $e");
    }
    return result;
  }

  ///裁剪图片(dart库)
  static Future<Uint8List> cropImageDataDartLib({
    required Uint8List rawImage,
    required Rect cropRect,
  }) async {
    var img = Image2.decodeImage(rawImage)!;
    var thumbnail = Image2.copyCrop(
      img,
      x: cropRect.left.toInt(),
      y: cropRect.top.toInt(),
      width: cropRect.width.toInt(),
      height: cropRect.height.toInt(),
    );
    return thumbnail.getBytes();
  }

  ///修改角度
  ///rawImage 数据源
  ///radian 弧度
  ///rotate 角度 0~360
  static Future<Uint8List?> radianImage({
    required Uint8List rawImage,
    double? rotateRadian,
    int? rotateDegree,
  }) async {
    final ImageEditorOption option = ImageEditorOption();
    if (rotateRadian != null) {
      option.addOption(RotateOption.radian(rotateRadian));
    }
    if (rotateDegree != null) {
      option.addOption(RotateOption(rotateDegree));
    }
    var result = await ImageEditor.editImage(
      image: rawImage,
      imageEditorOption: option,
    );
    return result;
  }

  ///混合图片
  static Future<Uint8List?> mixImage({
    required Uint8List backgroundImage,
    required Uint8List childImage,
    BlendMode? blendMode,
    Offset? childImageOffset,
    Size? childImageSize,
  }) async {
    final optionGroup = ImageEditorOption();
    optionGroup.outputFormat = const OutputFormat.png();
    optionGroup.addOption(
      MixImageOption(
        x: childImageOffset?.dx.round() ?? 0,
        y: childImageOffset?.dy.round() ?? 0,
        width: childImageSize?.width.round() ?? 150,
        height: childImageSize?.height.round() ?? 150,
        target: MemoryImageSource(childImage),
        blendMode: blendMode ?? BlendMode.src,
      ),
    );
    final result = await ImageEditor.editImage(
      image: backgroundImage,
      imageEditorOption: optionGroup,
    );
    return result;
  }

  ///合并图片
  static Future<Uint8List?> mergeImage({
    required Uint8List backgroundImage,
    required Size canvasSize,
    required Uint8List childImage,
    required Size childImageSize,
    required Offset? childImageOffset,
  }) async {
    final option = ImageMergeOption(
      canvasSize: canvasSize,
      format: const OutputFormat.png(),
    );
    option.addImage(
      MergeImageConfig(
        image: MemoryImageSource(backgroundImage),
        position: ImagePosition(
          Offset.zero,
          canvasSize,
        ),
      ),
    );
    option.addImage(
      MergeImageConfig(
        image: MemoryImageSource(childImage),
        position: ImagePosition(
          childImageOffset ?? Offset.zero,
          childImageSize,
        ),
      ),
    );
    final result = await ImageMerger.mergeToMemory(option: option);
    return result;
  }

  ///根据颜色转Uint8List
  static Future<Uint8List?> getBitmapFromColor({
    required Size size,
    required Color color,
  }) async {
    ByteData byteData = await WidgetToImage.widgetToImage(
      Container(
        width: size.width,
        height: size.height,
        color: color,
      ),
    );
    return byteData.buffer.asUint8List();
  }

  ///根据widget获取Uint8List
  static Future<Uint8List?> getBitmapFromWidget({
    required Widget widget,
  }) async {
    ByteData byteData = await WidgetToImage.widgetToImage(
      widget,
    );
    return byteData.buffer.asUint8List();
  }

  ///从组件获取位图
  ///@param: context:组件上下文
  ///@param: pixelRatio:根据分辨率展示倍图
  ///@return: Unit8List
  static Future<Uint8List?> getBitmapFromContext(
    BuildContext context, {
    double? pixelRatio,
  }) async {
    try {
      RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(
        pixelRatio: pixelRatio ?? Screens.pixelRatio,
      );
      ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = bytes?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      debugPrint("getBitmapFromContext $e");
      return null;
    }
  }

  ///获取图片数据
  static Future<Uint8List?> getImageData({required String? imageUrl}) async {
    if (imageUrl == null) {
      return null;
    } else {
      var imageFile = await getCachedImageFile(imageUrl);
      if (imageFile != null) {
        return imageFile.readAsBytesSync();
      } else {
        return await getNetworkImageData(imageUrl);
      }
    }
  }
}

class WidgetToImage {
  static Future<ByteData> repaintBoundaryToImage(GlobalKey key,
      {double pixelRatio = 1.0}) {
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary repaintBoundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;

      ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData!;
    });
  }

  static Future<ByteData> widgetToImage(Widget widget,
      {Alignment alignment = Alignment.center,
      Size size = const Size(double.maxFinite, double.maxFinite),
      double devicePixelRatio = 1.0,
      double pixelRatio = 1.0}) async {
    RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    RenderView renderView = RenderView(
      child: RenderPositionedBox(alignment: alignment, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: size,
        devicePixelRatio: devicePixelRatio,
      ),
      view: WidgetsBinding.instance.platformDispatcher.views.first,
    );

    PipelineOwner pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    RenderObjectToWidgetElement rootElement = RenderObjectToWidgetAdapter(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!;
  }
}
