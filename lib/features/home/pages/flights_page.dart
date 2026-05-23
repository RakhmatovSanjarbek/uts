import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/datasource/flight_remote_data_source.dart';
import 'package:uts_cargo/data/models/flight_model/flight_model.dart';
import 'package:uts_cargo/data/repositories/flight_repository_impl.dart';

import '../bloc/flight_bloc/flight_bloc.dart';

class FlightsPage extends StatelessWidget {
  const FlightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlightBloc(
        FlightRepositoryImpl(FlightRemoteDataSource(ApiClient())),
      )..add(LoadFlightsEvent()),
      child: const _FlightsView(),
    );
  }
}

class _FlightsView extends StatefulWidget {
  const _FlightsView();

  @override
  State<_FlightsView> createState() => _FlightsViewState();
}

class _FlightsViewState extends State<_FlightsView> {
  final ScrollController _scrollController = ScrollController();
  String _selectedStatus = 'barchasi';

  final List<Map<String, String>> _filters = [
    {'key': 'barchasi', 'label': AppStrings.all},
    {'key': 'jarayonda', 'label': AppStrings.inProcess},
    {'key': 'tranzit', 'label': AppStrings.transit},
    {'key': 'yetkazildi', 'label': AppStrings.delivered},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<FlightBloc>().add(LoadMoreFlightsEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: AppColors.mainColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.mainColor,
                      AppColors.mainColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.flight,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.chinaFlightsStatus,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.mainColor,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((f) {
                      final isSelected = _selectedStatus == f['key'];
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedStatus = f['key']!);
                          context.read<FlightBloc>().add(
                                FilterFlightsByStatusEvent(f['key']!),
                              );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.mainColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color:
                                          AppColors.mainColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                          ),
                          child: Text(
                            f['label']!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          // Content
          BlocBuilder<FlightBloc, FlightState>(
            builder: (context, state) {
              if (state is FlightLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.mainColor),
                  ),
                );
              }

              if (state is FlightFailure) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 16),
                        Text(state.error,
                            style:
                                const TextStyle(color: Color(0xFF64748B))),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => context
                              .read<FlightBloc>()
                              .add(LoadFlightsEvent()),
                          child: Text(AppStrings.retry,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              List<FlightModel> flights = [];
              bool isLoadingMore = false;

              if (state is FlightSuccess) {
                flights = state.flights;
              } else if (state is FlightLoadingMore) {
                flights = state.current.flights;
                isLoadingMore = true;
              }

              if (flights.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flight_outlined,
                            size: 80,
                            color: const Color(0xFF94A3B8).withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.noFlights,
                          style: TextStyle(
                              color: Color(0xFF64748B), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == flights.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainColor,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      return _FlightCard(flight: flights[index]);
                    },
                    childCount: flights.length + (isLoadingMore ? 1 : 0),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final FlightModel flight;

  const _FlightCard({required this.flight});

  Color get _statusColor {
    switch (flight.status) {
      case 'yetkazildi':
        return const Color(0xFF10B981);
      case 'tranzit':
        return const Color(0xFF3B82F6);
      case 'jarayonda':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color get _statusBgColor {
    switch (flight.status) {
      case 'yetkazildi':
        return const Color(0xFFECFDF5);
      case 'tranzit':
        return const Color(0xFFEFF6FF);
      case 'jarayonda':
        return const Color(0xFFFFFBEB);
      default:
        return const Color(0xFFF9FAFB);
    }
  }

  String get _statusIcon {
    switch (flight.status) {
      case 'yetkazildi':
        return '✅';
      case 'tranzit':
        return '✈️';
      case 'jarayonda':
        return '⏳';
      default:
        return '❓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.mainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        color: AppColors.mainColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      flight.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusBgColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '$_statusIcon ${flight.statusDisplay}',
                    style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    icon: Icons.inventory_2_outlined,
                    label: AppStrings.chinaWarehouse,
                    value: '📦 ${flight.warehousePeriod}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoTile(
                    icon: Icons.local_shipping_outlined,
                    label: AppStrings.arrival,
                    value: _formatDate(flight.arrivalDate),
                  ),
                ),
              ],
            ),
            if (flight.note != null && flight.note!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        flight.note!,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy', 'uz').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
