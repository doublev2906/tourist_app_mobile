import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tourist_app_mobille/controllers/destination_detail_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/core/constants/constants.dart';

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  SectionHeaderDelegate({this.height = 50, required this.child});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12), child: child),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DestinationDetailPage extends StatelessWidget {
  DestinationDetailPage({super.key});

  final destination = Get.arguments ?? {};
  final controller = Get.put(DestinationDetailController());

  Widget buildDestinationInfo() {
    final basicInfo = destination["extra_info"]["overview_data"]?["basicInfo"];
    final openTime = destination["extra_info"]["open_time"];
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 12),
      width: Get.width,
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    destination["name"],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 8),
              Divider(
                height: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  openTime["openTimeDesc"],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0f294d),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      FontAwesomeIcons.locationDot,
                      size: 14,
                      color: Color(0xFF0f294d),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        basicInfo?["address"] ?? "Address",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0f294d),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListReviewTab() {
    final reviews =
        ((controller.destinationData.value["reviews"] ?? []) as List)
            .cast<Map<String, dynamic>>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Đánh giá",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF0f294d),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "4.5",
                style: TextStyle(
                  fontSize: 18,
                  color: ColorPalette.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "/5",
                style: TextStyle(
                  fontSize: 12,
                  color: ColorPalette.text1Color,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: " Nổi trội",
                style: TextStyle(
                  fontSize: 12,
                  color: ColorPalette.primaryColor,
                ),
              ),
              TextSpan(
                text: "   600 đánh giá",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff8592a6),
                ),
              ),
            ])),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          height: 1,
          width: Get.width,
          color: Colors.grey.withOpacity(0.1),
        ),
        reviews.isEmpty
            ? const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(
                  child: Text("Chưa có đánh giá nào"),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 12, bottom: 80),
                itemCount: reviews.length,
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.grey[200],
                  );
                },
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final date = DateTime.parse(review["inserted_at"]).toLocal();
                  final formattedDate = DateFormat.yMMMd("vi_VN").format(date);
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const CircleAvatar(
                            radius: 14,
                            backgroundColor: ColorPalette.primaryColor,
                            child: Icon(
                              FontAwesomeIcons.userSecret,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            review["from"]?["name"] ?? "Anonymous",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0f294d),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 4),
                                decoration: BoxDecoration(
                                  color: ColorPalette.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: review["rating"].toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "/5",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff8592a6),
                                ),
                              ),
                            ]),
                        const SizedBox(height: 8),
                        Html(
                          data: review["content"],
                          style: {
                            "body": Style(
                              padding: HtmlPaddings.zero,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 6,
                              color: ColorPalette.textColorBlack,
                              fontSize: FontSize(12),
                              margin: Margins(
                                bottom: Margin.zero(),
                                left: Margin.zero(),
                                top: Margin.zero(),
                                right: Margin.zero(),
                              ),
                            ),
                          },
                        ),
                        const SizedBox(height: 8),
                        if (review["images"].isNotEmpty)
                          SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: review["images"].length,
                                itemBuilder: (context, index) {
                                  final image = review["images"][index];
                                  return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: 80,
                                      height: 80,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: CachedNetworkImage(
                                          imageUrl: image,
                                          fit: BoxFit.cover,
                                        ),
                                      ));
                                },
                              ))
                      ]);
                },
              ),
      ],
    );
  }

  Widget buildListMomentTab() {
    final moments =
        ((controller.destinationData.value["moments"] ?? []) as List)
            .cast<Map<String, dynamic>>();
    return Container(
      constraints: const BoxConstraints(
        minHeight: 600,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Khoảnh khắc du lịch",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF0f294d),
              fontWeight: FontWeight.w500,
            ),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 174,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: moments.length,
            padding: const EdgeInsets.only(bottom: 80),
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
                        height: 100,
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
      ),
    );
  }

  Widget buildReviewTab() {
    const tabs = [
      {
        "id": "review",
        "title": "Đánh giá",
      },
      {
        "id": "moment",
        "title": "Khoảnh khắc du lich",
      }
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemBuilder: (context, index) {
                  return Obx(() {
                    final tab = tabs[index];
                    final isSelected =
                        controller.reviewSelectTab.value == tab["id"];
                    return GestureDetector(
                      onTap: () {
                        controller.reviewSelectTab(tab["id"]);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorPalette.primaryColor
                              : Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tab["title"] ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : ColorPalette.text1Color,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            controller.reviewSelectTab.value == "review"
                ? buildListReviewTab()
                : buildListMomentTab(),
          ],
        ),
      ),
    );
  }

  Widget buildNearByHotels(Map<String, dynamic> nearByData) {
    final listData =
        ((nearByData["itemList"] ?? []) as List).cast<Map<String, dynamic>>();
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final data = listData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: data["image"],
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          for (int i = 0; i < (data["star"] as double); i++)
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
                        children: [
                          const Icon(
                            FontAwesomeIcons.locationDot,
                            size: 12,
                            color: Color(0xFF0f294d),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data["distanceDesc"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0f294d),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 4),
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(
                              text: "Từ ",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0f294d),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: currencyFormatter
                                  .format(data["minPrice"] as double),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0f294d),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ])),
                        ],
                      )
                    ],
                  ),
                ),
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
        itemCount: listData.length);
  }

  Widget buildNearByDestination(Map<String, dynamic> nearByData) {
    final listData =
        ((nearByData["itemList"] ?? []) as List).cast<Map<String, dynamic>>();
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final data = listData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: data["image"],
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
                      if (data["statusInfo"]?["openTimeDesc"] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          data["statusInfo"]?["openTimeDesc"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0f294d),
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.fire,
                              size: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              data["hotScore"].toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.locationDot,
                            size: 12,
                            color: Color(0xFF0f294d),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data["distanceDesc"],
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
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey[200],
          );
        },
        itemCount: listData.length);
  }

  Widget buildNearByRestaurant(Map<String, dynamic> nearByData) {
    final listData =
        ((nearByData["itemList"] ?? []) as List).cast<Map<String, dynamic>>();
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final data = listData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: data["image"],
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
                        height: 6,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.restaurant_outlined,
                            size: 14,
                            color: Color(0xFF0f294d),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (data["tagInfoList"] ?? [])[0]["tagName"] ??
                                "Thức ăn đường phố",
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
                          const SizedBox(width: 4),
                          Text(
                            data["distanceDesc"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0f294d),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.moneyBill,
                            size: 12,
                            color: Color(0xFF0f294d),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            currencyFormatter.format(data["avgPrice"] ?? 0),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0f294d),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
        itemCount: listData.length);
  }

  Widget buildNearByShop(Map<String, dynamic> nearByData) {
    final listData =
        ((nearByData["itemList"] ?? []) as List).cast<Map<String, dynamic>>();
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final data = listData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: data["image"],
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
                        height: 6,
                      ),
                      Container(
                        width: 40,
                        height: 20,
                        decoration: BoxDecoration(
                            color: ColorPalette.primaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: data["score"].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "/5",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.locationDot,
                            size: 12,
                            color: Color(0xFF0f294d),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data["distanceDesc"],
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
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey[200],
          );
        },
        itemCount: listData.length);
  }

  Widget buildNearByContent() {
    final nearbyModuleList =
        ((controller.destinationData.value["nearbyModuleList"] ?? []) as List)
            .cast<Map<String, dynamic>>();
    final nearByType = controller.nearByType.value;
    final nearByData = nearbyModuleList.firstWhere(
        (element) => element["subModuleType"] == nearByType,
        orElse: () => {});
    print(nearByType);
    switch (nearByType) {
      case "nearbyHotel":
        return buildNearByHotels(nearByData);
      case "nearbySight":
        return buildNearByDestination(nearByData);
      case "nearbyRestaurant":
        return buildNearByRestaurant(nearByData);
      case "nearbyShop":
        return buildNearByShop(nearByData);
      default:
        return Container();
    }
  }

  Widget buildNearByTab() {
    final nearbyModuleList =
        ((controller.destinationData.value["nearbyModuleList"] ?? []) as List)
            .cast<Map<String, dynamic>>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: nearbyModuleList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemBuilder: (context, index) {
                  return Obx(() {
                    final tab = nearbyModuleList[index];
                    final isSelected =
                        controller.nearByType.value == tab["subModuleType"];
                    return GestureDetector(
                      onTap: () {
                        controller.nearByType(tab["subModuleType"]);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorPalette.primaryColor
                              : Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tab["subModuleName"] ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : ColorPalette.text1Color,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            Container(
                constraints: const BoxConstraints(
                  minHeight: 400,
                ),
                child: buildNearByContent())
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.blueGrey[50],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Obx(() {
            if (controller.loadingData.value ||
                controller.currentTabIndex.value == 1) {
              return const SizedBox();
            }
            final isReviewTab = controller.reviewSelectTab.value == "review";
            return controller.isTabPinned.value
                ? SizedBox(
                    height: 32,
                    child: FittedBox(
                      child: FloatingActionButton.extended(
                          onPressed: () {
                            controller.scrollController.animateTo(0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          icon: Icon(
                            isReviewTab
                                ? FontAwesomeIcons.pencil
                                : FontAwesomeIcons.camera,
                            color: Colors.white,
                            size: 14,
                          ),
                          backgroundColor: ColorPalette.primaryColor,
                          label: Text(
                            isReviewTab
                                ? "Viết đánh giá"
                                : "Chia sẻ khoảnh khắc",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )),
                    ),
                  )
                : const SizedBox();
          }),
          body: Obx(() {
            if (controller.loadingData.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 150,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  leadingWidth: 40,
                  elevation: 0,
                  title: controller.isExpand.value
                      ? null
                      : Text(
                          destination['name'],
                          style: const TextStyle(
                            color: ColorPalette.text1Color,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: destination["cover_image_url"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: buildDestinationInfo(),
                ),
                SliverPersistentHeader(
                  delegate: SectionHeaderDelegate(
                      child: TabBar(
                    indicatorColor: Colors.indigoAccent,
                    indicatorPadding:
                        const EdgeInsets.only(top: 4, left: 12, right: 12),
                    unselectedLabelStyle:
                        const TextStyle(fontSize: 15, color: Color(0xFF0f294d)),
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent),
                    indicatorSize: TabBarIndicatorSize.label,
                    onTap: controller.currentTabIndex.call,
                    tabs: const [
                      Tab(
                        text: "Đánh giá",
                      ),
                      Tab(
                        text: "Gần đây",
                      ),
                    ],
                  )),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                    child: Container(
                  color: Colors.white,
                  child: ContentSizeTabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [buildReviewTab(), buildNearByTab()],
                  ),
                ))
              ],
            );
          })),
    );
  }
}
