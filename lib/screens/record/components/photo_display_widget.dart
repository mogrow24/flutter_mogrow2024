import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mogrow/screens/record/components/custom_grid_view.dart';
import 'package:mogrow/screens/record/components/custom_list_view.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoDisplayWidget extends StatefulWidget {
  final List<AssetEntity> photoImageList;

  const PhotoDisplayWidget({super.key, required this.photoImageList});

  @override
  State<PhotoDisplayWidget> createState() => _PhotoDisplayWidgetState();
}

class _PhotoDisplayWidgetState extends State<PhotoDisplayWidget> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _selected == 0
            ? CustomGridView(
                photoImageList: widget.photoImageList,
                type: "survey",
              )
            : SizedBox(
                height: 160,
                child: CustomListView(
                  photoImageList: widget.photoImageList,
                  type: "survey",
                ),
              ),
        Padding(
          padding: EdgeInsets.only(
            right: 20,
            left: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selected = _selected == 0 ? 1 : 0;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _selected == 0
                          ? 'assets/icons/grid.svg'
                          : 'assets/icons/carousel.svg',
                      width: 20,
                      height: 20,
                      color: Color(0xFF3E4450),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 1,
                        left: 4,
                      ),
                      child: Text(
                        _selected == 0 ? "앨범형" : "가로형",
                        style: TextStyle(
                          color: Color(0xFF3E4450),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${widget.photoImageList.length}/12",
                style: TextStyle(
                  color: Color(0xFF8892A6),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
