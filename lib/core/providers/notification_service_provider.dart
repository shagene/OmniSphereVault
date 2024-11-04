import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

// Initialize notification service
final notificationServiceInitializerProvider = FutureProvider<NotificationService>((ref) async {
  final service = NotificationService();
  await service.initialize();
  return service;
});

// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final notificationService = ref.watch(notificationServiceInitializerProvider);
  return notificationService.when(
    data: (service) => service,
    loading: () => throw UnimplementedError('Notification service is not initialized'),
    error: (err, stack) => throw Exception('Failed to initialize notification service: $err'),
  );
}); 