import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import './category_state.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier();
});

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(const CategoryState());

  Future<void> addCategory(CategoryItem category) async {
    state = state.copyWith(
      categories: [...state.categories, category],
    );
  }

  Future<void> updateCategory(CategoryItem category) async {
    final updatedCategories = state.categories.map((c) {
      return c.name == category.name ? category : c;
    }).toList();

    state = state.copyWith(categories: updatedCategories);
  }

  Future<void> deleteCategory(String name) async {
    state = state.copyWith(
      categories: state.categories.where((c) => c.name != name).toList(),
    );
  }
} 