import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/core/utils/map_service.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/home/bloc/warehouse_bloc/warehouse_bloc.dart';
import 'package:uts_cargo/features/home/bloc/info_bloc/info_bloc.dart';
import 'package:uts_cargo/features/home/pages/all_warehouse_page.dart';
import 'package:uts_cargo/features/home/pages/unassigned_cargo_page.dart';
import 'package:uts_cargo/features/home/pages/warehouse_page.dart';
import 'package:uts_cargo/features/home/widgets/w_basic_management.dart';
import 'package:uts_cargo/features/home/widgets/w_contact_bottom_sheet.dart';
import 'package:uts_cargo/features/home/widgets/w_home_toolbar.dart';
import 'package:uts_cargo/features/home/widgets/w_price_bottom_sheet.dart';
import 'package:uts_cargo/features/home/widgets/w_quick_access.dart';
import 'package:uts_cargo/features/home/widgets/w_warehouse.dart';
import 'package:uts_cargo/features/home/widgets/w_warehouse_bottom_sheet.dart';
import 'package:uts_cargo/features/profile/bloc/profile_bloc.dart';
import '../../../data/models/info_model/info_model.dart';
import '../../../data/models/user_model/user_model.dart';
import '../../../data/models/warehouse/arrived_group_response.dart';
import 'flights_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InfoModel? _cachedInfo;
  String? _userId;
  String? _fullName;
  String? _phoneNumber;
  List<ArrivedGroupResponse> _lastWarehouseData = [];
  bool _isRefreshing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() {
    final authState = context.read<AuthBloc>().state;
    context.read<InfoBloc>().add(GetInfoEvent());
    context.read<WarehouseBloc>().add(GetArrivedGroupsEvent());

    if (authState is AuthenticatedState ||
        authState is PendingState ||
        authState is RejectedState) {
      context.read<ProfileBloc>().add(GetProfileEvent());
    }

    setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      final authState = context.read<AuthBloc>().state;
      context.read<InfoBloc>().add(GetInfoEvent());
      context.read<WarehouseBloc>().add(GetArrivedGroupsEvent());
      if (authState is AuthenticatedState ||
          authState is PendingState ||
          authState is RejectedState) {
        context.read<ProfileBloc>().add(GetProfileEvent());
      }
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  void _showFeatureUnavailableMessage(BuildContext context, AuthState authState) {
    String message = '';
    if (authState is UnauthenticatedState) {
      message = AppStrings.registerToUse;
    } else if (authState is PendingState) {
      message = AppStrings.accountChecking;
    } else if (authState is RejectedState) {
      message = AppStrings.accountRejectedReRegister;
    } else {
      message = AppStrings.accountMustBeVerified;
    }

    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      action: (authState is UnauthenticatedState || authState is RejectedState)
          ? SnackBarAction(
        label: authState is UnauthenticatedState
            ? AppStrings.registration
            : AppStrings.reRegister,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (authState is UnauthenticatedState) {
            Navigator.pushNamed(context, '/login');
          } else if (authState is RejectedState) {
            Navigator.pushNamed(
              context,
              '/register',
              arguments: authState.user.phone,
            );
          }
        },
      )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final bool isAuthenticated = authState is AuthenticatedState;
        final bool isPending = authState is PendingState;
        final bool isRejected = authState is RejectedState;
        final bool isUnauthenticated = authState is UnauthenticatedState;

        return Scaffold(
          backgroundColor: AppColors.screenColor,
          body: Stack(
            children: [
              Column(
                children: [
                  WHomeToolbar(
                    onLocationPressed: () {
                      final pickup = _cachedInfo?.pickup;
                      MapService.openSystemMap(
                        lat: pickup?.lat ?? 41.334485,
                        lng: pickup?.lng ?? 69.214603,
                      );
                    },
                    pickupName: _cachedInfo?.pickup.name,
                  ),
                  Expanded(
                    child: _buildMainContent(
                      authState,
                      isAuthenticated,
                      isPending || isRejected,
                      isUnauthenticated,
                      isRejected,
                    ),
                  ),
                  if (isRejected) _buildRejectionInfo(authState.user),
                ],
              ),
              if (isUnauthenticated)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildBottomRegisterButton(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRejectionInfo(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                AppStrings.accountRejected,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (user.rejectionReasonDisplay != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.reason}: ',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Text(
                    user.rejectionReasonDisplay!,
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          if (user.rejectionNote != null && user.rejectionNote!.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.comment}: ',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Text(
                    user.rejectionNote!,
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(
                context,
                '/register',
                arguments: user.phone,
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(AppStrings.reRegister),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRegisterButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.person_add, color: AppColors.mainColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.registerForFullAccess,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(AppStrings.registration),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      AuthState authState,
      bool isAuthenticated,
      bool isPendingOrRejected,
      bool isUnauthenticated,
      bool isRejected,
      ) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InfoBloc, InfoState>(
          listener: (context, state) {
            if (state is InfoSuccess) {
              setState(() => _cachedInfo = state.model);
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSuccess) {
              setState(() {
                _phoneNumber = state.model.phone;
                _userId = state.model.userId;
                _fullName = '${state.model.firstName} ${state.model.lastName}';
              });
            }
          },
        ),
        BlocListener<WarehouseBloc, WarehouseState>(
          listener: (context, state) {
            if (state is WarehouseLoaded) {
              setState(() => _lastWarehouseData = state.groups);
            }
          },
        ),
      ],
      child: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (context, state) {
          if (state is WarehouseLoading &&
              _lastWarehouseData.isEmpty &&
              _isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildMainContentBody(
            context,
            _lastWarehouseData,
            authState,
            isAuthenticated,
            isPendingOrRejected,
            isUnauthenticated,
            isRejected,
          );
        },
      ),
    );
  }

  Widget _buildMainContentBody(
      BuildContext context,
      List<ArrivedGroupResponse> groups,
      AuthState authState,
      bool isAuthenticated,
      bool isPendingOrRejected,
      bool isUnauthenticated,
      bool isRejected,
      ) {
    final bottomPadding = isRejected ? 180.0 : (isUnauthenticated ? 100.0 : 0.0);

    return RefreshIndicator(
      displacement: 150,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              WQuickAccess(
                onProhibitedPressed: () =>
                    Navigator.pushNamed(context, '/prohibited'),
                onCalculatorPressed: () {
                  if (isAuthenticated) {
                    Navigator.pushNamed(context, '/calculator');
                  } else {
                    _showFeatureUnavailableMessage(context, authState);
                  }
                },
                onFlightPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FlightsPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.orders,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(left: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllWarehousePage(
                            phoneNumber: _phoneNumber.toString(),
                            fullName: _fullName.toString(),
                            userID: _userId.toString(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      AppStrings.all,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ).paddingOnly(right: 16.0),
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final activeOrders = groups
                      .where((item) => item.paymentStatus != 'Topshirildi')
                      .toList();

                  if (activeOrders.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          AppStrings.noOrdersYet,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeOrders.length,
                    itemBuilder: (context, index) {
                      return WWarehouse(
                        model: activeOrders[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WarehousePage(
                                model: activeOrders[index],
                                phoneNumber: _phoneNumber.toString(),
                                fullName: _fullName.toString(),
                                userID: _userId.toString(),
                              ),
                            ),
                          ).then((_) {
                            context
                                .read<WarehouseBloc>()
                                .add(GetArrivedGroupsEvent());
                          });
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              WBasicManagement(
                onVideoPressed: () => Navigator.pushNamed(context, '/video'),
                onWarehousePressed: () {
                  if (isAuthenticated) {
                    _showWarehouseBottomSheet(context);
                  } else {
                    _showFeatureUnavailableMessage(context, authState);
                  }
                },
                onAboutPressed: () => Navigator.pushNamed(context, '/about'),
                onPricePressed: () => _showPriceBottomSheet(context),
                onContactPressed: () => _showContactBottomSheet(context),
                onUnassignedPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UnassignedCargoPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              if (_isRefreshing)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWarehouseBottomSheet(BuildContext context) {
    if (_cachedInfo == null || _userId == null) {
      context.showSnackBarMessage(AppStrings.loadingData);
      return;
    }
    final cleanId = _userId!.replaceFirst('UTS-', '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          WWarehouseBottomSheet(userId: cleanId, model: _cachedInfo!),
    );
  }

  void _showPriceBottomSheet(BuildContext context) {
    if (_cachedInfo == null) {
      context.showSnackBarMessage(AppStrings.loadingData);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WPriceBottomSheet(model: _cachedInfo!),
    );
  }

  void _showContactBottomSheet(BuildContext context) {
    if (_cachedInfo == null) {
      context.showSnackBarMessage(AppStrings.loadingData);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WContactBottomSheet(model: _cachedInfo!),
    );
  }
}