import 'package:flutter/material.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WInputText extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const WInputText({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  State<WInputText> createState() => _WInputTextState();
}

class _WInputTextState extends State<WInputText> {
  final FocusNode _focusNode = FocusNode();

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
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          isCollapsed: true,
        ),
        style: TextStyle(color: AppColors.blackColor, fontSize: 16.0),
      ),
    );
  }
}
