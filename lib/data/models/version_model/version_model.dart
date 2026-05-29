class VersionModel {
  final String version;
  final String playStoreUrl;
  final String appStoreUrl;
  final bool isForceUpdate;

  const VersionModel({
    required this.version,
    required this.playStoreUrl,
    required this.appStoreUrl,
    required this.isForceUpdate,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      version: json['version'] ?? '',
      playStoreUrl: json['play_store_url'] ?? '',
      appStoreUrl: json['app_store_url'] ?? '',
      isForceUpdate: json['is_force_update'] ?? true,
    );
  }
}