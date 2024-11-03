import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppState {
  initial,
  authenticated,
  unauthenticated,
  locked,
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial);

  void setAuthenticated() => state = AppState.authenticated;
  void setUnauthenticated() => state = AppState.unauthenticated;
  void setLocked() => state = AppState.locked;
} 