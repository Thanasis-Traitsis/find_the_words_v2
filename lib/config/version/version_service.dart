import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class VersionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferences _prefs;

  Map<String, dynamic>? _cachedConfig;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(hours: 6); 

  static const _configCacheKey = 'version_config_cache';
  static const _lastFetchKey = 'version_last_fetch';
  static const _optionalDismissedKey = 'optional_update_dismissed_';

  VersionService(this._prefs);

  Future<Map<String, dynamic>> _getRemoteConfig() async {
    if (_cachedConfig != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _cachedConfig!;
    }

    final cachedJson = _prefs.getString(_configCacheKey);
    final lastFetchStr = _prefs.getString(_lastFetchKey);
    
    if (cachedJson != null && lastFetchStr != null) {
      final lastFetch = DateTime.parse(lastFetchStr);
      if (DateTime.now().difference(lastFetch) < _cacheDuration) {
        _cachedConfig = jsonDecode(cachedJson);
        _lastFetchTime = lastFetch;
        return _cachedConfig!;
      }
    }

    try {
      final doc = await _firestore
          .collection('config')
          .doc('app_version')
          .get(const GetOptions(source: Source.serverAndCache));

      if (doc.exists && doc.data() != null) {
        _cachedConfig = doc.data()!;
        _lastFetchTime = DateTime.now();
        
        await _prefs.setString(_configCacheKey, jsonEncode(_cachedConfig!));
        await _prefs.setString(_lastFetchKey, _lastFetchTime!.toIso8601String());
        
        return _cachedConfig!;
      }
    } catch (e) {
      debugPrint('Error fetching remote config: $e');
      
      if (cachedJson != null) {
        return jsonDecode(cachedJson);
      }
    }

    return _getDefaultConfig();
  }

  Map<String, dynamic> _getDefaultConfig() {
    return {
      'minimum_version': '1.0.0',
      'force_update_enabled': false,
      'update_message': 'A new version is available. Please update to continue.',
      'optional_update_version': '1.0.0',
      'optional_update_message': 'A new version with improvements is available.',
      'whats_new': [],
      'ios_store_url': 'https://apps.apple.com/gr/app/βρες-τις-λέξεις-crosswords/id6505016618',
      'android_store_url': 'https://play.google.com/store/apps/details?id=com.thanasistraitsis.find_the_words',
    };
  }

  Future<VersionCheckResult> checkVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      final config = await _getRemoteConfig();

      final String minimumVersion = config['minimum_version'] ?? '1.0.0';
      final bool forceUpdateEnabled = config['force_update_enabled'] ?? false;
      final String updateMessage = config['update_message'] ?? '';
      final String optionalUpdateVersion = config['optional_update_version'] ?? '1.0.0';
      final String optionalUpdateMessage = config['optional_update_message'] ?? '';
      final List<dynamic> whatsNew = config['whats_new'] ?? [];
      final String iosStoreUrl = config['ios_store_url'] ?? '';
      final String androidStoreUrl = config['android_store_url'] ?? '';

      final dismissedVersion = _prefs.getString('$_optionalDismissedKey$optionalUpdateVersion');
      final optionalDismissed = dismissedVersion == currentVersion;

      if (forceUpdateEnabled && _isVersionLower(currentVersion, minimumVersion)) {
        return VersionCheckResult(
          needsForceUpdate: true,
          needsOptionalUpdate: false,
          message: updateMessage,
          currentVersion: currentVersion,
          minimumVersion: minimumVersion,
          whatsNew: whatsNew.cast<String>(),
          storeUrl: Platform.isIOS ? iosStoreUrl : androidStoreUrl,
        );
      }

      if (!optionalDismissed && _isVersionLower(currentVersion, optionalUpdateVersion)) {
        return VersionCheckResult(
          needsForceUpdate: false,
          needsOptionalUpdate: true,
          message: optionalUpdateMessage,
          currentVersion: currentVersion,
          minimumVersion: optionalUpdateVersion,
          whatsNew: whatsNew.cast<String>(),
          storeUrl: Platform.isIOS ? iosStoreUrl : androidStoreUrl,
        );
      }

      return VersionCheckResult(
        needsForceUpdate: false,
        needsOptionalUpdate: false,
        message: '',
        currentVersion: currentVersion,
        minimumVersion: minimumVersion,
        whatsNew: [],
        storeUrl: '',
      );
    } catch (e) {
      debugPrint('❌ Error checking version: $e');
      return VersionCheckResult(
        needsForceUpdate: false,
        needsOptionalUpdate: false,
        message: '',
        currentVersion: 'unknown',
        minimumVersion: 'unknown',
        whatsNew: [],
        storeUrl: '',
      );
    }
  }

  Future<void> dismissOptionalUpdate(String version, String currentVersion) async {
    await _prefs.setString('$_optionalDismissedKey$version', currentVersion);
  }

  bool _isVersionLower(String currentVersion, String targetVersion) {
    try {
      final current = _parseVersion(currentVersion);
      final target = _parseVersion(targetVersion);

      if (current.major < target.major) return true;
      if (current.major > target.major) return false;

      if (current.minor < target.minor) return true;
      if (current.minor > target.minor) return false;

      if (current.patch < target.patch) return true;

      return false;
    } catch (e) {
      debugPrint('Error comparing versions: $e');
      return false;
    }
  }

  Version _parseVersion(String versionString) {
    final cleanVersion = versionString.split('+').first;
    final parts = cleanVersion.split('.');
    return Version(
      major: parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0,
      minor: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
      patch: parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0,
    );
  }

  void clearCache() {
    _cachedConfig = null;
    _lastFetchTime = null;
    _prefs.remove(_configCacheKey);
    _prefs.remove(_lastFetchKey);
  }
}

class Version {
  final int major;
  final int minor;
  final int patch;

  Version({required this.major, required this.minor, required this.patch});

  @override
  String toString() => '$major.$minor.$patch';
}

class VersionCheckResult {
  final bool needsForceUpdate;
  final bool needsOptionalUpdate;
  final String message;
  final String currentVersion;
  final String minimumVersion;
  final List<String> whatsNew;
  final String storeUrl; 

  VersionCheckResult({
    required this.needsForceUpdate,
    required this.needsOptionalUpdate,
    required this.message,
    required this.currentVersion,
    required this.minimumVersion,
    required this.whatsNew,
    required this.storeUrl,
  });
}