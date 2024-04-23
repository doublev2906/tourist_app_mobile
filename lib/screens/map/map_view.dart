import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tourist_app_mobille/controllers/map_view_controller.dart';
import 'package:tourist_app_mobille/util/geo_apify.dart';
import 'dart:math' as math;

import 'package:tourist_app_mobille/widgets/destination_item.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  final tripData = Get.arguments["tripData"] ?? {};

  final listDestination = ((Get.arguments["listDestination"] ?? []) as List)
      .cast<Map<String, dynamic>>();

  final MapController mapController = MapController();
  final CarouselController carouselController = CarouselController();

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // final check = RxBool(false);
    final indexPage = RxInt(0);
    final List<LatLng> markers = listDestination
        .map((e) =>
            LatLng(e["coordinates"]["latitude"], e["coordinates"]["longitude"]))
        .toList()
        .cast<LatLng>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          tripData["name"] ?? "",
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
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
        return Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCameraFit: CameraFit.coordinates(
                        coordinates: markers,
                        maxZoom: 17,
                        padding: const EdgeInsets.fromLTRB(
                            20, 20, 20, 200)), // Initial position
                  ),
                  children: [
                    TileLayer(
                        urlTemplate: GeoApify().getTileLayerUrl(),
                        tileProvider: CancellableNetworkTileProvider(),
                        tileUpdateTransformer:
                            _animatedMoveTileUpdateTransformer), // Tile layer URL template
                    MarkerLayer(
                      markers: markers.map((marker) {
                        final check =
                            indexPage.value == markers.indexOf(marker);
                        return Marker(
                          width: !check ? 40 : 50,
                          height: !check ? 40 : 50,
                          point: marker,
                          child: GestureDetector(
                            onTap: () {
                              // _animatedMapMove(marker, 14);
                              // indexPage(markers.indexOf(marker));
                              int index = markers.indexOf(marker);
                              carouselController.animateToPage(index);
                            },
                            child: Image.asset(
                              !check
                                  ? "assets/icons/location_small.png"
                                  : "assets/icons/location_large.png",
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ]),
            ),
            Positioned(
                bottom: 30,
                left: 0,
                child: SizedBox(
                  height: 150,
                  width: Get.width,
                  child: CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          indexPage(index);
                          _animatedMapMove(markers[index],
                              math.max(14, mapController.camera.zoom));
                        },
                        viewportFraction: 0.85,
                        height: 120,
                        enableInfiniteScroll: false),
                    items: listDestination
                        .map((e) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5))
                                  ]),
                              child: DestinationItem(
                                data: e,
                                mainAxisAlignment: MainAxisAlignment.center,
                                showOpenStatus: true,
                              ),
                            ))
                        .toList(),
                  ),
                ))
          ],
        );
      }),
    );
  }
}

final _animatedMoveTileUpdateTransformer =
    TileUpdateTransformer.fromHandlers(handleData: (updateEvent, sink) {
  final mapEvent = updateEvent.mapEvent;

  final id = mapEvent is MapEventMove ? mapEvent.id : null;
  if (id?.startsWith(_MapPageState._startedId) ?? false) {
    final parts = id!.split('#')[2].split(',');
    final lat = double.parse(parts[0]);
    final lon = double.parse(parts[1]);
    final zoom = double.parse(parts[2]);

    // When animated movement starts load tiles at the target location and do
    // not prune. Disabling pruning means existing tiles will remain visible
    // whilst animating.
    sink.add(
      updateEvent.loadOnly(
        loadCenterOverride: LatLng(lat, lon),
        loadZoomOverride: zoom,
      ),
    );
  } else if (id == _MapPageState._inProgressId) {
    // Do not prune or load whilst animating so that any existing tiles remain
    // visible. A smarter implementation may start pruning once we are close to
    // the target zoom/location.
  } else if (id == _MapPageState._finishedId) {
    // We already prefetched the tiles when animation started so just prune.
    sink.add(updateEvent.pruneOnly());
  } else {
    sink.add(updateEvent);
  }
});
