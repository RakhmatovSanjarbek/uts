import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/prohibited/data/mock/prohibited_list.dart';

class ProhibitedPage extends StatelessWidget {
  const ProhibitedPage({super.key});

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
                "Taqiqlangan tovarlar",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: mockProhibited.length,
              itemBuilder: (context, index) {
                final item = mockProhibited[index];
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: item.color != null
                        ? AppColors.redColor.withOpacity(0.1)
                        : AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(16.0),
                    border: item.color != null
                        ? Border.all(color: item.color!, width: 1.5)
                        : null,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        item.icon,
                        width: 24.0,
                        height: 24.0,
                        colorFilter: ColorFilter.mode(
                          AppColors.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
