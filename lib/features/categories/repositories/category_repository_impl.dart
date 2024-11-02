import '../models/category.dart';
import './category_repository.dart';
import '../../../core/database/database_service.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DatabaseService _database;

  CategoryRepositoryImpl(this._database);

  @override
  Future<List<Category>> getAllCategories() async {
    // TODO: Implement database query
    throw UnimplementedError();
  }

  @override
  Future<Category?> getCategory(String id) async {
    // TODO: Implement database query
    throw UnimplementedError();
  }

  @override
  Future<void> addCategory(Category category) async {
    // TODO: Implement database insertion
    throw UnimplementedError();
  }

  @override
  Future<void> updateCategory(Category category) async {
    // TODO: Implement database update
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCategory(String id) async {
    // TODO: Implement database deletion
    throw UnimplementedError();
  }
} 