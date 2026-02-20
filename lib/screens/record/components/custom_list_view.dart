import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/photo_manager.dart';
import 'package:mogrow/screens/record/components/full_screen_image_view.dart';
import 'package:mogrow/screens/record/components/thumbnail_horizontal_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class CustomListView extends StatelessWidget {
  final List<RecordsImage>? imageList;
  final List<AssetEntity>? photoImageList;
  final String type;

  const CustomListView(
      {super.key, this.imageList, this.photoImageList, required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == "survey" && photoImageList != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: photoImageList!.length,
          itemBuilder: (context, index) {
            final photoManager = context.read<PhotoManagerProvider>();
            final asset = photoImageList![index];

            return ThumbnailHorizontalWidget(
              asset: asset,
              onRemove: () {
                photoManager.removeSelectedImage(index);
              },
            );
          },
        ),
      );
    } else if (type == "surveyDetail" && imageList != null) {
      return imageList!.isEmpty
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: imageList!.length,
              itemBuilder: (context, index) {
                final imagePath = imageList![index].path;
                final file = File(imagePath);
                final totalCnt = imageList!.length;

                return GestureDetector(
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
                  child: Container(
                      width: 160,
                      height: 160,
                      margin: EdgeInsets.symmetric(horizontal: 1),
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
                      )),
                );
              },
            );
    } else {
      return Container();
    }
  }
}
