import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/features/profile/widgets/w_retavive_passport_info.dart';

import '../../../core/svg/app_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/w_add_relative_bottom_sheet.dart';

class RelativesPage extends StatefulWidget {
  const RelativesPage({super.key});

  @override
  State<RelativesPage> createState() => _RelativesPageState();
}

class _RelativesPageState extends State<RelativesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetPassportsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        title: Text(AppStrings.additionalPassports),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _showAddRelativeSheet(context),
            icon: SvgPicture.asset(
              AppSvg.icAdd,
              colorFilter: const ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context,state) {
          if(state is PassportActionSuccess){
            context.showSnackBarMessage(state.message);
          }
          if(state is ProfileFailure){
            context.showSnackBarMessage(state.error);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PassportsSuccess) {
            if (state.passports.isEmpty) {
              return Center(child: Text(AppStrings.noPassportsYet));
            }
            return ListView.builder(
              itemCount: state.passports.length,
              itemBuilder: (context, index) {
                final item = state.passports[index];
                return WRelativePassportInfo(
                  onPressedDeleted: () => _showDeleteConfirm(item.id!),
                  fullName: item.fullName!,
                  passport: item.passportSeries!,
                  personalNumber: item.jshshir!,
                  brithDay: item.birthDate!,
                  phone: item.phone!,
                ).paddingOnly(bottom: 16.0);
              },
            );
          }
          return Center(child: Text(AppStrings.errorOccurred));
        },
      ),
    );
  }

  void _showAddRelativeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WAddRelativeBottomSheet(),
    );
  }

  void _showDeleteConfirm(int passportId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.deletePassport,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.deletePassportConfirm,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: AppColors.grayColor),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.grayColor200),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppStrings.cancel,
                    style: TextStyle(
                      color: AppColors.grayColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.read<ProfileBloc>().add(
                      DeletePassportEvent(passportId),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppStrings.delete,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
