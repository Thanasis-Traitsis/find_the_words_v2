import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Registrations that don't fit constructor injection: third-party classes
/// with no meaningful constructor (SharedPreferences) and classes needing
/// custom async setup after construction that isn't a simple @PostConstruct
/// method call (StorageService.init(), StoreDiscountService.create() — both
/// have private/no-args constructors, so injectable can't call them directly).
@module
abstract class RegisterModule {
  @preResolve
  @lazySingleton
  @Environment(Env.minimal)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  @lazySingleton
  @Environment(Env.minimal)
  Future<StorageService> get storageService async {
    final storage = StorageService();
    await storage.init();
    return storage;
  }

  @preResolve
  @lazySingleton
  @Environment(Env.full)
  Future<StoreDiscountService> get storeDiscountService =>
      StoreDiscountService.create();
}
