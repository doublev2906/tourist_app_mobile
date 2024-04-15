import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseCategoryView extends StatefulWidget {
  const BaseCategoryView({super.key, this.onScroll});
  final void Function(ScrollController scrollController)? onScroll;

  @override
  State<BaseCategoryView> createState() => _BaseCategoryViewState();
}

class _BaseCategoryViewState extends State<BaseCategoryView> {
  final scrollController = ScrollController();
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 150,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leadingWidth: 40,
              elevation: 0,
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
                      child: Image.asset(
                        "assets/images/destination.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(),
            ),
          ],
        ));
  }
}
