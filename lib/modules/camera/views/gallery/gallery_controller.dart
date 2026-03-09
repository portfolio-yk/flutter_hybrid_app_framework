import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:hybrid_module/modules/camera/data/camera_result.dart';
import 'package:hybrid_module/modules/camera/data/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/src/widgets/image.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryController extends GetxController {
  List<AssetEntity> myAlbums = [];

  int mediaCount = 30;
  int currentPage = 0;
  late int lastPage;

  final RxInt _selectIndex = 0.obs;

  get selectIndex => _selectIndex.value;

  final _isLoading = true.obs;

  get isLoading => _isLoading.value;

  final RxList<Widget> _mediaList = <Widget>[].obs;

  get mediaList => _mediaList.value;

  GalleryController();

  @override
  void onInit() async {
    var result = await PhotoManager.requestPermissionExtend();
    await _getImageList(result);
    _isLoading.value = false;
  }

  infiniteScrollHandler(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        PhotoManager.requestPermissionExtend()
            .then((result) => _getImageList(result));
      }
    }
  }

  _getImageList(result) async {
    lastPage = currentPage;
    List<Widget> temp = [];
    if ([PermissionState.authorized, PermissionState.limited]
        .contains(result)) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      //media 에 사진 mediaCount개씩 담김
      List<AssetEntity> media = await albums[0]
          .getAssetListPaged(size: mediaCount, page: currentPage);
      //30개를 한번에 보여주면 깜빡거림 for문으로 하나씩(동영상표시도)

      for (var asset in media) {
        if (asset.type == AssetType.image) {
          temp.add(
            FutureBuilder(
              future:
                  asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          );
          myAlbums.add(asset);
        }
      }
      _mediaList.addAll(temp);
      _mediaList.refresh();
      if (media.length < mediaCount) {
        return false;
      } else {
        currentPage++;
      }
    }
  }

  selectItem(int index) {
    _selectIndex.value = index;
    return true;
  }

  chooseImage() async {
    print(myAlbums[_selectIndex.value].originBytes);
    var imageBytes = await myAlbums[_selectIndex.value].originBytes;
    Get.back(
        result: CameraResult(
            code: CameraCode.success,
            imgData:
                ("data:image/jpeg;base64," + await base64Encode(imageBytes!))));
  }
}
