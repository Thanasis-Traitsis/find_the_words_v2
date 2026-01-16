import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();
  static NavigationService get instance => _instance;

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  BuildContext? get context => rootNavigatorKey.currentContext;

  GoRouter get router => GoRouter.of(rootNavigatorKey.currentContext!);

  void go(String path, {Object? extra}) {
    router.go(path, extra: extra);
  }

  void push(String path, {Object? extra}) {
    router.push(path, extra: extra);
  }

  void pop([Object? result]) {
    router.pop(result);
  }

  void pushReplacement(String path, {Object? extra}) {
    router.pushReplacement(path, extra: extra);
  }

  void replace(String path, {Object? extra}) {
    router.replace(path, extra: extra);
  }

  String get currentLocation => GoRouter.of(
    rootNavigatorKey.currentContext!,
  ).routerDelegate.currentConfiguration.uri.toString();
}
