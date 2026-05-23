import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WNotificationToggleButton extends StatefulWidget {
  const WNotificationToggleButton({super.key});

  @override
  State<WNotificationToggleButton> createState() => _WNotificationToggleButtonState();
}

class _WNotificationToggleButtonState extends State<WNotificationToggleButton> {
  bool _isEnabled = true;
  bool _isLoading = false;
  static const String _prefKey = 'notifications_enabled';

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_prefKey) ?? true;
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    final isGranted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (mounted) {
      setState(() {
        _isEnabled = saved && isGranted;
      });
    }
  }

  Future<void> _toggle() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      if (_isEnabled) {
        await prefs.setBool(_prefKey, false);
        await FirebaseMessaging.instance.deleteToken();

        if (mounted) {
          setState(() => _isEnabled = false);
          context.showSnackBarMessage(AppStrings.notificationsDisabled);
        }
      } else {
        final settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional) {
          final token = await FirebaseMessaging.instance.getToken();
          await prefs.setBool(_prefKey, true);

          if (mounted) {
            setState(() => _isEnabled = true);
            context.showSnackBarMessage(AppStrings.notificationsEnabled);
          }
        } else {
          await prefs.setBool(_prefKey, false);
          if (mounted) {
            _showSettingsDialog();
          }
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.screenColor,
        title: Text(
          AppStrings.notAllowed,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(AppStrings.enableNotificationsSettings,
          style: TextStyle(color: AppColors.grayColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel, style: TextStyle(color: AppColors.grayColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _openAppSettings();
            },
            child: Text(AppStrings.settings, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _openAppSettings() async {
    debugPrint(AppStrings.goToSettings);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _toggle,
      child: Container(
        width: double.infinity,
        height: 64.0,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _isEnabled ? Icons.notifications_active : Icons.notifications_off,
                  color: _isEnabled ? AppColors.mainColor : AppColors.grayColor,
                  size: 24,
                ),
                SizedBox(width: 16.0),
                Text(
                  AppStrings.notifications,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            // Toggle switch
            _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Switch(
              value: _isEnabled,
              onChanged: (_) => _toggle(),
              activeColor: AppColors.mainColor,
              inactiveThumbColor: AppColors.grayColor,
              inactiveTrackColor: AppColors.grayColor200,
            ),
          ],
        ),
      ),
    );
  }
}