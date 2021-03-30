import 'package:flutter/material.dart';

/// 小球
class Point {
  /// X轴加速度
  int velocityX;

  /// Y轴加速度
  int velocityY;

  /// X轴当前位置
  double x;

  /// Y当前位置
  double y;

  /// 小球颜色
  Color color;

  Point(this.x, this.y,
      {this.velocityX = 0, this.velocityY = 0, this.color = Colors.green});
}
