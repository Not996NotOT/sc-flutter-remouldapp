import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../base_framework/utils/show_image_util.dart';

class swiperBanner extends StatelessWidget {
  final List<String> images;
  final int index;
  final double height;
  final bool autoplay;
  bool pagination;
  final SwiperOnTap onTap;

  /// 轮播图
  /// ```
  /// @param {List<String>} images - 轮播图地址
  /// @param {int} index - 初始下标位置
  /// @param {double} height - 容器高度
  /// ```
  swiperBanner(this.images,
      {this.index,
      this.height = 288,
      this.autoplay = true,
      this.pagination = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Swiper(
          onTap: onTap,
          key: UniqueKey(),
          index: index,
          itemBuilder: (BuildContext context, int index) {
            return ShowImageUtil.showImageWithDefaultError(
                images[index], double.infinity, 288,
                boxFit: BoxFit.cover);
          },
          itemCount: images.length,
          pagination: pagination
              ? SwiperPagination(
                  alignment: Alignment.bottomRight,
                  builder: DotSwiperPaginationBuilder(size: 8, activeSize: 8))
              : null,
          autoplay: autoplay,
          duration: 500,
          autoplayDelay: 5000),
    );
  }
}
