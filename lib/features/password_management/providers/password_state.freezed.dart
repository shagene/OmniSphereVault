// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PasswordState {
  List<PasswordEntry> get entries => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  String? get selectedCategory => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  StateStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordStateCopyWith<PasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordStateCopyWith<$Res> {
  factory $PasswordStateCopyWith(
          PasswordState value, $Res Function(PasswordState) then) =
      _$PasswordStateCopyWithImpl<$Res, PasswordState>;
  @useResult
  $Res call(
      {List<PasswordEntry> entries,
      String searchQuery,
      String? selectedCategory,
      bool isLoading,
      String? errorMessage,
      StateStatus status});
}

/// @nodoc
class _$PasswordStateCopyWithImpl<$Res, $Val extends PasswordState>
    implements $PasswordStateCopyWith<$Res> {
  _$PasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? searchQuery = null,
    Object? selectedCategory = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<PasswordEntry>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StateStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordStateImplCopyWith<$Res>
    implements $PasswordStateCopyWith<$Res> {
  factory _$$PasswordStateImplCopyWith(
          _$PasswordStateImpl value, $Res Function(_$PasswordStateImpl) then) =
      __$$PasswordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PasswordEntry> entries,
      String searchQuery,
      String? selectedCategory,
      bool isLoading,
      String? errorMessage,
      StateStatus status});
}

/// @nodoc
class __$$PasswordStateImplCopyWithImpl<$Res>
    extends _$PasswordStateCopyWithImpl<$Res, _$PasswordStateImpl>
    implements _$$PasswordStateImplCopyWith<$Res> {
  __$$PasswordStateImplCopyWithImpl(
      _$PasswordStateImpl _value, $Res Function(_$PasswordStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? searchQuery = null,
    Object? selectedCategory = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? status = null,
  }) {
    return _then(_$PasswordStateImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<PasswordEntry>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StateStatus,
    ));
  }
}

/// @nodoc

class _$PasswordStateImpl implements _PasswordState {
  const _$PasswordStateImpl(
      {final List<PasswordEntry> entries = const [],
      this.searchQuery = '',
      this.selectedCategory,
      this.isLoading = false,
      this.errorMessage,
      this.status = StateStatus.initial})
      : _entries = entries;

  final List<PasswordEntry> _entries;
  @override
  @JsonKey()
  List<PasswordEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  final String? selectedCategory;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final StateStatus status;

  @override
  String toString() {
    return 'PasswordState(entries: $entries, searchQuery: $searchQuery, selectedCategory: $selectedCategory, isLoading: $isLoading, errorMessage: $errorMessage, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordStateImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entries),
      searchQuery,
      selectedCategory,
      isLoading,
      errorMessage,
      status);

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordStateImplCopyWith<_$PasswordStateImpl> get copyWith =>
      __$$PasswordStateImplCopyWithImpl<_$PasswordStateImpl>(this, _$identity);
}

abstract class _PasswordState implements PasswordState {
  const factory _PasswordState(
      {final List<PasswordEntry> entries,
      final String searchQuery,
      final String? selectedCategory,
      final bool isLoading,
      final String? errorMessage,
      final StateStatus status}) = _$PasswordStateImpl;

  @override
  List<PasswordEntry> get entries;
  @override
  String get searchQuery;
  @override
  String? get selectedCategory;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  StateStatus get status;

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordStateImplCopyWith<_$PasswordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
