import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WSerialNumber extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const WSerialNumber({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<WSerialNumber> createState() => _WSerialNumberState();
}

class _WSerialNumberState extends State<WSerialNumber> {
  final FocusNode _focusNode = FocusNode();
  final _maskFormatter = MaskTextInputFormatter(
    mask: 'AA #######',
    filter: {"A": RegExp(r'[A-Z]'), "#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );

  TextInputType _keyboardType = TextInputType.text;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final text = widget.controller.text;
    if (text != text.toUpperCase()) {
      final selection = widget.controller.selection;
      widget.controller.value = widget.controller.value.copyWith(
        text: text.toUpperCase(),
        selection: selection,
      );
      return;
    }
    int letterCount = text.replaceAll(RegExp(r'[^A-Z]'), '').length;

    TextInputType newType = (letterCount >= 2)
        ? TextInputType.number
        : TextInputType.text;
    if (_keyboardType != newType) {
      _updateKeyboard(newType);
    }
  }

  void _updateKeyboard(TextInputType type) {
    setState(() {
      _keyboardType = type;
    });

    if (_focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.unfocus();
        Future.delayed(const Duration(milliseconds: 80), () {
          if (mounted && !_focusNode.hasFocus) {
            _focusNode.requestFocus();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.screenColor,
        border: Border.all(
          color: _focusNode.hasFocus ? AppColors.mainColor : AppColors.grayColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        onChanged: widget.onChanged,
        keyboardType: _keyboardType,
        inputFormatters: [_maskFormatter],
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(
          hintText: 'AA 1234567',
          border: InputBorder.none,
          isCollapsed: true,
          counterText: "",
        ),
        style: const TextStyle(
          color: AppColors.blackColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}