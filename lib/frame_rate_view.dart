import 'dart:async';

import 'package:flutter/material.dart';

/// 帧率信息控件
class FrameRateView extends StatefulWidget {
  @override
  _FrameRateViewState createState() => _FrameRateViewState();
}

class _FrameRateViewState extends State<FrameRateView> {
  int count = 0;
  int offsetTime = 0;
  int lastTime = DateTime.now().millisecondsSinceEpoch;
  int frameRate = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding? widgetsBinding = WidgetsBinding.instance;
    // 第一帧的回调
    widgetsBinding?.addPostFrameCallback((callback) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        // 1秒计算一次帧率
        if (mounted) {
          setState(() {
            frameRate = count;
            count = 0;
          });
        }
      });
      // 持久帧的回调
      widgetsBinding.addPersistentFrameCallback((callback) {
        if (mounted) {
          int nowTime = DateTime.now().millisecondsSinceEpoch;
          setState(() {
            count += 1;
            offsetTime = nowTime - lastTime;
            lastTime = nowTime;
          });
          widgetsBinding.scheduleFrame();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "刷新次数:$count\n每秒帧数:$frameRate\n每帧耗时:$offsetTime",
      style: TextStyle(color: Colors.white),
    );
  }
}
