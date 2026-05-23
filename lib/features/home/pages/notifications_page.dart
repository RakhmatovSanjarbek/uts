import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../data/models/notification_model /notification_model.dart';
import '../bloc/notification_bloc/notification_bloc.dart';
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotificationsEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationBloc>().add(LoadMoreNotificationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        title: Text(
          AppStrings.notifications,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationSuccess && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    context.read<NotificationBloc>().add(MarkAllAsReadEvent());
                  },
                  child: Text(
                    AppStrings.readAll,
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 13),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.mainColor),
            );
          }

          if (state is NotificationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.grayColor),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.errorOccurred,
                    style: TextStyle(color: AppColors.grayColor, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainColor),
                    onPressed: () {
                      context.read<NotificationBloc>().add(LoadNotificationsEvent());
                    },
                    child: Text(AppStrings.retry, style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          List<NotificationModel> notifications = [];
          bool isLoadingMore = false;

          if (state is NotificationSuccess) {
            notifications = state.notifications;
          } else if (state is NotificationLoadingMore) {
            notifications = state.currentItems;
            isLoadingMore = true;
          }

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    size: 80,
                    color: AppColors.grayColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noNotifications,
                    style: TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
              Text(
                    AppStrings.statusChangeNotification,
                    style: TextStyle(color: AppColors.grayColor, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.mainColor,
            onRefresh: () async {
              context.read<NotificationBloc>().add(LoadNotificationsEvent());
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.mainColor),
                    ),
                  );
                }
                return _NotificationItem(
                  notification: notifications[index],
                  onTap: () {
                    if (!notifications[index].isRead) {
                      context.read<NotificationBloc>().add(
                        MarkAsReadEvent(notifications[index].id),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationItem({required this.notification, required this.onTap});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return AppStrings.justNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${AppStrings.minutesAgo}';
    if (diff.inHours < 24) return '${diff.inHours} ${AppStrings.hoursAgo}';
    if (diff.inDays == 1) return AppStrings.yesterday;
    if (diff.inDays < 7) return '${diff.inDays} ${AppStrings.daysAgo}';
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  IconData _getIcon() {
    switch (notification.notificationType) {
      case 'Omborda': return Icons.warehouse_outlined;
      case "Yo'lda": return Icons.local_shipping_outlined;
      case 'Punktda': return Icons.location_on_outlined;
      case 'Topshirildi': return Icons.check_circle_outline;
      case 'Kutilmoqda': return Icons.hourglass_empty;
      default: return Icons.notifications_outlined;
    }
  }

  Color _getColor() {
    switch (notification.notificationType) {
      case 'Omborda': return Colors.orange;
      case "Yo'lda": return Colors.blue;
      case 'Punktda': return Colors.purple;
      case 'Topshirildi': return Colors.green;
      case 'Kutilmoqda': return Colors.red;
      default: return AppColors.mainColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.mainColor.withOpacity(0.05)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread
                ? AppColors.mainColor.withOpacity(0.2)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getIcon(), color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: isUnread
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 15,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: const TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(notification.createdAt),
                      style: TextStyle(
                        color: AppColors.grayColor.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}