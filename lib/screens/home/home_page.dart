import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_app_mobille/controllers/home_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/core/constants/constants.dart';
import 'package:tourist_app_mobille/core/constants/textstyle_ext.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tourist_app_mobille/widgets/search_input.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Widget buildListCategory() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.locationDot,
              size: 18,
              color: ColorPalette.text1Color,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(controller.currentPlace.value,
                  style: TextStyles.defaultStyle.copyWith(
                      fontSize: 13,
                      color: ColorPalette.text1Color,
                      fontWeight: FontWeight.w400)),
            )
          ],
          // children: categories.map((c) {
          //   return Expanded(
          //     child: GestureDetector(
          //       onTap: () {
          //         Get.toNamed(AppRoutes.LIST_DESTINATIONS);
          //       },
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Image.asset(
          //             "assets/icons/${c['id']}.png",
          //             width: 40,
          //             height: 40,
          //           ),
          //           const SizedBox(height: 4),
          //           Text(c['title'] ?? "",
          //               textAlign: TextAlign.center,
          //               style: TextStyles.defaultStyle.copyWith(
          //                   fontSize: 10,
          //                   color: ColorPalette.textColorBlack,
          //                   fontWeight: FontWeight.w500)),
          //         ],
          //       ),
          //     ),
          //   );
          // }).toList(),
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
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.CITY_DETAIL, arguments: city);
                },
                child: Card(
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
                ),
              );
            }),
      ),
    );
  }

  Widget buildActivities() {
    final List<Map<String, dynamic>> activities = controller.activities.value;
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
        padding: const EdgeInsets.symmetric(horizontal: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemCount: destinations.length,
        itemBuilder: (_, index) {
          final destination = destinations[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.DESTINATION_DETAIL, arguments: destination);
            },
            child: Card(
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
                  const SizedBox(height: 4),
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
            ),
          );
        });
  }

  void showChooseCityModal(String route) {
    Get.bottomSheet(
      Obx(() {
        return Container(
          height: Get.height * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Chọn thành phố',
              style: TextStyles.defaultStyle
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.locationDot,
                  size: 16,
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  width: 4,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Thành phố hiện tại:',
                        style: TextStyles.defaultStyle.copyWith(
                            fontSize: 12, color: ColorPalette.textColorBlack),
                        children: [
                      TextSpan(
                        text: ' ${controller.currentCity.value}',
                        style: TextStyles.defaultStyle.copyWith(
                            fontSize: 14,
                            color: ColorPalette.primaryColor,
                            fontWeight: FontWeight.w500),
                      )
                    ]))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SearchInput(
                controller: controller.searchController,
                searchValue: "",
                onClearSearch: () {}),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SmartRefresher(
                controller: controller.cityRefreshController,
                enablePullDown: false,
                enablePullUp: controller.loadingCity.value ? false : true,
                onLoading: () => controller.getListCity(
                    isLoadFull: true,
                    isSearch: controller.searchController.text.isNotEmpty),
                child: GridView.builder(
                    itemCount: controller.listCityFull.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            childAspectRatio: 16 / 9,
                            mainAxisSpacing: 8),
                    itemBuilder: (_, index) {
                      final city = controller.listCityFull[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 120,
                          height: 60,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                      imageUrl: city["image_url"],
                                      fit: BoxFit.cover),
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
            )
          ]),
        );
      }),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: false,
            enablePullUp: controller.loadingDestination.value ? false : true,
            onLoading: () => controller.loadDestination(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 100,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  title: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.LIST_DESTINATIONS);
                    },
                    child: Container(
                      height: 32,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 0.5),
                          borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: 14,
                            color: Colors.blueGrey,
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
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorPalette.primaryColor.withOpacity(0.2),
                              ColorPalette.primaryColor
                            ],
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.locationDot,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(controller.currentPlace.value,
                                      style: TextStyles.defaultStyle.copyWith(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
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
                            GestureDetector(
                              onTap: () {
                                showChooseCityModal(
                                    AppRoutes.LIST_DESTINATIONS);
                              },
                              child: Text(
                                'Xem thêm',
                                style: TextStyles.defaultStyle.primaryTextColor,
                              ),
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
                )
              ],
            ),
          ),
        ));
  }
}
