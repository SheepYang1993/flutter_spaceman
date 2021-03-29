import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spaceman/frame_rate_view.dart';
import 'package:flutter_spaceman/point.dart';
import 'package:flutter_spaceman/settings.dart';
import 'package:flutter_spaceman/video_view.dart';

class SpacemanView extends StatefulWidget {
  final Settings? settings;

  SpacemanView({this.settings});

  @override
  _SpacemanViewState createState() => _SpacemanViewState(settings);
}

class _SpacemanViewState extends State<SpacemanView> {
  Settings? settings;
  Paint ballPaint = Paint();
  int catchBallCount = 0;
  double width = 0, height = 0;
  List<Point> ballList = [];
  math.Point? touchPoint;

  _SpacemanViewState(this.settings) {
    if (this.settings == null) {
      this.settings = Settings();
    }
  }

  @override
  void initState() {
    super.initState();
    ballPaint.strokeWidth = 10;
    WidgetsBinding? widgetsBinding = WidgetsBinding.instance;
    widgetsBinding?.addPostFrameCallback((callback) {
      // 第一帧的回调
      width = context.size?.width ?? 0;
      height = context.size?.height ?? 0;
      // 初始化小球列表
      for (int i = 0; i < settings!.totalCount; i++) {
        // 在控件大小范围内，随机添加小球
        double x = Random().nextInt(width.toInt()).toDouble();
        double y = Random().nextInt(height.toInt()).toDouble();
        // 下面是设置初始加速度
        // 通过下面的公式，防止出现加速度为0，且加速度可为正负velocityXRange
        int velocityX = (Random().nextInt(settings!.velocityXRange) + 1) *
            (1 - 2 * Random().nextInt(2));
        int velocityY = (Random().nextInt(settings!.velocityYRange) + 1) *
            (1 - 2 * Random().nextInt(2));
        Color color;
        if (settings!.ballColors != null) {
          color = settings!
              .ballColors![Random().nextInt(settings!.ballColors!.length)];
        } else {
          color = Colors.green;
        }
        ballList.add(Point(x, y,
            velocityX: velocityX, velocityY: velocityY, color: color));
      }
      widgetsBinding.addPersistentFrameCallback((callback) {
        // 持久帧的回调
        if (mounted) {
          setState(() {
            catchBallCount = 0;
            ballList.forEach((ball) {
              // 计算点击时，小球的偏移量，营造聚拢效果
              calculateTouchOffset(ball);

              // 当遇到边界时，需要改变x加速度方向
              if (ball.x >=
                  width - settings!.radius / 2 - settings!.lineWidth / 2) {
                if (ball.velocityX > 0) {
                  ball.velocityX = -ball.velocityX;
                }
              } else if (ball.x <=
                  0 + settings!.radius / 2 + settings!.lineWidth / 2) {
                if (ball.velocityX < 0) {
                  ball.velocityX = -ball.velocityX;
                }
              }
              // 根据加速度，计算出小球当前的x值
              ball.x = ball.x + ball.velocityX * settings!.eachMovePixel;

              // 和计算x值一样的原理, 计算出y的值
              // 当遇到边界时，需要改变y加速度方向
              if (ball.y >=
                  height - settings!.radius / 2 - settings!.lineWidth / 2) {
                if (ball.velocityY > 0) {
                  ball.velocityY = -ball.velocityY;
                }
              } else if (ball.y <=
                  0 + settings!.radius / 2 + settings!.lineWidth / 2) {
                if (ball.velocityY < 0) {
                  ball.velocityY = -ball.velocityY;
                }
              }
              // 根据加速度，计算出小球当前的y值
              ball.y = ball.y + ball.velocityY * settings!.eachMovePixel;
            });
          });
          widgetsBinding.scheduleFrame();
        }
      });
    });
  }

  /// 计算点击时，小球的偏移量，营造聚拢效果
  void calculateTouchOffset(Point ball) {
    if (touchPoint != null) {
      double distanceX = touchPoint!.x - ball.x;
      double distanceY = touchPoint!.y - ball.y;

      double distance = sqrt(pow(distanceX, 2) + pow(distanceY, 2));

      if (distance <= settings!.touchRadius) {
        catchBallCount += 1;
        // 计算距离百分比
        double percentX = 1 - (distanceX / settings!.touchRadius);
        double percentY = 1 - (distanceY / settings!.touchRadius);

        // 计算偏移量
        double offsetX =
            ball.velocityX * settings!.eachMovePixel * (1 + percentX);
        double offsetY =
            ball.velocityY * settings!.eachMovePixel * (1 + percentY);

        // x轴方向位移减少
        ball.x = ball.x - offsetX;
        // y轴方向位移减少
        ball.y = ball.y - offsetY;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              color: (settings!.backgroundColor == null)
                  ? Colors.black
                  : settings!.backgroundColor,
            )),
        Positioned(
          left: (width - settings!.videoWidth) / 2 +
              ((touchPoint == null)
                  ? 0
                  : touchPoint!.x.toDouble() - settings!.videoOffsetX),
          width: settings!.videoWidth,
          top: (height - settings!.videoHeight) / 2 +
              ((touchPoint == null)
                  ? 0
                  : touchPoint!.y.toDouble() - settings!.videoOffsetY),
          height: settings!.videoHeight,
          child: Visibility(
            visible: settings!.videoAssetsUrl != '',
            child: VideoView(settings!.videoAssetsUrl),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Visibility(
            visible: settings!.showFrameRate,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: FrameRateView(),
            ),
          ),
        ),
        Positioned(
          right: 20,
          child: Visibility(
            visible: settings!.showNumberHint,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "数量:${ballList.length}\n捕获:$catchBallCount",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            child: CustomPaint(
              painter:
                  new PointPainter(settings!, touchPoint, ballPaint, ballList),
            ),
            onPanStart: (DragStartDetails details) {
              setState(() {
                touchPoint = math.Point(
                    details.localPosition.dx, details.localPosition.dy);
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                touchPoint = math.Point(
                    details.localPosition.dx, details.localPosition.dy);
              });
            },
            onPanEnd: (DragEndDetails details) {
              setState(() {
                touchPoint = null;
              });
            },
          ),
        ),
      ],
    );
  }
}

class PointPainter extends CustomPainter {
  math.Point? touchPoint;
  Paint ballPaint;
  Paint touchPaint = Paint();
  List<Point> ballList;
  Settings settings;

  PointPainter(this.settings, this.touchPoint, this.ballPaint, this.ballList) {
    if (settings.touchColor == null) {
      touchPaint.color = Color.fromARGB(81, 176, 176, 176);
    } else {
      touchPaint.color = settings.touchColor!;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制小球列表
    drawBallList(canvas);

    // 绘制点击区域
    drawTouchCircle(canvas);
  }

  /// 绘制点击区域
  void drawTouchCircle(Canvas canvas) {
    if (touchPoint != null) {
      canvas.drawCircle(
          Offset(touchPoint!.x.toDouble(), touchPoint!.y.toDouble()),
          settings.touchRadius,
          touchPaint);
    }
  }

  /// 绘制小球列表
  void drawBallList(Canvas canvas) {
    Paint linePaint = Paint();
    // 绘制小球列表
    ballList.forEach((ball1) {
      linePaint.strokeWidth = settings.lineWidth;
      ballPaint.color = ball1.color;
      // 绘制小球
      canvas.drawCircle(Offset(ball1.x, ball1.y), settings.radius, ballPaint);

      // 绘制小球与触摸点之间的连线
      drawTouchLine(ball1, linePaint, canvas);

      ballList.forEach((ball2) {
        // 绘制小球之间的连线
        if (ball1 != ball2) {
          int distance = point2Distance(ball1, ball2);
          if (distance <= settings.maxDistance) {
            // 小于最大连接距离，才进行连线

            // 线条透明度，距离越远越透明
            double alpha =
                (1.0 - distance / settings.maxDistance) * settings.maxAlpha;
            Color color = ball1.color;
            linePaint.color = Color.fromARGB(
                (alpha * 255).toInt(), color.red, color.green, color.blue);

            // 绘制两个小球之间的连线
            canvas.drawLine(
                Offset(ball1.x, ball1.y), Offset(ball2.x, ball2.y), linePaint);
          }
        }
      });
    });
  }

  /// 绘制小球与触摸点之间的连线
  void drawTouchLine(Point ball1, Paint linePaint, Canvas canvas) {
    if (touchPoint != null) {
      int distance = pointNum2Distance(
          ball1.x, touchPoint!.x.toDouble(), ball1.y, touchPoint!.y.toDouble());
      if (distance <= settings.touchRadius) {
        // 线条透明度，距离越近越透明
        double alpha = distance / settings.touchRadius * settings.maxAlpha;
        Color color = ball1.color;
        linePaint.color = Color.fromARGB(
            (alpha * 255).toInt(), color.red, color.green, color.blue);

        // 绘制两个小球之间的连线
        canvas.drawLine(
            Offset(ball1.x, ball1.y),
            Offset(touchPoint!.x.toDouble(), touchPoint!.y.toDouble()),
            linePaint);
      }
    }
  }

  /// 计算两点之间的距离
  int point2Distance(Point p1, Point p2) {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2)).toInt();
  }

  /// 计算两点之间的距离
  int pointNum2Distance(double x1, double x2, double y1, double y2) {
    return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2)).toInt();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 在实际场景中正确利用此回调可以避免重绘开销，目前简单返回true
    // 当条件变化时是否需要重画
    return true;
  }
}
