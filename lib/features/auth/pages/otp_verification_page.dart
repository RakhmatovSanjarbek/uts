import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/widgets/w_loading_button.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../core/svg/app_svg.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool isFull = false;

  // Taymer uchun o'zgaruvchilar
  Timer? _timer;
  int _start = 60; // 1 minut (60 soniya)
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer(); // Sahifa ochilishi bilan taymerni boshlash
  }

  void startTimer() {
    _canResend = false;
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Soniya formatini 01:00 ko'rinishiga keltirish
  String get timerText {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel(); // Xotirani bo'shatish
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: AppColors.blackColor,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.mainColor, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.grey.shade50,
        border: Border.all(color: AppColors.mainColor),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (state.response.token != null) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/dashboard",
                (route) => false,
              );
            } else if (state.response.token == null) {
              context.showSnackBarMessage("Xatolik yuz berdi Qayta urining");
            }
          } else if (state is AuthFailure) {
            context.showSnackBarMessage(state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          AppSvg.icBack,
                          width: 24.0,
                          height: 24.0,
                        ),
                      ),
                    ),
                    const Text(
                      "Tasdiqlash kodi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: 40.0),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Sizning ${widget.phoneNumber} raqamingizga 6 xonali kod sms qilib yuborildi",
                  style: TextStyle(color: AppColors.blackColor50, fontSize: 16),
                ),
                const SizedBox(height: 24.0),

                Pinput(
                  length: 6,
                  controller: pinController,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  onCompleted: (pin) => setState(() => isFull = true),
                  onChanged: (value) {
                    if (value.length < 6) setState(() => isFull = false);
                  },
                ),

                const SizedBox(height: 16.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Kod kelmadimi? ",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16.0,
                        ),
                      ),
                      _canResend
                          ? TextButton(
                              onPressed: _canResend
                                  ? () {
                                      startTimer();
                                    }
                                  : null,
                              child: Text(
                                "Qayta yuborish",
                                style: TextStyle(
                                  color: _canResend
                                      ? AppColors.mainColor
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            )
                          : Text(
                              timerText,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                    ],
                  ),
                ),

                const Spacer(),
                SafeArea(
                  child: WLoadingButton(
                    marginLeft: 0.0,
                    marginRight: 0.0,
                    title: "Tasdiqlash",
                    isOnPressed: isFull,
                    isLoading: isLoading,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        OtpEvent(widget.phoneNumber, pinController.text),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
