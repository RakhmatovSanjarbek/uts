import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uts_cargo/core/theme/app_colors.dart'; // O'zingizning papkangizga moslang

class WDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const WDatePickerField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'KK/OO/YYYY',
  });

  @override
  State<WDatePickerField> createState() => _WDatePickerFieldState();
}

class _WDatePickerFieldState extends State<WDatePickerField> {
  final FocusNode _focusNode = FocusNode();

  // Sana uchun maska: 00/00/0000
  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
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

  // Kalendarni ochish funksiyasi
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.mainColor, // Kalendar asosiy rangi
              onPrimary: Colors.white,
              onSurface: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Tanlangan sanani KK/OO/YYYY formatiga o'tkazish
      String day = picked.day.toString().padLeft(2, '0');
      String month = picked.month.toString().padLeft(2, '0');
      String year = picked.year.toString();

      String formattedDate = "$day/$month/$year";

      setState(() {
        widget.controller.text = formattedDate;
        // Mask formatter ichki holatini yangilash uchun
        maskFormatter.updateMask(mask: '##/##/####', newValue: TextEditingValue(text: formattedDate));
      });

      if (widget.onChanged != null) {
        widget.onChanged!(formattedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return Container(
      width: double.infinity,
      height: 56.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(left: 16.0, right: 8.0), // O'ng tomonda icon uchun joy
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.screenColor,
        border: Border.all(
          color: isFocused ? AppColors.mainColor : AppColors.grayColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              onChanged: widget.onChanged,
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(color: AppColors.blackColor, fontSize: 16.0),
            ),
          ),
          IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.mainColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}