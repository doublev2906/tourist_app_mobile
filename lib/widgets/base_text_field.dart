import 'package:flutter/material.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';

class BaseTextField extends StatefulWidget {
  const BaseTextField(
      {super.key,
      required this.hintText,
      required this.labelText,
      this.isPassword = false,
      this.controller,
      this.onChanged,
      this.textError = ""});
  final String hintText;

  final String labelText;

  final bool isPassword;

  final TextEditingController? controller;

  final Function(String)? onChanged;

  final String textError;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  bool isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: widget.textError.isEmpty
                ? null
                : Border.all(
                    color: Colors.redAccent,
                    width: 1,
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 12),
                child: Text(
                  widget.labelText,
                  style: const TextStyle(
                      fontSize: 12, color: ColorPalette.textColorBlack),
                ),
              ),
              TextFormField(
                onChanged: widget.onChanged,
                controller: widget.controller,
                obscureText: widget.isPassword ? !isShowPassword : false,
                style: const TextStyle(
                    fontSize: 14,
                    color: ColorPalette.textColorBlack,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              isShowPassword = !isShowPassword;
                            });
                          },
                          icon: Icon(
                            isShowPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: ColorPalette.textColorBlack,
                          ),
                        )
                      : null,
                  hintText: widget.hintText,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 6, bottom: 12),
                  isDense: true,
                  filled: true,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(133, 146, 166, 1),
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.textError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.textError,
              style: const TextStyle(
                  fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          )
      ],
    );
  }
}
