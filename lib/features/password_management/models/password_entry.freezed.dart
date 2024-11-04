// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PasswordEntry _$PasswordEntryFromJson(Map<String, dynamic> json) {
  return _PasswordEntry.fromJson(json);
}

/// @nodoc
mixin _$PasswordEntry {
  String get title => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get lastModified => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime get lastUsed => throw _privateConstructorUsedError;
  DateTime get passwordLastChanged => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get hasCustomExpirationSettings => throw _privateConstructorUsedError;
  bool get neverExpires => throw _privateConstructorUsedError;

  /// Serializes this PasswordEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordEntryCopyWith<PasswordEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordEntryCopyWith<$Res> {
  factory $PasswordEntryCopyWith(
          PasswordEntry value, $Res Function(PasswordEntry) then) =
      _$PasswordEntryCopyWithImpl<$Res, PasswordEntry>;
  @useResult
  $Res call(
      {String title,
      String password,
      String? username,
      String? email,
      String? url,
      String? notes,
      DateTime lastModified,
      String category,
      List<String> tags,
      DateTime lastUsed,
      DateTime passwordLastChanged,
      bool isFavorite,
      bool hasCustomExpirationSettings,
      bool neverExpires});
}

/// @nodoc
class _$PasswordEntryCopyWithImpl<$Res, $Val extends PasswordEntry>
    implements $PasswordEntryCopyWith<$Res> {
  _$PasswordEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? password = null,
    Object? username = freezed,
    Object? email = freezed,
    Object? url = freezed,
    Object? notes = freezed,
    Object? lastModified = null,
    Object? category = null,
    Object? tags = null,
    Object? lastUsed = null,
    Object? passwordLastChanged = null,
    Object? isFavorite = null,
    Object? hasCustomExpirationSettings = null,
    Object? neverExpires = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUsed: null == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      passwordLastChanged: null == passwordLastChanged
          ? _value.passwordLastChanged
          : passwordLastChanged // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCustomExpirationSettings: null == hasCustomExpirationSettings
          ? _value.hasCustomExpirationSettings
          : hasCustomExpirationSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      neverExpires: null == neverExpires
          ? _value.neverExpires
          : neverExpires // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordEntryImplCopyWith<$Res>
    implements $PasswordEntryCopyWith<$Res> {
  factory _$$PasswordEntryImplCopyWith(
          _$PasswordEntryImpl value, $Res Function(_$PasswordEntryImpl) then) =
      __$$PasswordEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String password,
      String? username,
      String? email,
      String? url,
      String? notes,
      DateTime lastModified,
      String category,
      List<String> tags,
      DateTime lastUsed,
      DateTime passwordLastChanged,
      bool isFavorite,
      bool hasCustomExpirationSettings,
      bool neverExpires});
}

/// @nodoc
class __$$PasswordEntryImplCopyWithImpl<$Res>
    extends _$PasswordEntryCopyWithImpl<$Res, _$PasswordEntryImpl>
    implements _$$PasswordEntryImplCopyWith<$Res> {
  __$$PasswordEntryImplCopyWithImpl(
      _$PasswordEntryImpl _value, $Res Function(_$PasswordEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? password = null,
    Object? username = freezed,
    Object? email = freezed,
    Object? url = freezed,
    Object? notes = freezed,
    Object? lastModified = null,
    Object? category = null,
    Object? tags = null,
    Object? lastUsed = null,
    Object? passwordLastChanged = null,
    Object? isFavorite = null,
    Object? hasCustomExpirationSettings = null,
    Object? neverExpires = null,
  }) {
    return _then(_$PasswordEntryImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUsed: null == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      passwordLastChanged: null == passwordLastChanged
          ? _value.passwordLastChanged
          : passwordLastChanged // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCustomExpirationSettings: null == hasCustomExpirationSettings
          ? _value.hasCustomExpirationSettings
          : hasCustomExpirationSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      neverExpires: null == neverExpires
          ? _value.neverExpires
          : neverExpires // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordEntryImpl implements _PasswordEntry {
  const _$PasswordEntryImpl(
      {required this.title,
      required this.password,
      this.username,
      this.email,
      this.url,
      this.notes,
      required this.lastModified,
      this.category = 'General',
      final List<String> tags = const [],
      required this.lastUsed,
      required this.passwordLastChanged,
      this.isFavorite = false,
      this.hasCustomExpirationSettings = false,
      this.neverExpires = false})
      : _tags = tags;

  factory _$PasswordEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordEntryImplFromJson(json);

  @override
  final String title;
  @override
  final String password;
  @override
  final String? username;
  @override
  final String? email;
  @override
  final String? url;
  @override
  final String? notes;
  @override
  final DateTime lastModified;
  @override
  @JsonKey()
  final String category;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime lastUsed;
  @override
  final DateTime passwordLastChanged;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final bool hasCustomExpirationSettings;
  @override
  @JsonKey()
  final bool neverExpires;

  @override
  String toString() {
    return 'PasswordEntry(title: $title, password: $password, username: $username, email: $email, url: $url, notes: $notes, lastModified: $lastModified, category: $category, tags: $tags, lastUsed: $lastUsed, passwordLastChanged: $passwordLastChanged, isFavorite: $isFavorite, hasCustomExpirationSettings: $hasCustomExpirationSettings, neverExpires: $neverExpires)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordEntryImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed) &&
            (identical(other.passwordLastChanged, passwordLastChanged) ||
                other.passwordLastChanged == passwordLastChanged) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.hasCustomExpirationSettings,
                    hasCustomExpirationSettings) ||
                other.hasCustomExpirationSettings ==
                    hasCustomExpirationSettings) &&
            (identical(other.neverExpires, neverExpires) ||
                other.neverExpires == neverExpires));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      password,
      username,
      email,
      url,
      notes,
      lastModified,
      category,
      const DeepCollectionEquality().hash(_tags),
      lastUsed,
      passwordLastChanged,
      isFavorite,
      hasCustomExpirationSettings,
      neverExpires);

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordEntryImplCopyWith<_$PasswordEntryImpl> get copyWith =>
      __$$PasswordEntryImplCopyWithImpl<_$PasswordEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordEntryImplToJson(
      this,
    );
  }
}

abstract class _PasswordEntry implements PasswordEntry {
  const factory _PasswordEntry(
      {required final String title,
      required final String password,
      final String? username,
      final String? email,
      final String? url,
      final String? notes,
      required final DateTime lastModified,
      final String category,
      final List<String> tags,
      required final DateTime lastUsed,
      required final DateTime passwordLastChanged,
      final bool isFavorite,
      final bool hasCustomExpirationSettings,
      final bool neverExpires}) = _$PasswordEntryImpl;

  factory _PasswordEntry.fromJson(Map<String, dynamic> json) =
      _$PasswordEntryImpl.fromJson;

  @override
  String get title;
  @override
  String get password;
  @override
  String? get username;
  @override
  String? get email;
  @override
  String? get url;
  @override
  String? get notes;
  @override
  DateTime get lastModified;
  @override
  String get category;
  @override
  List<String> get tags;
  @override
  DateTime get lastUsed;
  @override
  DateTime get passwordLastChanged;
  @override
  bool get isFavorite;
  @override
  bool get hasCustomExpirationSettings;
  @override
  bool get neverExpires;

  /// Create a copy of PasswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordEntryImplCopyWith<_$PasswordEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
