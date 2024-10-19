import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType textInputType;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      magnifierConfiguration: TextMagnifierConfiguration(
        magnifierBuilder: (_, __, ValueNotifier<MagnifierInfo> magnifierInfo) =>
            CustomMagnifier(
          magnifierInfo: magnifierInfo,
        ),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: Theme.of(context).colorScheme.primary,
        ),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,

        //* Border when unselected
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        //* Border when selected
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class CustomMagnifier extends StatelessWidget {
  const CustomMagnifier({super.key, required this.magnifierInfo});

  static const Size magnifierSize = Size(100, 100);

  final ValueNotifier<MagnifierInfo> magnifierInfo;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MagnifierInfo>(
      valueListenable: magnifierInfo,
      builder: (BuildContext context, MagnifierInfo currentMagnifierInfo, _) {
        Offset magnifierPosition = currentMagnifierInfo.globalGesturePosition;

        magnifierPosition = Offset(
          clampDouble(
            magnifierPosition.dx,
            currentMagnifierInfo.currentLineBoundaries.left,
            currentMagnifierInfo.currentLineBoundaries.right,
          ),
          clampDouble(
            magnifierPosition.dy,
            currentMagnifierInfo.currentLineBoundaries.top,
            currentMagnifierInfo.currentLineBoundaries.bottom,
          ),
        );

        magnifierPosition -= Alignment.bottomCenter.alongSize(magnifierSize);

        return Positioned(
          left: magnifierPosition.dx,
          top: magnifierPosition.dy,
          child: RawMagnifier(
            magnificationScale: 2,
            focalPointOffset: Offset(0, magnifierSize.height / 2),
            decoration: MagnifierDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            size: magnifierSize,
          ),
        );
      },
    );
  }
}
