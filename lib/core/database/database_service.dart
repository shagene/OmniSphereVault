abstract class DatabaseService {
  Future<void> initialize();
  Future<void> close();
} 