// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'twitter_snap_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TwitterSnapModel {
  bool get isLoading => throw _privateConstructorUsedError;
  List<String> get log => throw _privateConstructorUsedError;
  List<String> get files => throw _privateConstructorUsedError;

  /// Create a copy of TwitterSnapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TwitterSnapModelCopyWith<TwitterSnapModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwitterSnapModelCopyWith<$Res> {
  factory $TwitterSnapModelCopyWith(
          TwitterSnapModel value, $Res Function(TwitterSnapModel) then) =
      _$TwitterSnapModelCopyWithImpl<$Res, TwitterSnapModel>;
  @useResult
  $Res call({bool isLoading, List<String> log, List<String> files});
}

/// @nodoc
class _$TwitterSnapModelCopyWithImpl<$Res, $Val extends TwitterSnapModel>
    implements $TwitterSnapModelCopyWith<$Res> {
  _$TwitterSnapModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TwitterSnapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? log = null,
    Object? files = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      log: null == log
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as List<String>,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TwitterSnapModelImplCopyWith<$Res>
    implements $TwitterSnapModelCopyWith<$Res> {
  factory _$$TwitterSnapModelImplCopyWith(_$TwitterSnapModelImpl value,
          $Res Function(_$TwitterSnapModelImpl) then) =
      __$$TwitterSnapModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<String> log, List<String> files});
}

/// @nodoc
class __$$TwitterSnapModelImplCopyWithImpl<$Res>
    extends _$TwitterSnapModelCopyWithImpl<$Res, _$TwitterSnapModelImpl>
    implements _$$TwitterSnapModelImplCopyWith<$Res> {
  __$$TwitterSnapModelImplCopyWithImpl(_$TwitterSnapModelImpl _value,
      $Res Function(_$TwitterSnapModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TwitterSnapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? log = null,
    Object? files = null,
  }) {
    return _then(_$TwitterSnapModelImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      log: null == log
          ? _value._log
          : log // ignore: cast_nullable_to_non_nullable
              as List<String>,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$TwitterSnapModelImpl implements _TwitterSnapModel {
  const _$TwitterSnapModelImpl(
      {required this.isLoading,
      required final List<String> log,
      required final List<String> files})
      : _log = log,
        _files = files;

  @override
  final bool isLoading;
  final List<String> _log;
  @override
  List<String> get log {
    if (_log is EqualUnmodifiableListView) return _log;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_log);
  }

  final List<String> _files;
  @override
  List<String> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'TwitterSnapModel(isLoading: $isLoading, log: $log, files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwitterSnapModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._log, _log) &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_log),
      const DeepCollectionEquality().hash(_files));

  /// Create a copy of TwitterSnapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TwitterSnapModelImplCopyWith<_$TwitterSnapModelImpl> get copyWith =>
      __$$TwitterSnapModelImplCopyWithImpl<_$TwitterSnapModelImpl>(
          this, _$identity);
}

abstract class _TwitterSnapModel implements TwitterSnapModel {
  const factory _TwitterSnapModel(
      {required final bool isLoading,
      required final List<String> log,
      required final List<String> files}) = _$TwitterSnapModelImpl;

  @override
  bool get isLoading;
  @override
  List<String> get log;
  @override
  List<String> get files;

  /// Create a copy of TwitterSnapModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TwitterSnapModelImplCopyWith<_$TwitterSnapModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
