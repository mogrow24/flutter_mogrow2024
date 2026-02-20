import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/photo_manager.dart';
import 'package:mogrow/screens/record/components/full_screen_image_view.dart';
import 'package:mogrow/screens/record/components/thumbnail_image_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class CustomGridView extends StatelessWidget {
  final List<RecordsImage>? imageList;
  final List<AssetEntity>? photoImageList;
  final String type;

  const CustomGridView(
      {super.key, this.imageList, required this.type, this.photoImageList});

  @override
  Widget build(BuildContext context) {
    if (type == "survey" && photoImageList != null) {
      int cnt = photoImageList!.length == 1
          ? 1
          : photoImageList!.length == 2
              ? 2
              : 3;

      return photoImageList!.isEmpty
          ? Container()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cnt,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: photoImageList!.length,
              itemBuilder: (context, index) {
                final photoManager = context.read<PhotoManagerProvider>();
                final asset = photoImageList![index];

                return ThumbnailImageWidget(
                  asset: asset,
                  index: index,
                  onRemove: () {
                    photoManager.removeSelectedImage(index);
                  },
                );
              },
            );
    } else if (type == "surveyDetail" && imageList != null) {
      int cnt = imageList!.length == 1
          ? 1
          : imageList!.length == 2
              ? 2
              : 3;

      return imageList!.isEmpty
          ? Container()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cnt,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: imageList!.length,
              itemBuilder: (context, index) {
                final imagePath = imageList![index].path;
                final file = File(imagePath);
                final totalCnt = imageList!.length;

                return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFFE2E2EA),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF101828).withOpacity(0.04),
                          spreadRadius: 0,
                          blurRadius: 2.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FullscreenImageViewer(
                              imageFile: File(imagePath),
                              totalCnt: totalCnt,
                              currentImg: index + 1,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: (file.existsSync())
                            ? Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(color: Colors.black12),
                                  // image: DecorationImage(image: AssetImage(''))
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '이미지가 손상되었습니다.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ),
                    ));
              },
            );
    } else if (type == "pdf" && imageList != null) {
      int cnt = imageList!.length == 1
          ? 1
          : imageList!.length == 2
              ? 2
              : 3;

      return imageList!.isEmpty
          ? Container()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cnt,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: imageList!.length,
              itemBuilder: (context, index) {
                final imagePath = imageList![index].path;
                final file = File(imagePath);
                final totalCnt = imageList!.length;

                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFE2E2EA),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF101828).withOpacity(0.04),
                        spreadRadius: 0,
                        blurRadius: 2.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: (file.existsSync())
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border.all(color: Colors.black12),
                              // image: DecorationImage(image: AssetImage(''))
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '이미지가 손상되었습니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                );
              },
            );
    } else {
      return Container();
    }
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final Uint8List imageBytes;

  const FullScreenImageViewer({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // 탭하면 닫기
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: InteractiveViewer(
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
