import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/home/bloc/warehouse_bloc.dart';
import 'package:uts_cargo/features/home/widgets/w_warehouse.dart';

class AllWarehousePage extends StatefulWidget {
  final String fullName;
  final String userID;

  const AllWarehousePage({
    super.key,
    required this.fullName,
    required this.userID,
  });

  @override
  State<AllWarehousePage> createState() => _AllWarehousePageState();
}

class _AllWarehousePageState extends State<AllWarehousePage> {
  @override
  void initState() {
    super.initState();
    context.read<WarehouseBloc>().add(GetArrivedGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenColor,
        title: Text(
          AppStrings.orders,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              AppSvg.icRefresh,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<WarehouseBloc, WarehouseState>(
        listener: (BuildContext context, WarehouseState state) {
          if (state is WarehouseLoading) {
            Center(child: CircularProgressIndicator());
          } else if (state is WarehouseError) {
            context.showSnackBarMessage(state.message);
          }
        },
        builder: (BuildContext context, WarehouseState state) {
          if (state is WarehouseLoaded) {
            if (state.groups.isNotEmpty) {
              return ListView.builder(
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  return WWarehouse(
                    model: state.groups[index],
                    fullName: widget.fullName,
                    userID: widget.userID,
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  AppStrings.noOrdersYet,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
