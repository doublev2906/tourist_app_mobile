import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_app_mobille/controllers/home_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/core/constants/textstyle_ext.dart';
import 'package:tourist_app_mobille/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final categories = [
    {
      "id": "destination",
      "title": "Điểm tham quan",
    },
    {
      "id": "hotel",
      "title": "Khách sạn",
    },
    {
      "id": "restaurant",
      "title": "Nhà hàng",
    },
    {
      "id": "shop",
      "title": "Cửa hàng",
    },
    {
      "id": "photo",
      "title": "Khoảnh khắc",
    },
  ];

  Widget buildListCategory() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((c) {
            return Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/${c['id']}.png",
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(height: 4),
                    Text(c['title'] ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyles.defaultStyle.copyWith(
                            fontSize: 10,
                            color: ColorPalette.textColorBlack,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildListCity() {
    final listCity = controller.listCity;
    return SizedBox(
      height: 90,
      child: Skeletonizer(
        enabled: controller.loadingCity.value,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listCity.length,
            itemBuilder: (context, index) {
              final city = listCity[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 150,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                              imageUrl: city["image_url"], fit: BoxFit.cover),
                        ),
                      ),
                      Positioned.fill(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 8,
                              left: 12,
                              child: Text(
                                city["name"],
                                style: TextStyles.defaultStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget buildActivities() {
    final List<Map<String, dynamic>> activities = controller.activities.value;
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    return Container(
      constraints: const BoxConstraints(maxHeight: 180),
      child: Skeletonizer(
        enabled: false,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                      width: 150,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: activity["image_url_host"],
                                fit: BoxFit.cover,
                                height: 85,
                                width: 150,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activity["participants_format"],
                              style: const TextStyle(
                                  color: Colors.blueGrey, fontSize: 10),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              activity["title"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: ColorPalette.text1Color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.solidStar,
                                    size: 8,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    activity["score"].toString(),
                                    style: const TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 10),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    "(${activity["review_total"]})",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  )
                                ]),
                            const SizedBox(height: 2),
                            Text(
                              "Từ ${currencyFormatter.format(int.parse(activity["from_price"]))}",
                              style: const TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          ])));
            }),
      ),
    );
  }

  Widget buildListDestination() {
    final List<Map<String, dynamic>> destinations =
        controller.destinations.value;

    final loadingDestination = controller.loadingDestination.value;

    if (loadingDestination) {
      return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }

    return MasonryGridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemCount: destinations.length,
        itemBuilder: (_, index) {
          final destination = destinations[index];
          return Card(
            elevation: 1,
            margin: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: destination["cover_image_url"],
                    height: index % 2 == 0 ? 200 : 150,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination["name"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.defaultStyle.copyWith(
                            fontSize: 13,
                            color: ColorPalette.textColorBlack,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destination["distance_str"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.defaultStyle
                            .copyWith(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.fire,
                              size: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              destination["hot_score"].toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBarContainer(
          titleString: 'home',
          marginTop: 60,
          implementLeading: false,
          child: Column(
            children: [
              Container(
                height: 36,
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 14,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(controller.currentPlace.value,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.copyWith(
                              fontSize: 14,
                              color: ColorPalette.textColorBlack,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              buildListCategory(),
              Expanded(
                  child: SmartRefresher(
                controller: controller.refreshController,
                enablePullDown: false,
                enablePullUp:
                    controller.loadingDestination.value ? false : true,
                onLoading: () => controller.loadDestination(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            height: 150,
                            autoPlay: true,
                            autoPlayInterval:
                                const Duration(milliseconds: 5000)),
                        items: [1, 2, 3, 4].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 3,
                                    child: Image.asset(
                                      "assets/images/banner/banner_$i.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            'Bạn muốn đi đâu chơi?',
                            style: TextStyles.defaultStyle.bold
                                .copyWith(fontSize: 18),
                          ),
                          const Spacer(),
                          Text(
                            'Xem thêm',
                            style: TextStyles.defaultStyle.primaryTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      buildListCity(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Các hoạt động nổi bật',
                            style: TextStyles.defaultStyle.bold
                                .copyWith(fontSize: 18),
                          ),
                          const Spacer(),
                          Text(
                            'Xem thêm',
                            style: TextStyles.defaultStyle.primaryTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      buildActivities(),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Text(
                            'Điểm tham quan gần bạn',
                            style: TextStyles.defaultStyle.bold
                                .copyWith(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      buildListDestination(),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}
