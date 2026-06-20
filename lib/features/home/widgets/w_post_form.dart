import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';

import '../../../data/models/delivery_model/uzbekistan_regions.dart';

class PostForm extends StatelessWidget {
  final String? selectedRegion;
  final String? selectedDistrict;
  final TextEditingController neighborhoodController;
  final TextEditingController homeAddressController;
  final bool isNeighborhoodValid;
  final bool isHomeAddressValid;
  final ValueChanged<String?> onRegionChanged;
  final ValueChanged<String?> onDistrictChanged;

  const PostForm({
    super.key,
    required this.selectedRegion,
    required this.selectedDistrict,
    required this.neighborhoodController,
    required this.homeAddressController,
    required this.isNeighborhoodValid,
    required this.isHomeAddressValid,
    required this.onRegionChanged,
    required this.onDistrictChanged,
  });

  @override
  Widget build(BuildContext context) {
    final districts = selectedRegion != null
        ? UzbekistanRegions.regions[selectedRegion]!
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.deliveryAddress,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _ModernDropdown(
          label: AppStrings.region,
          hint: AppStrings.selectRegion,
          value: selectedRegion,
          icon: Icons.map,
          items: UzbekistanRegions.regions.keys.toList(),
          onChanged: onRegionChanged,
        ),
        const SizedBox(height: 16),
        if (selectedRegion != null) ...[
          _ModernDropdown(
            label: AppStrings.districtCity,
            hint: AppStrings.selectDistrictCity,
            value: selectedDistrict,
            icon: Icons.location_city,
            items: districts,
            onChanged: onDistrictChanged,
          ),
          const SizedBox(height: 16),
        ],
        _ModernTextField(
          controller: neighborhoodController,
          label: AppStrings.neighborhood,
          hint: AppStrings.enterNeighborhood,
          icon: Icons.location_on,
          isValid: isNeighborhoodValid,
        ),
        const SizedBox(height: 16),
        _ModernTextField(
          controller: homeAddressController,
          label: AppStrings.homeAddress,
          hint: AppStrings.streetHouseApartment,
          icon: Icons.home,
          isValid: isHomeAddressValid,
          maxLines: 2,
        ),
      ],
    );
  }
}

class TaxiForm extends StatelessWidget {
  final String? taxiLocation;
  final String phoneNumber;
  final String resCode;
  final String fullName;
  final String userID;
  final ValueChanged<String?> onLocationChanged;

  const TaxiForm({
    super.key,
    required this.taxiLocation,
    required this.fullName,
    required this.userID,
    required this.onLocationChanged,
    required this.phoneNumber,
    required this.resCode,
  });

  String get _copyText =>
      '🔢Res kodi: $resCode\n📞Telefon raqam: $phoneNumber\n👤 Foydalanuvchi: $fullName\n🆔 ID: $userID\n📍 Xizmat: Taksi orqali yetkazib berish';

  @override
  Widget build(BuildContext context) {
    if (taxiLocation != null) {
      return _SelectedLocationCard(
        location: taxiLocation!,
        onEdit: () => onLocationChanged(null),
      );
    }
    return _TaxiInstructionCard(
      fullName: fullName,
      userID: userID,
      copyText: _copyText,
      onSent: () => onLocationChanged("Ma'lumot yuborildi"),
    );
  }
}

class _TaxiInstructionCard extends StatelessWidget {
  final String fullName;
  final String userID;
  final String copyText;
  final VoidCallback onSent;

  const _TaxiInstructionCard({
    required this.fullName,
    required this.userID,
    required this.copyText,
    required this.onSent,
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: copyText));
    if (context.mounted) {
      context.showSnackBarMessage("Ma'lumotlar nusxalandi!");
    }
  }

  Future<void> _openTelegramChat(BuildContext context) async {
    const username = 'uts_express';
    final encodedText = Uri.encodeComponent(copyText);

    final deep = Uri.parse('tg://resolve?domain=$username&text=$encodedText');
    final web = Uri.parse('https://t.me/$username?text=$encodedText');

    if (await canLaunchUrl(deep)) {
      await launchUrl(deep, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(web)) {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      context.showSnackBarMessage("Telegram ilovasi topilmadi");
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Text(
                  AppStrings.taxiDelivery,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _InfoCard(fullName: fullName, userID: userID),
          const SizedBox(height: 24),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(context),
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
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openTelegramChat(context),
              icon: const Icon(Icons.send, size: 20),
              label: Text(AppStrings.send, style: const TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF229ED9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSent,
              icon: const Icon(Icons.check_circle, size: 20),
              label: Text(AppStrings.sent, style: const TextStyle(fontSize: 16)),
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
}

class _InfoCard extends StatelessWidget {
  final String fullName;
  final String userID;

  const _InfoCard({required this.fullName, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.yourInformation,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.person, text: fullName),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.pin, text: 'ID: $userID'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _SelectedLocationCard extends StatelessWidget {
  final String location;
  final VoidCallback onEdit;

  const _SelectedLocationCard({required this.location, required this.onEdit});

  @override
  Widget build(BuildContext context) {
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
                Text(
                  AppStrings.locationReceived,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 18),
            label: Text(AppStrings.change),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }
}

class _ModernDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _ModernDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e, style: const TextStyle(fontSize: 14)),
          ),
        )
            .toList(),
        onChanged: onChanged,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.orange),
        dropdownColor: Colors.white,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}

class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isValid;
  final int maxLines;

  const _ModernTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isValid,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
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
        maxLines: maxLines,
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
      ),
    );
  }
}