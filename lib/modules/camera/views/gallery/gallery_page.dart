import 'package:hybrid_module/modules/camera/views/gallery/gallery_controller.dart';
import 'package:camera/camera.dart' as camera;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryPage extends GetView<GalleryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("갤러리"),
        backgroundColor: const Color(0xFFff6f50),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                controller.chooseImage();
              },
              icon: const Text(
                "확인",
                style: TextStyle(fontSize: 15),
              ))
        ],
      ),
      body: GetX<GalleryController>(
        initState: (state) {
          Get.find<GalleryController>();
        },
        builder: (controller) {
          return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll) {
                controller.infiniteScrollHandler(scroll);
                return true;
              },
              child: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Color(0xFFff6f50),
                    ))
                  : GridView.builder(
                      itemCount: controller.mediaList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              controller.selectItem(index);
                            },
                            child: Stack(children: <Widget>[
                              controller.mediaList[index],
                              Obx(() => Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: controller.selectIndex != index
                                              ? 0
                                              : 3,
                                          color: controller.selectIndex != index
                                              ? Colors.white
                                              : Colors.deepOrange),
                                    ),
                                  )),
                            ]));
                      }));
        },
      ),
    );
  }
}
