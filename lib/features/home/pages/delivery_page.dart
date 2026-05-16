import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../data/models/delivery_model/uzbekistan_regions.dart';
import '../bloc/warehouse_bloc.dart';

class DeliverySelectionPage extends StatefulWidget {
  final String fullName;
  final String userID;
  final int groupId;

  const DeliverySelectionPage({
    super.key,
    required this.groupId,
    required this.fullName,
    required this.userID,
  });

  @override
  State<DeliverySelectionPage> createState() => _DeliverySelectionPageState();
}

class _DeliverySelectionPageState extends State<DeliverySelectionPage> {
  String _selectedMethod = 'Punktda';
  String? _selectedRegion;
  String? _selectedDistrict;
  final _neighborhoodController = TextEditingController();
  final _homeAddressController = TextEditingController();
  List<String> _districts = [];

  // Validatsiya uchun

  bool _isNeighborhoodValid = false;
  bool _isHomeAddressValid = false;

  // Taksi uchun
  String? _taxiLocation;

  // Telegram account
  final String _telegramAccount = "uts_express";

  @override
  void initState() {
    super.initState();
    _neighborhoodController.addListener(_validateFields);
    _homeAddressController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      _isNeighborhoodValid = _neighborhoodController.text.trim().isNotEmpty;
      _isHomeAddressValid = _homeAddressController.text.trim().isNotEmpty;
    });
  }
  // URL launch method
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Agar link ochilmasa, browserda ochish
      final Uri webUrl = Uri.parse("https://t.me/$_telegramAccount");
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        title: const Text(
          'Yetkazib berish usuli',
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
            Navigator.pop(context);
          } else if (state is WarehouseError) {
            context.showSnackBarMessage(state.message);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Yetkazib berish usulini tanlang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildMethodTile(
                        'Punktda',
                        'Yetkazib berish punkti',
                        Icons.storefront,
                        Colors.purple,
                        'Punktdan o\'zingiz olib ketasiz',
                      ),
                      const SizedBox(height: 12),

                      _buildMethodTile(
                        'Pochta',
                        'Pochta orqali',
                        Icons.local_post_office,
                        Colors.orange,
                        'Manzilingizga pochta orqali yetkazib berish',
                      ),
                      const SizedBox(height: 12),

                      _buildMethodTile(
                        'Taksi',
                        'Taksi orqali',
                        Icons.local_taxi,
                        Colors.green,
                        'Tezkor yetkazib berish xizmati',
                      ),

                      const SizedBox(height: 24),

                      // Tanlangan metodga qarab forma
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildMethodForm(),
                      ),
                    ],
                  ),
                ),
              ),

              // Save button
              _buildSaveButton(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMethodTile(
      String value,
      String title,
      IconData icon,
      Color color,
      String subtitle,
      ) {
    final isSelected = _selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: RadioListTile<String>(
          value: value,
          groupValue: _selectedMethod,
          onChanged: (v) {
            setState(() {
              _selectedMethod = v!;
            });
          },
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 16,
              color: isSelected ? color : Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodForm() {
    switch (_selectedMethod) {
      case 'Pochta':
        return _buildPostForm();
      case 'Taksi':
        return _buildTaxiForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPostForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yetkazib berish manzili',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        _buildModernDropdown(
          label: 'Viloyat',
          hint: 'Viloyatni tanlang',
          value: _selectedRegion,
          icon: Icons.map,
          items: UzbekistanRegions.regions.keys.toList(),
          onChanged: (value) {
            setState(() {
              _selectedRegion = value;
              _selectedDistrict = null;
              _districts = value != null
                  ? UzbekistanRegions.regions[value]!
                  : [];
            });
          },
        ),
        const SizedBox(height: 16),

        if (_selectedRegion != null)
          _buildModernDropdown(
            label: 'Tuman/Shahar',
            hint: 'Tuman yoki shaharni tanlang',
            value: _selectedDistrict,
            icon: Icons.location_city,
            items: _districts,
            onChanged: (value) {
              setState(() {
                _selectedDistrict = value;
              });
            },
          ),

        if (_selectedRegion != null) const SizedBox(height: 16),

        // Mahalla
        _buildModernTextField(
          controller: _neighborhoodController,
          label: 'Mahalla',
          hint: 'Mahalla nomini kiriting',
          icon: Icons.location_on,
          isValid: _isNeighborhoodValid,
        ),
        const SizedBox(height: 16),

        // Uy manzili
        _buildModernTextField(
          controller: _homeAddressController,
          label: 'Uy manzili',
          hint: 'Ko\'cha, uy raqami, kvartira',
          icon: Icons.home,
          isValid: _isHomeAddressValid,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildModernDropdown({
    required String label,
    required String hint,
    required String? value,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.orange, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: Icon(icon, color: Colors.orange),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.orange),
        dropdownColor: Colors.white,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isValid,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.orange, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: Icon(icon, color: isValid ? Colors.green : Colors.grey),
          suffixIcon: isValid
              ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
              : null,
          filled: true,
          fillColor: Colors.white,
        ),
        maxLines: maxLines,
        onChanged: (value) => _validateFields(),
      ),
    );
  }

  // ============ TAKSI QISMI (YANGILANGAN) ============

  Widget _buildTaxiForm() {
    if (_taxiLocation != null) {
      return _buildSelectedLocationCard();
    }

    return _buildTaxiInstructionCard();
  }

  Widget _buildTaxiInstructionCard() {
    // Matnni kopiya qilish uchun
    final String copyText = '''
👤 Foydalanuvchi: ${widget.fullName}
🆔 ID: ${widget.userID}
📍 Xizmat: Taksi orqali yetkazib berish
''';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.teal.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.local_taxi, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Taksi orqali yetkazib berish',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Ma'lumot kartasi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sizning ma\'lumotlaringiz:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(widget.fullName, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.pin, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('ID: ${widget.userID}', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Telegram yozuvi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.share, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ma\'lumotlarni nusxalab, o\'zingizga qulay messenger orqali yuboring:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Nusxa olinadigan matn
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      SelectableText(
                        copyText,
                        style: const TextStyle(fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: copyText));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('✅ Ma\'lumotlar nusxalandi!'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.copy, size: 18),
                              label: const Text('Nusxalash'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _shareText(copyText),
              icon: const Icon(Icons.share, size: 20),
              label: const Text('Ulashish (Telegram, WhatsApp va boshqalar)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _taxiLocation = "Ma'lumot yuborildi";
                });
              },
              icon: const Icon(Icons.check_circle, size: 20),
              label: const Text('Yubordim', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _shareText(String text) async {
    final Uri shareUrl = Uri.parse(
        "https://t.me/share/url?url=${Uri.encodeComponent(text)}&text=${Uri.encodeComponent(text)}"
    );
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📋 Matn nusxalandi! Endi istalgan messengerga joylashtiring'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildSelectedLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Joylashuv qabul qilindi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  _taxiLocation!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _taxiLocation = null),
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('O\'zgartirish'),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(WarehouseState state) {
    bool isLoading = state is WarehouseLoading;
    bool isValid = _isValid();

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
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 24,
          top: 12,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid
                ? AppColors.mainColor
                : Colors.grey.shade400,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: isValid ? 2 : 0,
          ),
          onPressed: isLoading || !isValid
              ? null
              : () {
            String address = _getAddressString();
            context.read<WarehouseBloc>().add(
              SetDeliveryEvent(widget.groupId, _selectedMethod, address),
            );
          },
          child: isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : const Text(
            'Saqlash',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  bool _isValid() {
    if (_selectedMethod == 'Punktda') return true;

    if (_selectedMethod == 'Pochta') {
      return _selectedRegion != null &&
          _selectedRegion!.isNotEmpty &&
          _selectedDistrict != null &&
          _selectedDistrict!.isNotEmpty &&
          _neighborhoodController.text.trim().isNotEmpty &&
          _homeAddressController.text.trim().isNotEmpty;
    }

    if (_selectedMethod == 'Taksi') {
      return _taxiLocation != null && _taxiLocation!.isNotEmpty;
    }

    return false;
  }

  String _getAddressString() {
    if (_selectedMethod == 'Pochta') {
      return '$_selectedRegion viloyati, $_selectedDistrict tumani, ${_neighborhoodController.text.trim()} mahallasi, ${_homeAddressController.text.trim()}';
    }
    return _taxiLocation ?? '';
  }

  @override
  void dispose() {
    _neighborhoodController.removeListener(_validateFields);
    _homeAddressController.removeListener(_validateFields);
    _neighborhoodController.dispose();
    _homeAddressController.dispose();
    super.dispose();
  }
}