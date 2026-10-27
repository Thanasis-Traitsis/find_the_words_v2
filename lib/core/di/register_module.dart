import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/storage_service.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
