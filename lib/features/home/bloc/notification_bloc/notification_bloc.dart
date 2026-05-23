import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/domain/repositories/notification_repository.dart';

import '../../../../data/models/notification_model /notification_model.dart';

// ===== EVENTS =====
abstract class NotificationEvent {}

class LoadNotificationsEvent extends NotificationEvent {}

class LoadMoreNotificationsEvent extends NotificationEvent {}

class MarkAsReadEvent extends NotificationEvent {
  final int notificationId;
  MarkAsReadEvent(this.notificationId);
}

class MarkAllAsReadEvent extends NotificationEvent {}

class GetUnreadCountEvent extends NotificationEvent {}

// ===== STATES =====
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoadingMore extends NotificationState {
  final List<NotificationModel> currentItems;
  final int unreadCount;
  NotificationLoadingMore({required this.currentItems, required this.unreadCount});
}

class NotificationSuccess extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool hasMore;
  final int currentPage;

  NotificationSuccess({
    required this.notifications,
    required this.unreadCount,
    required this.hasMore,
    required this.currentPage,
  });

  NotificationSuccess copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? hasMore,
    int? currentPage,
  }) {
    return NotificationSuccess(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class NotificationFailure extends NotificationState {
  final String error;
  NotificationFailure(this.error);
}

class UnreadCountState extends NotificationState {
  final int count;
  UnreadCountState(this.count);
}

// ===== BLOC =====
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoad);
    on<LoadMoreNotificationsEvent>(_onLoadMore);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<GetUnreadCountEvent>(_onGetUnreadCount);
  }

  Future<void> _onLoad(LoadNotificationsEvent event, Emitter emit) async {
    emit(NotificationLoading());
    try {
      final result = await repository.getNotifications(page: 1);
      emit(NotificationSuccess(
        notifications: result.notifications,
        unreadCount: result.unreadCount,
        hasMore: result.nextPage != null,
        currentPage: 1,
      ));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreNotificationsEvent event, Emitter emit) async {
    final current = state;
    if (current is! NotificationSuccess || !current.hasMore) return;

    emit(NotificationLoadingMore(
      currentItems: current.notifications,
      unreadCount: current.unreadCount,
    ));

    try {
      final nextPage = current.currentPage + 1;
      final result = await repository.getNotifications(page: nextPage);
      emit(NotificationSuccess(
        notifications: [...current.notifications, ...result.notifications],
        unreadCount: result.unreadCount,
        hasMore: result.nextPage != null,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(MarkAsReadEvent event, Emitter emit) async {
    final current = state;
    if (current is! NotificationSuccess) return;

    try {
      await repository.markAsRead(event.notificationId);
      final updated = current.notifications.map((n) {
        return n.id == event.notificationId ? n.copyWith(isRead: true) : n;
      }).toList();
      final newUnread = updated.where((n) => !n.isRead).length;
      emit(current.copyWith(notifications: updated, unreadCount: newUnread));
    } catch (e) {
      // Silent fail — UI da ko'rinadi lekin error page chiqarmaydi
    }
  }

  Future<void> _onMarkAllAsRead(MarkAllAsReadEvent event, Emitter emit) async {
    final current = state;
    if (current is! NotificationSuccess) return;

    try {
      await repository.markAllAsRead();
      final updated = current.notifications.map((n) => n.copyWith(isRead: true)).toList();
      emit(current.copyWith(notifications: updated, unreadCount: 0));
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _onGetUnreadCount(GetUnreadCountEvent event, Emitter emit) async {
    try {
      final count = await repository.getUnreadCount();
      emit(UnreadCountState(count));
    } catch (e) {
      // Silent fail
    }
  }
}