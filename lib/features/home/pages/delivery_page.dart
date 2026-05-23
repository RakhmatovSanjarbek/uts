import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../bloc/warehouse_bloc/warehouse_bloc.dart';
import '../widgets/w_delivery_method_tile.dart';
import '../widgets/w_post_form.dart';

class DeliverySelectionPage extends StatefulWidget {
  final String phoneNumber;
  final String resCode;
  final String fullName;
  final String userID;
  final int groupId;

  const DeliverySelectionPage({
    super.key,
    required this.groupId,
    required this.fullName,
    required this.userID,
    required this.phoneNumber,
    required this.resCode,
  });

  @override
  State<DeliverySelectionPage> createState() => _DeliverySelectionPageState();
}

class _DeliverySelectionPageState extends State<DeliverySelectionPage> {
  String _selectedMethod = 'Punktda';
  String? _selectedRegion;
  String? _selectedDistrict;
  String? _taxiLocation;

  final _neighborhoodController = TextEditingController();
  final _homeAddressController = TextEditingController();
  bool _isNeighborhoodValid = false;
  bool _isHomeAddressValid = false;

  static const _methods = [
    (
      'Punktda',
      'Yetkazib berish punkti',
      Icons.storefront,
      Colors.purple,
      'Punktdan o\'zingiz olib ketasiz',
    ),
    (
      'Pochta',
      'Pochta orqali',
      Icons.local_post_office,
      Colors.orange,
      'Manzilingizga pochta orqali yetkazib berish',
    ),
    (
      'Taksi',
      'Taksi orqali',
      Icons.local_taxi,
      Colors.green,
      'Tezkor yetkazib berish xizmati',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _neighborhoodController.addListener(_validateFields);
    _homeAddressController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _neighborhoodController.removeListener(_validateFields);
    _homeAddressController.removeListener(_validateFields);
    _neighborhoodController.dispose();
    _homeAddressController.dispose();
    super.dispose();
  }

  void _validateFields() => setState(() {
    _isNeighborhoodValid = _neighborhoodController.text.trim().isNotEmpty;
    _isHomeAddressValid = _homeAddressController.text.trim().isNotEmpty;
  });

  bool _isValid() {
    return switch (_selectedMethod) {
      'Punktda' => true,
      'Pochta' =>
        _selectedRegion != null &&
            _selectedDistrict != null &&
            _isNeighborhoodValid &&
            _isHomeAddressValid,
      'Taksi' => _taxiLocation?.isNotEmpty == true,
      _ => false,
    };
  }

  String _getAddressString() {
    if (_selectedMethod == 'Pochta') {
      return '$_selectedRegion viloyati, $_selectedDistrict tumani, '
          '${_neighborhoodController.text.trim()} mahallasi, '
          '${_homeAddressController.text.trim()}';
    }
    return _taxiLocation ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        title: Text(
          AppStrings.deliveryMethod,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: AppColors.screenColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<WarehouseBloc, WarehouseState>(
        listener: (context, state) {
          if (state is WarehouseLoaded) {
            context.showSnackBarMessage(AppStrings.addressSaved);
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is WarehouseError) {
            context.showSnackBarMessage(state.message);
          }
        },
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.selectDeliveryMethod,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    for (final (value, title, icon, color, subtitle)
                        in _methods) ...[
                      DeliveryMethodTile(
                        value: value,
                        title: title,
                        subtitle: subtitle,
                        icon: icon,
                        color: color,
                        groupValue: _selectedMethod,
                        onChanged: (v) => setState(() => _selectedMethod = v),
                      ),
                      const SizedBox(height: 12),
                    ],

                    const SizedBox(height: 12),

                    // Form
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: switch (_selectedMethod) {
                        'Pochta' => PostForm(
                          selectedRegion: _selectedRegion,
                          selectedDistrict: _selectedDistrict,
                          neighborhoodController: _neighborhoodController,
                          homeAddressController: _homeAddressController,
                          isNeighborhoodValid: _isNeighborhoodValid,
                          isHomeAddressValid: _isHomeAddressValid,
                          onRegionChanged: (v) => setState(() {
                            _selectedRegion = v;
                            _selectedDistrict = null;
                          }),
                          onDistrictChanged: (v) =>
                              setState(() => _selectedDistrict = v),
                        ),
                        'Taksi' => TaxiForm(
                          taxiLocation: _taxiLocation,
                          resCode: widget.resCode,
                          phoneNumber: widget.phoneNumber,
                          fullName: widget.fullName,
                          userID: widget.userID,
                          onLocationChanged: (v) => setState(() {
                            if (v == "Ma'lumot yuborildi") {
                              _taxiLocation =
                                  "Taksi orqali yetkazib berish (Telegram botga yuborildi)";
                            } else {
                              _taxiLocation = v;
                            }
                          }),
                        ),
                        _ => const SizedBox.shrink(),
                      },
                    ),
                  ],
                ),
              ),
            ),
            _SaveButton(
              isLoading: state is WarehouseLoading,
              isValid: _isValid(),
              onSave: () {
                context.read<WarehouseBloc>().add(
                  SetDeliveryEvent(
                    widget.groupId,
                    _selectedMethod,
                    _getAddressString(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final bool isLoading;
  final bool isValid;
  final VoidCallback onSave;

  const _SaveButton({
    required this.isLoading,
    required this.isValid,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isValid ? AppColors.mainColor : Colors.grey.shade400,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: isValid ? 2 : 0,
        ),
        onPressed: isLoading || !isValid ? null : onSave,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                AppStrings.save,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}
