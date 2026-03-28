import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/order/bloc/order_bloc.dart';

import '../../../../data/models/order_model/order_model.dart';
import '../../../core/svg/app_svg.dart';
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
    _loadOrders();
    _searchController.addListener(_onSearchChanged);
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
    context.read<OrderBloc>().add(GetOrderEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: BlocConsumer<OrderBloc, OrderState>(
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
                                SizedBox(width: 4),
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
      ),
    );
  }
}