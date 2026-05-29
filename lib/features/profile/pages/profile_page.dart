import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/models/user_model/user_model.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/pages/sign_in_page.dart';
import 'package:uts_cargo/features/profile/bloc/profile_bloc.dart';
import 'package:uts_cargo/features/profile/pages/relatives_page.dart';
import 'package:uts_cargo/features/profile/widgets/w_action_button.dart';
import 'package:uts_cargo/features/profile/widgets/w_edit_profile_bottom_sheet.dart';
import 'package:uts_cargo/features/profile/widgets/w_user_info.dart';

import '../../../core/utils/map_service.dart';
import '../../auth/pages/policy_web_view.dart';
import '../widgets/w_language_bottom_sheet.dart';
import '../widgets/w_notification_toggle_button.dart';
import '../widgets/w_qrcode_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _appVersion = '';
  @override
  void initState() {
    super.initState();
    _refreshProfile();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _appVersion = info.version);
    }
  }

  Future<void> _refreshProfile() async {
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  void _logout() async {
    context.read<AuthBloc>().add(LogoutEvent());
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
        (route) => false,
      );
    }
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
            context.read<AuthBloc>().add(LogoutEvent());
            _navigateToLogin(context);
          }
        },
        builder: (context, state) {
          final authState = context.watch<AuthBloc>().state;
          final bool isAuthenticated = authState is AuthenticatedState;
          final bool isPending = authState is PendingState;
          final bool isRejected = authState is RejectedState;
          final bool isUnauthenticated = authState is UnauthenticatedState;

          UserModel? userModel;
          if (state is ProfileSuccess) userModel = state.model;
          if (state is ProfileFailure) userModel = state.model;

          if (state is ProfileLoading && userModel == null) {
            return const Center(child: CircularProgressIndicator());
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
                          ClipboardData(text: userModel!.userId ?? ""),
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
                  const WNotificationToggleButton(),
                  const SizedBox(height: 16.0),

                  if (isAuthenticated ||
                      isPending ||
                      isRejected ||
                      isUnauthenticated)
                    WActionButton(
                      svgPath: AppSvg.icBadge,
                      buttonName: AppStrings.additionalPassport,
                      onPressed: () async {
                        if (isAuthenticated) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RelativesPage(),
                            ),
                          );
                          if (mounted) _refreshProfile();
                        } else {
                          context.showSnackBarMessage(AppStrings.accountMustBeVerified);
                        }
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

                  if (isRejected)
                    WActionButton(
                      svgPath: AppSvg.icLogout,
                      buttonName: AppStrings.reRegister,
                      iconColor: AppColors.redColor,
                      txtColor: AppColors.redColor,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/register",
                          arguments: userModel!.phone,
                        );
                      },
                    ),

                  if (isUnauthenticated)
                    WActionButton(
                      svgPath: AppSvg.icLogout,
                      buttonName: AppStrings.registration,
                      iconColor: AppColors.mainColor,
                      txtColor: AppColors.blackColor,
                      onPressed: () => Navigator.pushNamed(context, "/login"),
                    ),

                  if (isAuthenticated)
                    WActionButton(
                      svgPath: AppSvg.icLogout,
                      buttonName: AppStrings.deleteAccount,
                      iconColor: AppColors.redColor,
                      txtColor: AppColors.redColor,
                      onPressed: () => _showDeleteAccountDialog(context),
                    ),

                  const SizedBox(height: 16.0),

                  WActionButton(
                    svgPath: AppSvg.icLogout,
                    buttonName: AppStrings.logout,
                    iconColor: AppColors.mainColor,
                    txtColor: AppColors.blackColor,
                    onPressed: () => _showLogoutDialog(context),
                  ),

                  const SizedBox(height: 16.0),
                  Text(
                    "${AppStrings.appVersion} $_appVersion",
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
        if (userModel != null && userModel.userId != null && isAuthenticated)
          IconButton(
            onPressed: () {
              _showQRBottomSheet(context, userModel.userId ?? "");
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

  bool get isAuthenticated {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthenticatedState;
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
      builder: (context) =>
          WQRCodeBottomSheet(qrData: qrData, title: AppStrings.yourIdNumber),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
              AppStrings.logout,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.confirmLogout,
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _logout();
                  },
                  child: Text(
                    AppStrings.exit,
                    style: const TextStyle(
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
