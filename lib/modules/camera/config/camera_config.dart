import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class CameraConfig {
  static const loadingColor = 0xFFFF6F50;
  static const appBarTitleFontsSize = 15.0;
  static const appBarTitleFonts = "NotoSansKR_Bold";
  static const appBarTitleFontsWeight = FontWeight.bold;
  static const appBarTitleTextColor = 0xFF3E3E3E;
  static const appBarTitleLetterSpacing = -0.25;

  static const flashAutoIcon = Icon(Icons.flash_auto);
  static const flashOffIcon =  Icon(Icons.flash_off);
  static const flashOnIcon =  Icon(Icons.flash_on);
  static const cameraIcon =  ImageIcon(AssetImage('assets/camera/icon_shoot.png'), size: 45);
  static const changeModeIcon =  Icon(Icons.autorenew);
  static const videoStop =  Icon(Icons.stop);
  static const videoPlay =  Icon(Icons.play_arrow);
  static const uploadIcon =  Icon(Icons.upload);
  static const undoIcon =  Icon(Icons.undo);
}
