import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app_mobille/core/helpers/asset_helper.dart';
import 'package:tourist_app_mobille/core/helpers/image_helper.dart';

class DefaultNoneBgItem extends StatelessWidget {
  const DefaultNoneBgItem({super.key, this.borderRadius = BorderRadius.zero});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff8F67E8), Color(0xff6357CC)],
            ),
            borderRadius: borderRadius,
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
}
