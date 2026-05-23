import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/order/bloc/order_bloc.dart';

import '../../../../data/models/order_model/order_model.dart';
import '../../../core/svg/app_svg.dart';
import '../../../data/models/user_model/user_model.dart';
import '../widget/w_category_bar.dart';
import '../widget/w_order_list.dart';
import '../widget/w_search_bar.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String selectedStatus = "Barchasi";
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  UserModel? _userModel;

  final List<String> categories = [
    "Barchasi",
    "Omborda",
    "Yo'lda",
    "Punktda",
    "Topshirildi",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrderBloc>().add(LoadMoreOrdersEvent());
    }
  }
  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<OrderBloc>().add(SearchOrderEvent(query));
    });
  }

  void _updateSelectedStatus(String status) {
    setState(() => selectedStatus = status);
    context.read<OrderBloc>().add(FilterOrderByStatusEvent(status));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshOrders() async {
    _searchController.clear();
    setState(() => selectedStatus = 'Barchasi');
    context.read<OrderBloc>().add(GetOrderEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final bool isAuthenticated = authState is AuthenticatedState;
        final bool isPending = authState is PendingState;
        final bool isRejected = authState is RejectedState;
        final bool isUnauthenticated = authState is UnauthenticatedState;

        if (isRejected) {
          _userModel = authState.user;
        }

        return Scaffold(
          backgroundColor: AppColors.screenColor,
          body: isAuthenticated
              ? _buildAuthenticatedContent()
              : _buildUnavailableContent(isPending, isRejected, isUnauthenticated),
        );
      },
    );
  }

  Widget _buildUnavailableContent(bool isPending, bool isRejected, bool isUnauthenticated) {
    String message = "";
    String buttonText = "";
    VoidCallback? onPressed;

    if (isUnauthenticated) {
      message = "Buyurtmalaringizni ko'rish uchun iltimos, tizimga kiring";
      buttonText = "Ro'yxatdan o'tish";
      onPressed = () => Navigator.pushNamed(context, "/login");
    } else if (isPending) {
      message = "Akkauntingiz tekshirilmoqda. Tasdiqlangandan keyin buyurtmalaringizni ko'rishingiz mumkin";
    } else if (isRejected) {
      message = "Akkauntingiz rad etilgan. Buyurtmalaringizni ko'rish uchun qayta ro'yxatdan o'ting";
      buttonText = "Qayta ro'yxatdan o'tish";
      onPressed = () {
        if (_userModel != null && _userModel!.phone.isNotEmpty) {
          Navigator.pushNamed(context, "/register", arguments: _userModel!.phone);
        }
      };
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppSvg.icBox, width: 80, height: 80,
                colorFilter: const ColorFilter.mode(AppColors.grayColor, BlendMode.srcIn)),
            const SizedBox(height: 24),
            Text(message, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: AppColors.grayColor)),
            if (buttonText.isNotEmpty && onPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedContent() {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderFailure) context.showSnackBarMessage(state.error);
      },
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
          );
        }
        if (state is OrderFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error, style: const TextStyle(color: AppColors.grayColor)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshOrders,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Qayta urinish', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
        List<OrderModel> orders = [];
        bool isLoadingMore = false;
        int totalCount = 0;
        bool hasMore = false;

        if (state is OrderSuccess) {
          orders = state.orders;
          totalCount = state.totalCount;
          hasMore = state.hasMore;
        } else if (state is OrderLoadingMore) {
          orders = state.current.orders;
          totalCount = state.current.totalCount;
          hasMore = state.current.hasMore;
          isLoadingMore = true;
        }

        return Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.orders,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.blackColor)),
                  IconButton(
                    onPressed: _refreshOrders,
                    icon: SvgPicture.asset(AppSvg.icRefresh, width: 24, height: 24,
                        colorFilter: const ColorFilter.mode(AppColors.mainColor, BlendMode.srcIn)),
                  ),
                ],
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Focus(
                canRequestFocus: false,
                child: WSearchBar(
                  controller: _searchController,
                  onSearch: _onSearchChanged,
                  hintText: AppStrings.searchByTrack,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Category filter
            WCategoryBar(
              categories: categories,
              selectedStatus: selectedStatus,
              onStatusSelected: _updateSelectedStatus,
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Jami: $totalCount ta yuk',
                      style: const TextStyle(color: AppColors.grayColor, fontSize: 13)),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.grayColor200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.close, size: 16, color: AppColors.grayColor),
                            const SizedBox(width: 4),
                            Text(AppStrings.clear,
                                style: const TextStyle(color: AppColors.grayColor, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshOrders,
                color: AppColors.mainColor,
                child: WOrderList(
                  orders: orders,
                  scrollController: _scrollController,
                  isLoadingMore: isLoadingMore,
                  hasMore: hasMore,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}