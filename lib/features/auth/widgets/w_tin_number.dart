import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WTinNumber extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const WTinNumber({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<WTinNumber> createState() => _WTinNumberState();
}

class _WTinNumberState extends State<WTinNumber> {
  final FocusNode _focusNode = FocusNode();

  final maskFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ##',
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
      height: 56.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.screenColor,
        border: Border.all(
          color: isFocused ? AppColors.mainColor : AppColors.grayColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        onChanged: widget.onChanged,
        inputFormatters: [maskFormatter],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'JSHSHIR',
          border: InputBorder.none,
          isCollapsed: true,
        ),
        style: TextStyle(color: AppColors.blackColor, fontSize: 16.0),
      ),
    );
  }
}
