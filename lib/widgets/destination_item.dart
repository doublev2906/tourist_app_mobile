import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';

class DestinationItem extends StatelessWidget {
  const DestinationItem(
      {super.key,
      required this.data,
      this.onTap,
      this.showHeart = false,
      this.padding = const EdgeInsets.all(8),
      this.showCity = false,
      this.showDistance = false,
      this.showOpenStatus = false,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.onDelete});

  final Map<String, dynamic> data;
  final Function()? onTap;
  final bool showHeart;
  final EdgeInsets padding;
  final bool showCity;
  final bool showDistance;
  final bool showOpenStatus;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final Function(String)? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
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
                      crossAxisAlignment: crossAxisAlignment,
                      mainAxisAlignment: mainAxisAlignment,
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
                                data["hot_score"].toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        if (showCity) ...[
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
                          )
                        ],
                        if (showDistance) ...[
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
                                "Cách bạn ${((data["distance"] ?? 0.0) as double).toStringAsFixed(2)} km",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0f294d),
                                ),
                              ),
                            ],
                          )
                        ],
                        if (showOpenStatus) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                PhosphorIconsRegular.clock,
                                size: 14,
                                color: Color(0xFF0f294d),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                data["extra_info"]?["open_status"] ??
                                    "Mở cửa cả ngày",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0f294d),
                                ),
                              ),
                            ],
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showHeart)
              const Icon(
                PhosphorIconsRegular.heart,
                size: 20,
                color: ColorPalette.text1Color,
              ),
            if (onDelete != null)
              IconButton(
                  onPressed: () {
                    onDelete!(data["id"]);
                  },
                  icon: const Icon(
                    PhosphorIconsBold.trashSimple,
                    size: 20,
                    color: Colors.red,
                  )),
          ],
        ),
      ),
    );
  }
}
