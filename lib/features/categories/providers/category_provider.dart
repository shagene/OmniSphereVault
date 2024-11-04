import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/models/base_state.dart';
import './category_state.dart';
import '../models/category_item.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return CategoryNotifier(storageService);
});

class CategoryNotifier extends StateNotifier<CategoryState> {
  final StorageService _storageService;
  static const String _storageKey = 'categories';

  CategoryNotifier(this._storageService) : super(const CategoryState()) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      final savedState = await _storageService.getData(_storageKey);
      if (savedState != null) {
        state = CategoryState.fromJson(savedState);
      }

      state = state.copyWith(
        status: StateStatus.success,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to load categories: $e',
        isLoading: false,
      );
    }
  }

  Future<void> addCategory(CategoryItem category) async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      final updatedCategories = [...state.categories, category];
      await _saveCategories(updatedCategories);

      state = state.copyWith(
        status: StateStatus.success,
        categories: updatedCategories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to add category: $e',
        isLoading: false,
      );
    }
  }

  Future<void> updateCategory(CategoryItem category) async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      final updatedCategories = state.categories.map((c) {
        return c.name == category.name ? category : c;
      }).toList();

      await _saveCategories(updatedCategories);

      state = state.copyWith(
        status: StateStatus.success,
        categories: updatedCategories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to update category: $e',
        isLoading: false,
      );
    }
  }

  Future<void> deleteCategory(String name) async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      final updatedCategories = state.categories
          .where((c) => c.name != name)
          .toList();

      await _saveCategories(updatedCategories);

      state = state.copyWith(
        status: StateStatus.success,
        categories: updatedCategories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to delete category: $e',
        isLoading: false,
      );
    }
  }

  Future<void> _saveCategories(List<CategoryItem> categories) async {
    final stateToSave = state.copyWith(categories: categories);
    await _storageService.saveData(_storageKey, stateToSave.toJson());
  }
} 