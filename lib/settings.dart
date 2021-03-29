import 'package:flutter/material.dart';

/// 配置信息
class Settings {
  // 背景动画资源路径
  final String videoAssetsUrl;

  /// 显示帧信息
  final bool showFrameRate;

  /// 显示小球数量、捕获信息
  final bool showNumberHint;

  // 背景颜色
  final List<Color>? ballColors;

  /// 小球总数
  final int totalCount;

  /// 小球连线最大的距离
  final double maxDistance;

  /// X轴加速度范围，范围越大，小球速度相差就越大
  final int velocityXRange;

  /// Y轴加速度范围，范围越大，小球速度相差就越大
  final int velocityYRange;

  // 每次刷新,单位位移的像素，大于0就行，越小，小球运动的越慢
  final double eachMovePixel;

  /// 小球连线的宽度
  final double lineWidth;

  /// 连线最大的透明度0~1
  final double maxAlpha;

  /// 半径
  final double radius;

  /// 触摸影响半径
  final double touchRadius;

  /// 触摸影响半径
  final Color? touchColor;

  // 背景视频宽度
  final double videoWidth;

  // 背景视频高度
  final double videoHeight;

  // 背景视频x轴偏移量
  final double videoOffsetX;

  // 背景视频y轴偏移量
  final double videoOffsetY;

  // 背景颜色
  final Color? backgroundColor;

  Settings({
    this.videoAssetsUrl = '',
    this.showFrameRate = false,
    this.showNumberHint = false,
    this.ballColors,
    this.velocityXRange = 6,
    this.velocityYRange = 6,
    this.maxDistance = 90,
    this.totalCount = 50,
    this.eachMovePixel = 0.07,
    this.lineWidth = 1,
    this.maxAlpha = 1,
    this.radius = 1,
    this.touchRadius = 100,
    this.touchColor,
    this.backgroundColor,
    this.videoWidth = 275,
    this.videoHeight = 470,
    this.videoOffsetX = 205,
    this.videoOffsetY = 390,
  });
}
