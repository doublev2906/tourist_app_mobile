import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tourist_app_mobille/controllers/trips_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/core/helpers/asset_helper.dart';
import 'package:tourist_app_mobille/core/helpers/image_helper.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';

class TripView extends GetView<TripsController> {
  const TripView({super.key});

  void showCreateNewTripDialog() {
    final nameController = TextEditingController();
    Get.defaultDialog(
      title: 'Tạo chuyến đi mới',
      titlePadding: const EdgeInsets.only(top: 20),
      titleStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tên chuyến đi',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                hintText: 'Ví dụ: Du lịch Hà Nội',
                hintStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    )),
                fillColor: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.createTrip(nameController.text);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Tạo chuyến đi',
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildNoneBgItem() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff8F67E8), Color(0xff6357CC)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: ImageHelper.loadFromAsset(
            AssetHelper.icoOvalTop,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ImageHelper.loadFromAsset(
            AssetHelper.icoOvalBottom,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: showCreateNewTripDialog,
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.add),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            title: const Text(
              'Chuyến đi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
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
            ),
          ),
        ),
        body: Obx(() {
          if (controller.loadingTrips.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: controller.trips.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final trip = controller.trips[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.TRIP_DETAIL, arguments: trip["id"]);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          Positioned.fill(child: buildNoneBgItem()),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    PhosphorIconsBold.airplaneInFlight,
                                    color: ColorPalette.text1Color,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${((trip["list_destinations"] ?? []) as List).length} điểm đến',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorPalette.text1Color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      trip['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorPalette.text1Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }));
  }
}
