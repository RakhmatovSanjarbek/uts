import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import '../../../../core/svg/app_svg.dart';
import '../bloc/notification_bloc/notification_bloc.dart';
import '../pages/notifications_page.dart';

class WHomeToolbar extends StatelessWidget {
  final VoidCallback onLocationPressed;

  const WHomeToolbar({super.key, required this.onLocationPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        IconData statusIcon = Icons.check_circle;
        Color statusColor = Colors.green;
        String statusDisplay = "";

        if (authState is AuthenticatedState) {
          statusIcon = Icons.check_circle;
          statusColor = Colors.green;
          statusDisplay = authState.user.statusDisplay;
        } else if (authState is PendingState) {
          statusIcon = Icons.hourglass_empty;
          statusColor = Colors.orange;
          statusDisplay = authState.user.statusDisplay;
        } else if (authState is RejectedState) {
          statusIcon = Icons.error_outline;
          statusColor = Colors.red;
          statusDisplay = authState.user.statusDisplay;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 48.0),
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24.0),
              bottomRight: Radius.circular(24.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: onLocationPressed,
                            child: Container(
                              width: 48.0, height: 48.0,
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(24.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8, offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                AppSvg.icLocation,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.mainColor, BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.pickupAddress,
                                style: const TextStyle(color: AppColors.grayColor, fontSize: 12.0),
                              ),
                              Text(
                                AppStrings.beruniyStreet,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 16.0, fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (authState is AuthenticatedState ||
                                  authState is PendingState ||
                                  authState is RejectedState)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(statusIcon, color: Colors.white, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        statusDisplay,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500, fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<NotificationBloc>(),
                              child: const NotificationsPage(),
                            ),
                          ),
                        ).then((_) {
                          context.read<NotificationBloc>().add(GetUnreadCountEvent());
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 48.0, height: 48.0,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(24.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8, offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              AppSvg.icNotifications,
                              colorFilter: const ColorFilter.mode(
                                AppColors.mainColor, BlendMode.srcIn,
                              ),
                            ),
                          ),
                          BlocBuilder<NotificationBloc, NotificationState>(
                            builder: (context, state) {
                              int unreadCount = 0;
                              if (state is NotificationSuccess) unreadCount = state.unreadCount;
                              if (state is NotificationLoadingMore) unreadCount = state.unreadCount;
                              if (state is UnreadCountState) unreadCount = state.count;

                              if (unreadCount == 0) return const SizedBox.shrink();

                              return Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18, minHeight: 18,
                                  ),
                                  child: Text(
                                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}