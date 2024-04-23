import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tourist_app_mobille/controllers/trip_detail_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';
import 'package:tourist_app_mobille/util/action.dart';
import 'package:tourist_app_mobille/widgets/default_none_bg_item.dart';
import 'package:tourist_app_mobille/widgets/destination_item.dart';

class TripDetailView extends GetView<TripDetailController> {
  TripDetailView({super.key});

  final trip = Get.arguments;
  final currentDay = setDateTimeToZero(DateTime.now());

  Widget buildEmptyDestination() {
    return SizedBox(
      height: 300,
      width: Get.width,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: ColorPalette.primaryColor,
                child: Icon(
                  PhosphorIconsBold.airplaneInFlight,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Thêm vào Chuyến đi của bạn",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.textColorBlack,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Tìm địa điểm du lịch và nhấn vào đó để lưu các địa điểm đó ở đây.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: ColorPalette.textColorBlack,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Get.toNamed(AppRoutes.SEARCH_DESTINATION);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Khám phá",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDivider({double top = 16}) {
    return Container(
      margin: EdgeInsets.only(top: top),
      height: 1,
      color: Colors.grey.shade300,
    );
  }

  void showBottomSheetPickDate() {
    final tripData = controller.tripData;
    DateTime? startDate = tripData["start_at"] != null
        ? DateTime.parse(tripData["start_at"])
        : null;
    DateTime? endDate =
        tripData["end_at"] != null ? DateTime.parse(tripData["end_at"]) : null;

    final initDates = startDate != null && endDate != null
        ? [startDate, endDate]
        : [currentDay];
    Get.bottomSheet(Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 24),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
                selectedDayHighlightColor: ColorPalette.primaryColor,
                selectableDayPredicate: (DateTime date) {
                  return date.isAfter(
                      getCurrentTime().subtract(const Duration(days: 1)));
                }),
            value: initDates,
            onValueChanged: (dates) {
              if (dates.length == 2) {
                startDate = dates[0];
                endDate = dates[1];
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                  onPressed: () {
                    controller.addDateToTrip(null, null);
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    foregroundColor: ColorPalette.text1Color,
                  ),
                  child: const Text("Đặt lại")),
              ElevatedButton(
                onPressed: () {
                  if (startDate != null && endDate != null) {
                    controller.addDateToTrip(
                        setDateTimeToZero(startDate!).toIso8601String(),
                        setDateTimeToZero(endDate!).toIso8601String());
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Áp dụng"),
              ),
            ],
          )
        ])));
  }

  void showBottomSheetPickDestination(int index, List<String> listDays) {
    final dayDestinations =
        (((controller.tripData["destinations_plan"] ?? {})["$index"] ?? [])
                as List)
            .cast<String>();
    final destinationsSelected = RxList<String>(dayDestinations);
    Get.bottomSheet(
      Obx(() {
        return Container(
            height: Get.height * 0.7,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Thêm vào ${listDays[index]}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.textColorBlack,
                        ),
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: controller.listDestination.map((destination) {
                          final index =
                              controller.listDestination.indexOf(destination);
                          return Column(
                            children: [
                              if (index == 0) buildDivider(top: 0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: destination[
                                                  "cover_image_url"],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              destination["name"],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color:
                                                    ColorPalette.textColorBlack,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                        activeColor: ColorPalette.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        side: const BorderSide(
                                            color: ColorPalette.primaryColor,
                                            width: 1.5),
                                        value: destinationsSelected
                                            .contains(destination["id"]),
                                        onChanged: (value) {
                                          if (value != null) {
                                            if (value) {
                                              destinationsSelected
                                                  .add(destination["id"]);
                                            } else {
                                              destinationsSelected
                                                  .remove(destination["id"]);
                                            }
                                          }
                                        })
                                  ],
                                ),
                              ),
                              if (index < controller.listDestination.length - 1)
                                buildDivider(top: 0)
                            ],
                          );
                        }).toList(),
                      ),
                    ))
                  ]),
                ),
                buildDivider(),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: ColorPalette.text1Color,
                          ),
                          child: const Text("Đặt lại")),
                      ElevatedButton(
                        onPressed: () {
                          controller
                              .addDestinationsToDay(index, destinationsSelected)
                              .then((value) {
                            Get.back();
                            showNotificationSuccess(
                                "Cập nhật điểm đến thành công");
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Áp dụng"),
                      ),
                    ],
                  ),
                )
              ],
            ));
      }),
      isScrollControlled: true,
    );
  }

  void showAllDestinationOfTrip() {
    Get.bottomSheet(
      Obx(() {
        return Container(
          height: Get.height * 0.7,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Tất cả địa điểm",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorPalette.textColorBlack,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.listDestination.map((destination) {
                      return DestinationItem(
                        data: destination,
                        mainAxisAlignment: MainAxisAlignment.center,
                        onDelete: (id) {
                          controller.deleteDestinationFromTrip(id);
                        },
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget buildSelectDate() {
    final tripData = controller.tripData;
    final endAtString = tripData["end_at"];
    final startAtString = tripData["start_at"];

    if (endAtString == null || endAtString == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            OutlinedButton(
                onPressed: () {
                  showBottomSheetPickDate();
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: ColorPalette.text1Color,
                ),
                child: const Row(
                  children: [
                    Icon(
                      PhosphorIconsRegular.calendar,
                      color: ColorPalette.text1Color,
                      size: 18,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Thêm ngày du lịch",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                )),
          ],
        ),
      );
    }

    final startDate = DateTime.parse(startAtString);
    final endDate = DateTime.parse(endAtString);
    final difference = endDate.difference(startDate).inDays;
    final listDays = [
      "Tất cả",
      for (int i = 0; i <= difference; i++)
        controller.formatDateText(currentDay,
            startDate.add(Duration(days: i)).difference(currentDay).inDays),
    ];
    final defaultOutlineStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      side: const BorderSide(color: ColorPalette.text1Color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      foregroundColor: ColorPalette.text1Color,
    );
    return SizedBox(
      height: 32,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          OutlinedButton(
              onPressed: () {
                showBottomSheetPickDate();
              },
              style: defaultOutlineStyle,
              child: Row(
                children: [
                  const Icon(
                    PhosphorIconsRegular.calendar,
                    color: ColorPalette.text1Color,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    controller.formatDateTextRange(startDate, endDate),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              )),
          for (int i = 0; i < listDays.length; i++) ...[
            const SizedBox(width: 8),
            OutlinedButton(
                onPressed: () {
                  controller.indexDaySelect(i);
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  side: BorderSide(
                      color: controller.indexDaySelect.value == i
                          ? ColorPalette.text1Color
                          : Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: ColorPalette.text1Color,
                ),
                child: Text(
                  listDays[i],
                  style: const TextStyle(fontSize: 13),
                )),
          ]
        ],
      ),
    );
  }

  Widget buildDefaultDatePlanItem(int index, List<String> listDays) {
    final destinationSelected =
        (((controller.tripData["destinations_plan"] ?? {})["$index"] ?? [])
                as List)
            .cast<String>();
    final listDestinations = controller.listDestination
        .where((element) => destinationSelected.contains(element["id"]))
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        Text(
          listDays[index],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ColorPalette.textColorBlack,
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            onPressed: () {
              showBottomSheetPickDestination(index, listDays);
            },
            child: const Text("Thêm vào ngày",
                style: TextStyle(
                    fontSize: 13,
                    color: ColorPalette.text1Color,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500))),
        ...listDestinations.map((e) {
          return DestinationItem(
            data: e,
            padding: const EdgeInsets.only(top: 8),
            showOpenStatus: true,
          );
        }),
        Container(
          margin: const EdgeInsets.only(top: 16),
          height: 1,
          color: Colors.grey.shade300,
        )
      ]),
    );
  }

  Widget buildAllDatePlan() {
    final tripData = controller.tripData;
    final listDays = controller.getListDay();
    if (listDays == null) {
      return const SizedBox();
    }
    print(listDays);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (int i = 0; i < listDays.length; i++) ...[
        buildDefaultDatePlanItem(i, listDays),
      ]
    ]);
  }

  Widget buildDestinationsOfDate(int index) {
    final destinationSelected =
        (((controller.tripData["destinations_plan"] ?? {})["$index"] ?? [])
                as List)
            .cast<String>();
    final listDestinations = controller.listDestination
        .where((element) => destinationSelected.contains(element["id"]))
        .toList();
    if (listDestinations.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: buildDivider(top: 4),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  const Text(
                    "Lên kế hoạch cho ngày bằng cách thêm các địa điểm đã lưu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorPalette.textColorBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          showBottomSheetPickDestination(
                              index, controller.getListDay()!);
                        },
                        child: const Text("Thêm địa điểm")),
                  )
                ],
              )),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 200),
      child: Column(
        children: [
          ...listDestinations.map((e) {
            return DestinationItem(
              data: e,
              padding: const EdgeInsets.only(top: 8),
              showOpenStatus: true,
            );
          }),
          buildDivider(),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  showBottomSheetPickDestination(
                      index, controller.getListDay()!);
                },
                child: const Text(
                  "Thêm địa điểm",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorPalette.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildData() {
    final body = controller.indexDaySelect.value == 0
        ? buildAllDatePlan()
        : buildDestinationsOfDate(controller.indexDaySelect.value - 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSelectDate(),
        const SizedBox(height: 12),
        body,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.LIST_DESTINATIONS,
              arguments: {"isFromTrip": true});
        },
        backgroundColor: ColorPalette.primaryColor,
        child: const Icon(
          PhosphorIconsBold.plus,
          color: Colors.white,
          size: 24,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showAllDestinationOfTrip();
            },
            icon: const Icon(
              PhosphorIconsFill.listBullets,
              color: ColorPalette.text1Color,
              size: 24,
            ),
          )
        ],
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
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
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final tripData = controller.tripData;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 180,
                child: controller.listDestination.isEmpty
                    ? const DefaultNoneBgItem()
                    : GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.MAP_VIEW,
                            arguments: {
                              "tripData": tripData,
                              "listDestination": controller.listDestination
                            }),
                        child: CachedNetworkImage(
                          imageUrl: controller.getImageOfListDestination(),
                          placeholder: (context, url) => const Center(
                            child: CupertinoActivityIndicator(
                              radius: 10,
                            ),
                          ),
                          width: Get.width,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tripData["name"],
                              style: const TextStyle(
                                fontSize: 24,
                                color: ColorPalette.textColorBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${controller.listDestination.length} điểm đến',
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColorPalette.textColorBlack,
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 16),
                    ((tripData["list_destinations"] ?? []) as List).isEmpty
                        ? buildEmptyDestination()
                        : _buildData(),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
