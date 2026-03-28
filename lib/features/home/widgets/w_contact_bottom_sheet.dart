import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/models/info_model/info_model.dart';

class WContactBottomSheet extends StatelessWidget {
  final InfoModel model;
  const WContactBottomSheet({super.key, required this.model});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Havola ochilmadi: $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.screenColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16.0),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.grayColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildContactRow(
            icon: "assets/images/telegram_logo.png",
            label: "@${model.contact.telegram}",
            onTap: () => _launchURL("https://t.me/${model.contact.telegram}"),
          ),

          const SizedBox(height: 16.0),
          _buildContactRow(
            icon: "assets/images/instagram_logo.png",
            label: "@${model.contact.instagram}",
            onTap: () => _launchURL("https://instagram.com/_u/${model.contact.instagram}"),
          ),

          const SizedBox(height: 16.0),
          _buildContactRow(
            icon: "assets/images/phone.png",
            label: model.contact.phone,
            onTap: () => _launchURL("tel:${model.contact.phone}"),
          ),

          const SizedBox(height: 24.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MCHJ "SADIKO EXPRESS"',
                style: TextStyle(color: AppColors.blackColor, fontSize: 11.0),
              ),
              Text(
                'UTSCARGOLOGISTIC@GMAIL.COM',
                style: TextStyle(color: AppColors.blackColor, fontSize: 11.0),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(icon),
            radius: 20.0,
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 16.0),
          Text(
            label,
            style: const TextStyle(color: AppColors.blackColor, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
