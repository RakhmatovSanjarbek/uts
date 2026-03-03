import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../core/svg/app_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: Column(
        children: [
          SizedBox(height: 32.0),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  AppSvg.icBack,
                  width: 24.0,
                  height: 24.0,
                ),
              ),
              Text(
                "Biz haqimizda",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "UTS LOGISTIC",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            " — 2023 YILDA TASHKIL TOPGAN ZAMONAVIY VA ISHONCHLI LOGISTIKA KOMPANIYASI BO'LIB, ",
                      ),
                      TextSpan(
                        text: "MCHJ SADIKO EXPRESS",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            """ NOMI OSTIDA FAOLIYAT YURITADI. KOMPANIYA XITOY VA TOSHKENT O'RTASIDA XALQARO YUK TASHISH HAMDA POCHTA XIZMATLARINI AMALGA OSHIRADI. BIZNING ASOSIY MAQSADIMIZ — MIJOZLARGA TEZKOR, XAVFSIZ VA SAMARALI LOGISTIKA YECHIMLARINI TAQDIM ETISH. ZAMONAVIY TRANSPORT TIZIMI, ANIQ REJALASHTIRILGAN LOGISTIKA JARAYONLARI VA TAJRIBALI JAMOA ORQALI HAR BIR YUK O'Z VAQTIDA VA BUT SAQLANGAN HOLDA MANZILGA YETKAZILADI.""",
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 32.0),
                Text(
                  "NEGA AYNAN UTS LOGISTIC?",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  "• ✅ TEZKOR VA BARQAROR YETKAZIB BERISH",
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  "• ✅ YUK XAVFSIZLIGI VA DOIMIY MONITORING",
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  "• ✅ QULAY VA RAQOBATBARDOSH NARXLAR",
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  "• ✅ PROFESSIONAL XIZMAT KO'RSATISH",
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  "• ✅ MIJOZLARGA INDIVIDUAL YONDASHUV",
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 32.0),
                Text(
                  "BIZ HAR BIR MIJOZ BILAN UZOQ MUDDATLI HAMKORLIKNI YO'LGA QO'YISHNI MAQSAD QILGANMIZ. ISHONCH, ANIQLIK VA MAS'ULIYAT - KOMPANIYAMIZNING ASOSIY QADRIYATLARIDIR.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 32.0),
                Text(
                  "XALQARO SAVDO JARAYONLARINI SODDALASHTIRISH VA MIJOZLARGA SIFATLI LOGISTIKA XIZMATLARINI TAQDIM ETISH ORQALI BIZNES RIVOJIGA HISSA QO'SHISH.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MCHJ "SADIKO EXPRESS"',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 11.0,
                      ),
                    ),
                    Text(
                      'UTSCARGOLOGISTIC@GMAIL.COM',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 20.0,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
