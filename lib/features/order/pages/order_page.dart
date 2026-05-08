import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
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
  List<OrderModel> orders = [];
  List<OrderModel> filteredOrders = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
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
    _checkAndLoadOrders();
    _searchController.addListener(_onSearchChanged);
  }

  void _checkAndLoadOrders() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      _userModel = authState.user;
      context.read<OrderBloc>().add(GetOrderEvent());
    } else if (authState is RejectedState) {
      _userModel = authState.user;
    }
  }

  void _loadOrders() {
    context.read<OrderBloc>().add(GetOrderEvent());
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterOrders();
    });
  }

  void _filterOrders() {
    var statusFiltered = selectedStatus == "Barchasi"
        ? orders
        : orders.where((e) => e.status == selectedStatus).toList();

    if (_searchQuery.isNotEmpty) {
      filteredOrders = statusFiltered.where((order) {
        return order.trackCode
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    } else {
      filteredOrders = statusFiltered;
    }
  }

  void _updateSelectedStatus(String status) {
    setState(() {
      selectedStatus = status;
      _filterOrders();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshOrders() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      context.read<OrderBloc>().add(GetOrderEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final bool isAuthenticated = authState is AuthenticatedState;
        final bool isPending = authState is PendingState;
        final bool isRejected = authState is RejectedState;
        final bool isUnauthenticated = authState is UnauthenticatedState;

        if (isRejected && authState is RejectedState) {
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
      buttonText = "";
      onPressed = null;
    } else if (isRejected) {
      message = "Akkauntingiz rad etilgan. Buyurtmalaringizni ko'rish uchun qayta ro'yxatdan o'ting";
      buttonText = "Qayta ro'yxatdan o'tish";
      onPressed = () {
        if (_userModel != null && _userModel!.phone.isNotEmpty) {
          Navigator.pushNamed(
            context,
            "/register",
            arguments: _userModel!.phone,
          );
        }
      };
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppSvg.icBox,
              width: 80,
              height: 80,
              colorFilter: const ColorFilter.mode(
                AppColors.grayColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grayColor,
              ),
            ),
            if (buttonText.isNotEmpty && onPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
        if (state is OrderFailure) {
          context.showSnackBarMessage(state.error);
        }
      },
      builder: (context, state) {
        if (state is OrderLoading && orders.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
            ),
          );
        }

        if (state is OrderFailure && orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.error,
                  style: const TextStyle(color: AppColors.grayColor),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadOrders,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Qayta urinish'),
                ),
              ],
            ),
          );
        }

        if (state is OrderSuccess) {
          orders = state.model;
          _filterOrders();
        }

        return Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.only(
                top: 48,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.orders,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  IconButton(
                    onPressed: _refreshOrders,
                    icon: SvgPicture.asset(
                      AppSvg.icRefresh,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.mainColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WSearchBar(
                controller: _searchController,
                onSearch: (query) {},
                hintText: AppStrings.searchByTrack,
              ),
            ),

            const SizedBox(height: 12),

            // Category Bar
            WCategoryBar(
              categories: categories,
              selectedStatus: selectedStatus,
              onStatusSelected: _updateSelectedStatus,
            ),

            const SizedBox(height: 8),

            // Results info
            if (_searchQuery.isNotEmpty || selectedStatus != "Barchasi")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredOrders.length} ${AppStrings.orderCount}',
                      style: const TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 13,
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grayColor200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.grayColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppStrings.clear,
                                style: TextStyle(
                                  color: AppColors.grayColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // Orders List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshOrders,
                color: AppColors.mainColor,
                child: WOrderList(orders: filteredOrders),
              ),
            ),
          ],
        );
      },
    );
  }
}