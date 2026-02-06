import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../core/theme/app_colors.dart';

class WPhoneNumber extends StatefulWidget {
  final TextEditingController phoneNumber;
  final ValueChanged<String>? onChanged;

  const WPhoneNumber({super.key, required this.phoneNumber, this.onChanged});

  @override
  State<WPhoneNumber> createState() => _WPhoneNumberState();
}

class _WPhoneNumberState extends State<WPhoneNumber> {
  final FocusNode _focusNode = FocusNode();

  final maskFormatter = MaskTextInputFormatter(
    mask: '## ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? AppColors.mainColor : AppColors.grayColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Text(
            "+998 | ",
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: widget.phoneNumber,
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.phone,
              onChanged: widget.onChanged,
              decoration: const InputDecoration(
                hintText: "90 123-45-67",
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: TextStyle(color: AppColors.blackColor, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
