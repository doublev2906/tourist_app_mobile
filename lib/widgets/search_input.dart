import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String searchValue;
  final VoidCallback onClearSearch;
  final String? placeHolder;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final EdgeInsets? margin;

  const SearchInput(
      {super.key,
      required this.controller,
      required this.searchValue,
      required this.onClearSearch,
      this.placeHolder,
      this.keyboardType,
      this.onChanged,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: const Color(0xffD9D9D9).withOpacity(0.6)),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 12,
              color: Color(0xff8C8C8C),
            ),
          ),
          Flexible(
              child: TextField(
            textCapitalization: TextCapitalization.sentences,
            maxLines: 1,
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 12,
            ),
            decoration: InputDecoration(
                hintText: placeHolder ?? "Tìm kiếm",
                contentPadding: EdgeInsets.zero,
                hintStyle: const TextStyle(fontSize: 13),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
          )),
          searchValue.isNotEmpty
              ? GestureDetector(
                  onTap: onClearSearch,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.cancel,
                      size: 18,
                      color: Color(0xff8C8C8C),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
