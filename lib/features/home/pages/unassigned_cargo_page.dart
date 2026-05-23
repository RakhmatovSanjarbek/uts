import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../data/models/unassigned_model/unassigned_model.dart';
import '../bloc/unassigned_bloc/unassigned_bloc.dart';

class UnassignedCargoPage extends StatefulWidget {
  const UnassignedCargoPage({super.key});

  @override
  State<UnassignedCargoPage> createState() => _UnassignedCargoPageState();
}

class _UnassignedCargoPageState extends State<UnassignedCargoPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<UnassignedBloc>().add(LoadUnassignedEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UnassignedBloc>().add(LoadMoreUnassignedEvent());
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<UnassignedBloc>().add(SearchUnassignedEvent(query));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.untrackedGoods,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search
          Container(
            color: AppColors.mainColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: AppStrings.searchByTrackOrFlight,
                  hintStyle: TextStyle(
                    color: AppColors.grayColor.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.mainColor, size: 22),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: AppColors.grayColor, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: BlocBuilder<UnassignedBloc, UnassignedState>(
              builder: (context, state) {
                if (state is UnassignedLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.mainColor),
                  );
                }

                if (state is UnassignedFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: AppColors.grayColor),
                        const SizedBox(height: 16),
                        Text(state.error,
                            style: const TextStyle(color: AppColors.grayColor)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => context.read<UnassignedBloc>().add(LoadUnassignedEvent()),
                          child: Text(AppStrings.retry, style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }

                List<UnassignedCargoModel> items = [];
                bool isLoadingMore = false;
                int totalCount = 0;

                if (state is UnassignedSuccess) {
                  items = state.items;
                  totalCount = state.totalCount;
                } else if (state is UnassignedLoadingMore) {
                  items = state.current.items;
                  totalCount = state.current.totalCount;
                  isLoadingMore = true;
                }
                return Column(
                  children: [
                    // Info bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jami: $totalCount ta tovar',
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 13,
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.grayColor200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.close, size: 14, color: AppColors.grayColor),
                                    SizedBox(width: 4),
                                    Text(AppStrings.clear,
                                        style: TextStyle(
                                            color: AppColors.grayColor, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // List
                    Expanded(
                      child: items.isEmpty
                          ? _buildEmpty()
                          : RefreshIndicator(
                              color: AppColors.mainColor,
                              onRefresh: () async {
                                _searchController.clear();
                                context.read<UnassignedBloc>().add(LoadUnassignedEvent());
                              },
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: items.length + (isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == items.length) {
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
                                  return _buildItem(items[index]);
                                },
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.grayColor, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppStrings.cargoNotFoundContactAdmin,
                style: TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(UnassignedCargoModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.mainColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.trackCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.flight, size: 14, color: AppColors.grayColor),
                    const SizedBox(width: 4),
                    Text(
                      '${AppStrings.flight}: ${item.flightName}',
                      style: const TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                if (item.note != null && item.note!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.note!,
                    style: TextStyle(
                      color: AppColors.grayColor.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Sana
          Text(
            DateFormat('dd.MM.yyyy').format(item.createdAt),
            style: const TextStyle(
              color: AppColors.grayColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    final hasSearch = _searchController.text.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearch ? Icons.search_off : Icons.inventory_2_outlined,
              size: 80,
              color: AppColors.grayColor.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              hasSearch
                  ? '${_searchController.text} ${AppStrings.nothingFoundByFlight}'
                  : AppStrings.noUntrackedGoods,
              style: const TextStyle(
                color: AppColors.grayColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasSearch) ...[
              const SizedBox(height: 12),
              Text(
                AppStrings.searchWithOtherTrackOrFlight,
                style: TextStyle(color: AppColors.grayColor, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
