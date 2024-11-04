import '../../../core/models/base_state.dart';
import '../models/category_item.dart';

class CategoryState extends BaseState {
  final List<CategoryItem> categories;
  final String? selectedCategory;

  const CategoryState({
    super.status = StateStatus.initial,
    super.errorMessage,
    super.isLoading = false,
    this.categories = const [],
    this.selectedCategory,
  });

  @override
  CategoryState copyWith({
    StateStatus? status,
    String? errorMessage,
    bool? isLoading,
    List<CategoryItem>? categories,
    String? selectedCategory,
  }) {
    return CategoryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((c) => c.toJson()).toList(),
      'selectedCategory': selectedCategory,
    };
  }

  factory CategoryState.fromJson(Map<String, dynamic> json) {
    return CategoryState(
      categories: (json['categories'] as List)
          .map((c) => CategoryItem.fromJson(c as Map<String, dynamic>))
          .toList(),
      selectedCategory: json['selectedCategory'] as String?,
    );
  }
} 