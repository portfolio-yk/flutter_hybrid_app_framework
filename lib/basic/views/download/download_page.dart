import 'package:hybrid_module/basic/views/download/download_controller.dart';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadPage extends GetView<DownloadController> {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<DownloadController>(
        initState: (state) {
          var controller = Get.find<DownloadController>();
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            controller.startPage();
          });
        },
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
              color: Color(Config.downloadBackgroundColor),
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      _.downloadImageUrl,
                      width: 100,
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    child: Column(
                      children: [
                        Text(
                          _.currentStatus,
                          style: TextStyle(color: Config.textColor),
                        ),
                        Text(
                          '${_.progress}%',
                          style: TextStyle(color: Config.textColor),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
