import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/features/calculator/widgets/w_bottom_sheet.dart';

import '../../../core/theme/app_colors.dart';
import '../bloc/calculator_bloc.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  void initState() {
    super.initState();
    context.read<CalculatorBloc>().add(GetCalculationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        title: Text(AppStrings.calculator),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _showBottomSheet(context),
            icon: SvgPicture.asset(
              AppSvg.icAdd,
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
      body: BlocBuilder<CalculatorBloc, CalculatorState>(
        builder: (context, state) {
          if (state is CalculatorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CalculatorLoaded) {
            // Bo'sh listni tekshirish
            if (state.calculations.isEmpty) {
              return const Center(
                child: Text(
                  "Hozircha ma'lumot yo'q",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.calculations.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = state.calculations[index];
                return Container(
                  width: double.infinity,
                  height: 120.0,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0),
                        ),
                        child: Image.network(
                          item.image,
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${AppStrings.weight} ${item.weight} ${AppStrings.kg} ",
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              item.isResponded
                                  ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.green,
                                ),
                                child: const Text(
                                  "Javob berildi",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 10.0,
                                  ),
                                ),
                              )
                                  : Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.orange,
                                ),
                                child: const Text(
                                  "Kutilmoqda",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${AppStrings.length} ${item.length} \n${AppStrings.height} ${item.height} \n${AppStrings.width} ${item.width}",
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${AppStrings.dateLabel} ${item.createdAt.toString().substring(0, 10)}",
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${item.price ?? '-'} \$",
                          style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ).paddingOnly(right: 16.0),
                    ],
                  ),
                );
              },
            );
          } else if (state is CalculatorError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Hozircha ma'lumot yo'q"));
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const WBottomSheet();
      },
    );
  }
}