// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasswordEntryImpl _$$PasswordEntryImplFromJson(Map<String, dynamic> json) =>
    _$PasswordEntryImpl(
      title: json['title'] as String,
      password: json['password'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
      url: json['url'] as String?,
      notes: json['notes'] as String?,
      lastModified: DateTime.parse(json['lastModified'] as String),
      category: json['category'] as String? ?? 'General',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      lastUsed: DateTime.parse(json['lastUsed'] as String),
      passwordLastChanged:
          DateTime.parse(json['passwordLastChanged'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      hasCustomExpirationSettings:
          json['hasCustomExpirationSettings'] as bool? ?? false,
      neverExpires: json['neverExpires'] as bool? ?? false,
    );

Map<String, dynamic> _$$PasswordEntryImplToJson(_$PasswordEntryImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'password': instance.password,
      'username': instance.username,
      'email': instance.email,
      'url': instance.url,
      'notes': instance.notes,
      'lastModified': instance.lastModified.toIso8601String(),
      'category': instance.category,
      'tags': instance.tags,
      'lastUsed': instance.lastUsed.toIso8601String(),
      'passwordLastChanged': instance.passwordLastChanged.toIso8601String(),
      'isFavorite': instance.isFavorite,
      'hasCustomExpirationSettings': instance.hasCustomExpirationSettings,
      'neverExpires': instance.neverExpires,
    };
