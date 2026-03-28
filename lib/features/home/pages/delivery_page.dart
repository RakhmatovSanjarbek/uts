import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/string/app_string.dart';

import '../../../core/theme/app_colors.dart';
import '../bloc/warehouse_bloc.dart';

class DeliverySelectionPage extends StatefulWidget {
  final int groupId;
  const DeliverySelectionPage({super.key, required this.groupId});

  @override
  State<DeliverySelectionPage> createState() => _DeliverySelectionPageState();
}

class _DeliverySelectionPageState extends State<DeliverySelectionPage> {
  String _selectedMethod = 'Punktda';
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.delivery)),
      body: BlocConsumer<WarehouseBloc, WarehouseState>(
        listener: (context, state) {
          if (state is WarehouseLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Manzil muvaffaqiyatli saqlandi!")),
            );
            Navigator.pop(context);
          } else if (state is WarehouseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(AppStrings.selectDeliveryMethod,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _methodTile('Punktda', 'Punktda olib ketish', Icons.storefront),
              _methodTile('Pochta', 'Pochta orqali', Icons.local_post_office),
              _methodTile('Taksi', 'Taksi orqali', Icons.local_taxi),

              if (_selectedMethod != 'Punktda') ...[
                const SizedBox(height: 24),
                TextField(
                  controller: _addressController,
                  enabled: state is! WarehouseLoading,
                  decoration: InputDecoration(
                    labelText: "To'liq manzil",
                    hintText: AppStrings.fullAddressHint,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              if (state is WarehouseLoading)
                const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (context, state) {
          bool isLoading = state is WarehouseLoading;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: isLoading ? null : () {
              context.read<WarehouseBloc>().add(SetDeliveryEvent(
                widget.groupId,
                _selectedMethod,
                _selectedMethod == 'Punktda' ? null : _addressController.text,
              ));
            },
            child: isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(AppStrings.save, style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _methodTile(String value, String title, IconData icon) {
    return RadioListTile(
      value: value,
      groupValue: _selectedMethod,
      onChanged: (v) => setState(() => _selectedMethod = v.toString()),
      title: Text(title),
      secondary: Icon(icon),
      contentPadding: EdgeInsets.zero,
    );
  }
}