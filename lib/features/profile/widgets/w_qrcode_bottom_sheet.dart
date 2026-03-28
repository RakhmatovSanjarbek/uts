import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WQRCodeBottomSheet extends StatelessWidget {
  final String qrData;
  const WQRCodeBottomSheet({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    final qrDecoration = const PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(
        color: AppColors.mainColor,
        roundFactor: 1.0,
      ),
      image: PrettyQrDecorationImage(
        image: AssetImage('assets/images/qr_logo.png'),
        scale: 0.3,
      ),
    );

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
        top: 12.0,
        left: 24.0,
        right: 24.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.screenColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.grayColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24.0),

          Text(
            AppStrings.yourIdNumber,
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32.0),

          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SizedBox(
              width: 200,
              height: 200,
              child: PrettyQrView(
                qrImage: QrImage(
                  QrCode.fromData(
                    data: qrData,
                    errorCorrectLevel: QrErrorCorrectLevel.H,
                  ),
                ),
                decoration: qrDecoration,
              ),
            ),
          ),

          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppStrings.close,
                style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}