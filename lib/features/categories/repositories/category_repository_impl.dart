import '../../../core/database/database_service.dart';
import '../models/category_item.dart';
import './category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DatabaseService _db;

  CategoryRepositoryImpl(this._db);

  @override
  Future<List<CategoryItem>> getAllCategories() async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => _mapToCategoryItem(maps[i]));
  }

  @override
  Future<CategoryItem?> getCategory(String id) async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapToCategoryItem(maps.first);
  }

  @override
  Future<void> addCategory(CategoryItem category) async {
    final db = await _db.database;
    await db.insert(
      'categories',
      _categoryItemToMap(category),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateCategory(CategoryItem category) async {
    final db = await _db.database;
    await db.update(
      'categories',
      _categoryItemToMap(category),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _db.transaction((txn) async {
      // Update passwords in this category to 'General'
      await txn.update(
        'passwords',
        {'category': 'General'},
        where: 'category = (SELECT name FROM categories WHERE id = ?)',
        whereArgs: [id],
      );

      // Delete the category
      await txn.delete(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  CategoryItem _mapToCategoryItem(Map<String, dynamic> map) {
    return CategoryItem(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] as int),
    );
  }

  Map<String, dynamic> _categoryItemToMap(CategoryItem category) {
    return {
      'id': category.id,
      'name': category.name,
      'icon': category.icon.codePoint,
      'color': category.color.value,
    };
  }
} 