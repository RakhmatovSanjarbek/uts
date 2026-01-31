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
          SizedBox(height: 24.0),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  padding: EdgeInsets.all(6.0),
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ]
                  ),
                  child: SvgPicture.asset(
                    AppSvg.icBack,
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
              ),
              Text(
                "Taqiqlangan tovarlar",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16.0,
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
