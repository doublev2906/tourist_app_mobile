import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tourist_app_mobille/controllers/list_destinations_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/widgets/search_input.dart';

class ListDestinationsView extends StatelessWidget {
  ListDestinationsView({super.key});

  final controller = Get.put(ListDestinationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Get.back();
            },
          ),
          leadingWidth: 30,
          titleSpacing: 20,
          title: SearchInput(
            controller: TextEditingController(),
            searchValue: "",
            placeHolder: "Tìm kiếm địa điểm tham quan",
            onClearSearch: () {},
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(32),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              height: 32,
              child: Row(
                children: [
                  const Expanded(
                    child: Row(children: [
                      Text(
                        "Thành phố",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorPalette.textColorBlack,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, size: 18)
                    ]),
                  ),
                  Container(
                    color: Colors.grey[300],
                    width: 2,
                    height: 12,
                  ),
                  const Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bộ lọc",
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorPalette.textColorBlack,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, size: 18)
                        ]),
                  ),
                  Container(
                    color: Colors.grey[300],
                    width: 2,
                    height: 12,
                  ),
                  const Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Sắp xếp",
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorPalette.textColorBlack,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, size: 18)
                        ]),
                  ),
                ],
              ),
            ),
          )),
      body: Obx(() {
        final listData = controller.listDestination;
        if (controller.loadingDestination.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: false,
          enablePullUp: controller.loadingDestination.value ? false : true,
          onLoading: () => controller.getDestination(),
          child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 80, top: 20),
              itemBuilder: (_, index) {
                final data = listData[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: data["cover_image_url"],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data["name"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF0f294d),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    width: 40,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.fire,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          data["hot_score"].toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_city,
                                        size: 14,
                                        color: Color(0xFF0f294d),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        data["city_name"] ?? "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0f294d),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.locationDot,
                                        size: 12,
                                        color: Color(0xFF0f294d),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Cách bạn ${((data["distance"] ?? 0) as double).toStringAsFixed(2)} km",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0f294d),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.addDestinationToTrip(data);
                        },
                        icon: const Icon(
                          PhosphorIconsRegular.heart,
                          size: 20,
                          color: ColorPalette.text1Color,
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.grey[200],
                );
              },
              itemCount: listData.length),
        );
      }),
    );
  }
}
