
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'FormatUtil.dart';

enum ImageFrom { camera, gallery }

class ImageUtil {
  static pickSinglePic(ImageFrom from,
      {double? maxWidth, double? maxHeight, int? imageQuality}) async {
    ImageSource source;
    switch (from) {
      case ImageFrom.camera:
        source = ImageSource.camera;
        break;
      case ImageFrom.gallery:
        source = ImageSource.gallery;
        break;
    }
    final pickerImages = await ImagePicker().pickImage(
      source: source,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return pickerImages;
  }

  ///裁切图片
  ///[image] 图片路径或文件
  ///[width] 宽度
  ///[height] 高度
  ///[aspectRatio] 比例
  ///[androidUiSettings]UI 参数
  ///[iOSUiSettings] ios的ui 参数
  static cropImage(
      {required XFile image,
        required width,
        required height,
        aspectRatio,
        androidUiSettings,
        iOSUiSettings}) async {
    String imagePth = image.path;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePth,
      maxWidth: FormatUtil.num2int(width),
      maxHeight: FormatUtil.num2int(height),
      aspectRatio: aspectRatio ??
          CropAspectRatio(
              ratioX: FormatUtil.num2double(width),
              ratioY: FormatUtil.num2double(height)),
      uiSettings: [
        androidUiSettings ??
            AndroidUiSettings(
                toolbarTitle:
                'Cropper(${FormatUtil.num2int(width)}*${FormatUtil.num2int(height)})',
                toolbarColor: Colors.blue,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                hideBottomControls: false,
                lockAspectRatio: true),
        iOSUiSettings ??
            IOSUiSettings(
              title: 'Cropper',
            ),
      ],
    );
    return croppedFile;
  }

  ///裁切图片
  ///[image] 图片路径或文件
  ///[width] 宽度
  ///[height] 高度
  ///[androidUiSettings]UI 参数
  ///[iOSUiSettings] ios的ui 参数
  static cropImage2(
      {required XFile image,
        required width,
        required height,
        androidUiSettings,
        iOSUiSettings}) async {
    String imagePth = image.path;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePth,
      maxWidth: FormatUtil.num2int(width),
      maxHeight: FormatUtil.num2int(height),
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio7x5
      ],
      uiSettings: [
        androidUiSettings ??
            AndroidUiSettings(
                toolbarTitle:
                'Cropper(${FormatUtil.num2int(width)}*${FormatUtil.num2int(height)})',
                toolbarColor: Colors.blue,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                hideBottomControls: false,
                lockAspectRatio: false),
        iOSUiSettings ??
            IOSUiSettings(
              title: 'Cropper',
            ),
      ],
    );
    return croppedFile;
  }

  ///裁切图片
  ///[image] 图片路径或文件
  ///[width] 宽度
  ///[height] 高度
  ///[androidUiSettings]UI 参数
  ///[iOSUiSettings] ios的ui 参数
  static cropImage3(
      {required XFile image,
        required width,
        required height,
        androidUiSettings,
        iOSUiSettings}) async {
    String imagePth = image.path;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePth,
      maxWidth: FormatUtil.num2int(width),
      maxHeight: FormatUtil.num2int(height),
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square
      ],
      uiSettings: [
        androidUiSettings ??
            AndroidUiSettings(
                toolbarTitle:
                'Cropper(${FormatUtil.num2int(width)}*${FormatUtil.num2int(height)})',
                toolbarColor: Colors.blue,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                hideBottomControls: false,
                lockAspectRatio: false),
        iOSUiSettings ??
            IOSUiSettings(
              title: 'Cropper',
            ),
      ],
    );
    return croppedFile;
  }

}
