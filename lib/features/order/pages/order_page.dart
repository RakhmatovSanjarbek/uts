import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/order/bloc/order_bloc.dart';
import '../../../../data/models/order_model/order_model.dart';
import '../../../core/svg/app_svg.dart';
import '../widget/w_category_bar.dart';
import '../widget/w_order_list.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String selectedStatus = "Barchasi";
  List<OrderModel> orders = [];

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
    context.read<OrderBloc>().add(GetOrderEvent());
  }

  List<OrderModel> get _filteredOrders {
    if (selectedStatus == "Barchasi") return orders;
    return orders.where((e) => e.status == selectedStatus).toList();
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
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderFailure) {
            return Center(child: Text(state.error));
          }

          if (state is OrderSuccess) {
            orders = state.model.toList();
          }

          return RefreshIndicator(
            onRefresh: _refreshOrders,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Buyurtmalar",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _refreshOrders,
                      icon: SvgPicture.asset(
                        AppSvg.icRefresh,
                        width: 24.0,
                        height: 24.0,
                        colorFilter: ColorFilter.mode(
                          AppColors.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ).paddingOnly(left: 16.0, right: 10.0),
                const SizedBox(height: 16.0),

                WCategoryBar(
                  categories: categories,
                  selectedStatus: selectedStatus,
                  onStatusSelected: (status) {
                    setState(() {
                      selectedStatus = status;
                    });
                  },
                ),

                const SizedBox(height: 16),

                WOrderList(orders: _filteredOrders),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshOrders() async {
    context.read<OrderBloc>().add(GetOrderEvent());
    await Future.delayed(const Duration(seconds: 1));
  }
}
