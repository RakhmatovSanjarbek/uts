import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
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
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
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
  String get timerText {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
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
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grayColor200),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.mainColor, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.grayColor200,
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.back,
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ).paddingOnly(left: 8.0),
                  Text(
                    AppStrings.verificationCode,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(width: 48.0),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.smsSentInfo(widget.phoneNumber),
                style: TextStyle(
                  color: AppColors.blackColor50,
                  fontSize: 16,
                ),
              ).paddingSymmetric(horizontal: 16.0),
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
              ).paddingSymmetric(horizontal: 16.0),

              const SizedBox(height: 16.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.codeNotReceived,
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
                              AppStrings.resend,
                              style: TextStyle(
                                color: _canResend
                                    ? AppColors.mainColor
                                    : AppColors.grayColor,
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
                  title: AppStrings.confirm,
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
          );
        },
      ),
    );
  }
}
