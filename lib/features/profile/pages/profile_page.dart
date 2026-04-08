import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/models/user_model/user_model.dart';
import 'package:uts_cargo/features/auth/pages/sign_in_page.dart';
import 'package:uts_cargo/features/profile/bloc/profile_bloc.dart';
import 'package:uts_cargo/features/profile/pages/relatives_page.dart';
import 'package:uts_cargo/features/profile/widgets/w_action_button.dart';
import 'package:uts_cargo/features/profile/widgets/w_edit_profile_bottom_sheet.dart';
import 'package:uts_cargo/features/profile/widgets/w_user_info.dart';

import '../../../core/utils/map_service.dart';
import '../../auth/pages/policy_web_view.dart';
import '../widgets/w_language_bottom_sheet.dart';
import '../widgets/w_qrcode_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            context.showSnackBarMessage(state.error);
          }
          if (state is ProfileDeleted) {
            _navigateToLogin(context);
          }
        },
        builder: (context, state) {
          UserModel? userModel;
          if (state is ProfileSuccess) userModel = state.model;
          if (state is ProfileFailure) userModel = state.model;

          if (state is ProfileLoading && userModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileFailure && userModel == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshProfile,
                    child: Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 56.0),
                  _buildHeader(context, userModel),
                  const SizedBox(height: 16.0),
                  if (userModel != null)
                    WUserInfo(
                      isLoading: state is ProfileLoading,
                      model: userModel,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: userModel!.userId),
                        );
                        context.showSnackBarMessage(AppStrings.idCopied);
                      },
                      onPressedEditButton: () =>
                          _showEditBottomSheet(context, userModel!),
                    )
                  else
                    SizedBox(
                      height: 120,
                      child: Center(child: Text(AppStrings.profileNotFound)),
                    ),
                  const SizedBox(height: 16.0),
                  WActionButton(
                    svgPath: AppSvg.icBadge,
                    buttonName: AppStrings.additionalPassport,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RelativesPage(),
                        ),
                      );
                      if (mounted) _refreshProfile();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  WActionButton(
                    svgPath: AppSvg.icLocation,
                    buttonName: AppStrings.deliveryPoint,
                    onPressed: () {
                      MapService.openSystemMap(lat: 41.334485, lng: 69.214603);
                    },
                  ),
                  const SizedBox(height: 16.0),
                  WActionButton(
                    svgPath: AppSvg.icLanguage,
                    buttonName:
                        "${AppStrings.appLanguage} (${AppStrings.language})",
                    onPressed: () => _showLanguageBottomSheet(context),
                  ),
                  const SizedBox(height: 16.0),
                  WActionButton(
                    svgPath: AppSvg.icInfo,
                    buttonName: AppStrings.aboutApp,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16.0),
                  WActionButton(
                    svgPath: AppSvg.icWarning,
                    buttonName: AppStrings.privacyPolicy,
                    onPressed: () => openPolicy(
                      context,
                      AppStrings.privacyPolicy,
                      "https://utsgroup.uz/privacy",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  WActionButton(
                    svgPath: AppSvg.icLogout,
                    buttonName: AppStrings.deleteAccount,
                    iconColor: AppColors.redColor,
                    txtColor: AppColors.redColor,
                    onPressed: () => _showDeleteAccountDialog(context),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "${AppStrings.appVersion} 1.0.0+1",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel? userModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.profile,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            if (userModel != null) {
              _showQRBottomSheet(context, userModel.userId);
            }
          },
          icon: SvgPicture.asset(
            AppSvg.icQrCod,
            colorFilter: const ColorFilter.mode(
              AppColors.mainColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    ).paddingOnly(left: 16.0);
  }

  void openPolicy(BuildContext context, String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => PolicyWebView(title: title, url: url),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
      (route) => false,
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const WLanguageBottomSheet(),
    );
  }

  void _showEditBottomSheet(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          WEditProfileBottomSheet(user: user, onUpdated: _refreshProfile),
    );
  }

  void _showQRBottomSheet(BuildContext context, String qrData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => WQRCodeBottomSheet(qrData: qrData),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.screenColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.deleteAccountConfirmTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.deleteAccountConfirmMessage,
              textAlign: TextAlign.start,
              style: const TextStyle(color: AppColors.grayColor),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.grayColor200),
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    AppStrings.cancel,
                    style: const TextStyle(
                      color: AppColors.grayColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state is ProfileLoading;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<ProfileBloc>().add(
                                DeleteAccountEvent(),
                              );
                              Navigator.pop(dialogContext);
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              AppStrings.delete,
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
