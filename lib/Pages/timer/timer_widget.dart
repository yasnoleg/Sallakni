import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/Classes/TheTimer.dart';
import 'package:medical_app/Classes/tools.dart';

class TimerWidget extends GetView<TimerController> {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text('${controller.time.value}',style: StyleText,));
  }
}