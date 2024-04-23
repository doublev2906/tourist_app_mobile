import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tourist_app_mobille/controllers/city_detail_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/core/constants/constants.dart';
import 'package:tourist_app_mobille/core/constants/textstyle_ext.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';

class CityDetailPage extends StatelessWidget {
  CityDetailPage({super.key});
  final city = Get.arguments ?? {};
  final controller =
      Get.put(CityDetailController(), tag: (Get.arguments ?? {})['id'] ?? "");

  Widget buildCategories() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((c) {
        return Expanded(
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
        );
      }).toList(),
    );
  }

  Widget buildCityInstruction() {
    final cityInfo = controller.cityDetailData.value['city_info'];
    final travelTipModule = cityInfo?["travelTipModule"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cityInfo?["name"] ?? "",
          style: const TextStyle(
            color: ColorPalette.text1Color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Html(
          data: travelTipModule?["introduction"] ?? "",
          style: {
            "body": Style(
              padding: HtmlPaddings.zero,
              color: ColorPalette.text1Color.withOpacity(0.9),
              fontSize: FontSize(13),
              margin: Margins(
                bottom: Margin.zero(),
                left: Margin.zero(),
                top: Margin.zero(),
                right: Margin.zero(),
              ),
            ),
          },
        ),
      ],
    );
  }

  Widget buildSuggestDestination() {
    final List<Map<String, dynamic>> destination =
        ((controller.cityDetailData.value['destination'] ?? []) as List)
            .cast<Map<String, dynamic>>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Điểm tham quan đề xuất",
          style: TextStyle(
            color: ColorPalette.text1Color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: destination.length,
            padding: const EdgeInsets.only(left: 4),
            itemBuilder: (context, index) {
              final item = destination[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.DESTINATION_DETAIL,
                      arguments: item, preventDuplicates: false);
                },
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(right: 8, bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: CachedNetworkImage(
                            imageUrl: item['cover_image_url'],
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorPalette.text1Color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
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
                                      item["hot_score"].toString(),
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
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildSuggestHotel() {
    final List<Map<String, dynamic>> hotel =
        ((controller.cityDetailData.value['hotel'] ?? []) as List)
            .cast<Map<String, dynamic>>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Khách sạn đề xuất",
          style: TextStyle(
            color: ColorPalette.text1Color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 168,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hotel.length,
            padding: const EdgeInsets.only(left: 4),
            itemBuilder: (context, index) {
              final item = hotel[index];
              final commentInfo = item["comment_info"];
              final score = commentInfo["commentScore"];
              final hotelStar = (item["hotel_star_info"] as double).toInt();
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: item['hotel_img']
                              .toString()
                              .replaceAll("_.webp", ""),
                          height: 90,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['hotel_name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: ColorPalette.text1Color,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                for (int i = 0; i < hotelStar; i++)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 2),
                                    child: Icon(
                                      FontAwesomeIcons.solidStar,
                                      color: Colors.orange,
                                      size: 11,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.deepOrangeAccent,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    "$score/5",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  currencyFormatter.format(item["price"] ?? 0),
                                  style: const TextStyle(
                                      color: ColorPalette.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildSuggestRestaurant() {
    final List<Map<String, dynamic>> restaurant =
        (controller.cityDetailData.value['restaurant'] as List)
            .cast<Map<String, dynamic>>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nhà hàng đề xuất",
          style: TextStyle(
            color: ColorPalette.text1Color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 168,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: restaurant.length,
            padding: const EdgeInsets.only(left: 4),
            itemBuilder: (context, index) {
              final item = restaurant[index];
              final extraInfo = item["extra_info"];
              final tags =
                  (extraInfo["tags"] as List).cast<Map<String, dynamic>>();
              final tagName = tags.map((e) => e["tagName"]).join(", ");
              final rating = item["rating"];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: item['cover_image_url'],
                          height: 90,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: ColorPalette.text1Color,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 4),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                "$rating/5",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tagName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
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
        )
      ],
    );
  }

  Widget buildCityNearBy() {
    final List<Map<String, dynamic>> cityNearBy =
        ((controller.cityDetailData.value['city_near_by'] ?? []) as List)
            .cast<Map<String, dynamic>>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Điểm đến gần đây",
          style: TextStyle(
            color: ColorPalette.text1Color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 204,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cityNearBy.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final item = cityNearBy[index];
              final distance = ((item["distance"] as double) / 1000).round();
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.CITY_DETAIL,
                      arguments: item, preventDuplicates: false);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: 150,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item['image_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                            child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 8,
                                left: 12,
                                child: Text(
                                  item["name"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Cách Khoảng",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "$distance",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: " km",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ))
                                  ],
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
            },
          ),
        )
      ],
    );
  }

  Widget buildMoments() {
    final List<Map<String, dynamic>> moments =
        ((controller.cityDetailData.value['moments'] ?? []) as List)
            .cast<Map<String, dynamic>>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Khám phá ${city['name']}",
          style: const TextStyle(
            color: ColorPalette.text1Color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisCount: 2,
          //   crossAxisSpacing: 8,
          //   mainAxisSpacing: 8,
          // ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: moments.length,
          padding: const EdgeInsets.only(bottom: 40),
          itemBuilder: (BuildContext context, int index) {
            final moment = moments[index];
            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: moment["cover_image"],
                      fit: BoxFit.cover,
                      height: 160,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Text(
                            moment["content"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0f294d),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 8,
                              backgroundColor: ColorPalette.primaryColor,
                              child: Icon(
                                FontAwesomeIcons.userSecret,
                                size: 8,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                moment["from"]?["name"] ?? "Anonymous",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF0f294d),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.heart,
                                  size: 10,
                                  color: Color(0xFF0f294d),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  moment["like_info"]?["like_count"] ?? "0",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF0f294d),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  void showWeatherBottomSheet() {
    final cityInfo = controller.cityDetailData.value['city_info'];
    final weatherModule =
        cityInfo?["travelTipModule"]?["weather"]?["weatherModule"];
    final futureWeather = ((weatherModule?["futureWeather"] ?? []) as List)
        .cast<Map<String, dynamic>>();
    final todayWeather = weatherModule?["todayWeather"] ?? {};
    Get.bottomSheet(Container(
      height: 280,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 6,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
              child: SizedBox(
            width: Get.width,
            child: Column(
              children: [
                const Text(
                  "Hôm Nay",
                  style: TextStyle(
                    color: ColorPalette.text1Color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  todayWeather["date"] ?? "",
                  style: const TextStyle(
                      color: Color.fromRGBO(69, 88, 115, 1),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  "${todayWeather["temperatureRange"]["min"]}°",
                  style: const TextStyle(
                    color: ColorPalette.text1Color,
                    fontSize: 60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${todayWeather["weatherName"] ?? ""} ${todayWeather["temperatureRange"]["min"]}°C/${todayWeather["temperatureRange"]["max"]}°C",
                  style: const TextStyle(
                    color: Color.fromRGBO(69, 88, 115, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${weatherModule["weatherIndicatorDesc"]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(69, 88, 115, 1),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${weatherModule["weatherTitle"]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(69, 88, 115, 1),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          return CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                stretch: true,
                title: Text(
                  city['name'],
                  style: TextStyle(
                    color: controller.isExpand.value
                        ? Colors.white
                        : ColorPalette.text1Color,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                elevation: 0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                leadingWidth: 40,
                leading: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: Get.back,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: city['image_url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                          child:
                              Container(color: Colors.black.withOpacity(0.3))),
                      Positioned(
                          bottom: 38,
                          left: 16,
                          child: GestureDetector(
                            onTap: showWeatherBottomSheet,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.cloud,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 8),
                                  Text("Thời tiết",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: controller.isExpand.isFalse
                      ? const SizedBox()
                      : Container(
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 0.0,
                                spreadRadius: 1.0,
                                offset: Offset(0, 0),
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          )),
                ),
              ),
              controller.loadingCityDetail.value &&
                      controller.cityDetailData.value.isEmpty
                  ? SliverToBoxAdapter(
                      child: SizedBox(
                      height: Get.height - 250,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ))
                  : SliverToBoxAdapter(
                      child: SizedBox(
                        width: Get.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildCityInstruction(),
                              const SizedBox(height: 16),
                              buildSuggestDestination(),
                              const SizedBox(height: 12),
                              // buildSuggestHotel(),
                              // const SizedBox(height: 16),
                              // buildSuggestRestaurant(),
                              // const SizedBox(height: 16),
                              buildCityNearBy(),
                              const SizedBox(height: 12),
                              buildMoments()
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          );
        }));
  }
}
