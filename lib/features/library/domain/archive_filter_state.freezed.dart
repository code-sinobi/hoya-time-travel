// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ArchiveFilterState {
  ArchiveMode get selectedMode => throw _privateConstructorUsedError;
  String? get selectedEra => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;

  /// Create a copy of ArchiveFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchiveFilterStateCopyWith<ArchiveFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchiveFilterStateCopyWith<$Res> {
  factory $ArchiveFilterStateCopyWith(
          ArchiveFilterState value, $Res Function(ArchiveFilterState) then) =
      _$ArchiveFilterStateCopyWithImpl<$Res, ArchiveFilterState>;
  @useResult
  $Res call(
      {ArchiveMode selectedMode, String? selectedEra, String searchQuery});
}

/// @nodoc
class _$ArchiveFilterStateCopyWithImpl<$Res, $Val extends ArchiveFilterState>
    implements $ArchiveFilterStateCopyWith<$Res> {
  _$ArchiveFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchiveFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedMode = null,
    Object? selectedEra = freezed,
    Object? searchQuery = null,
  }) {
    return _then(_value.copyWith(
      selectedMode: null == selectedMode
          ? _value.selectedMode
          : selectedMode // ignore: cast_nullable_to_non_nullable
              as ArchiveMode,
      selectedEra: freezed == selectedEra
          ? _value.selectedEra
          : selectedEra // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArchiveFilterStateImplCopyWith<$Res>
    implements $ArchiveFilterStateCopyWith<$Res> {
  factory _$$ArchiveFilterStateImplCopyWith(_$ArchiveFilterStateImpl value,
          $Res Function(_$ArchiveFilterStateImpl) then) =
      __$$ArchiveFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ArchiveMode selectedMode, String? selectedEra, String searchQuery});
}

/// @nodoc
class __$$ArchiveFilterStateImplCopyWithImpl<$Res>
    extends _$ArchiveFilterStateCopyWithImpl<$Res, _$ArchiveFilterStateImpl>
    implements _$$ArchiveFilterStateImplCopyWith<$Res> {
  __$$ArchiveFilterStateImplCopyWithImpl(_$ArchiveFilterStateImpl _value,
      $Res Function(_$ArchiveFilterStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArchiveFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedMode = null,
    Object? selectedEra = freezed,
    Object? searchQuery = null,
  }) {
    return _then(_$ArchiveFilterStateImpl(
      selectedMode: null == selectedMode
          ? _value.selectedMode
          : selectedMode // ignore: cast_nullable_to_non_nullable
              as ArchiveMode,
      selectedEra: freezed == selectedEra
          ? _value.selectedEra
          : selectedEra // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ArchiveFilterStateImpl implements _ArchiveFilterState {
  const _$ArchiveFilterStateImpl(
      {this.selectedMode = ArchiveMode.vault,
      this.selectedEra,
      this.searchQuery = ''});

  @override
  @JsonKey()
  final ArchiveMode selectedMode;
  @override
  final String? selectedEra;
  @override
  @JsonKey()
  final String searchQuery;

  @override
  String toString() {
    return 'ArchiveFilterState(selectedMode: $selectedMode, selectedEra: $selectedEra, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchiveFilterStateImpl &&
            (identical(other.selectedMode, selectedMode) ||
                other.selectedMode == selectedMode) &&
            (identical(other.selectedEra, selectedEra) ||
                other.selectedEra == selectedEra) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, selectedMode, selectedEra, searchQuery);

  /// Create a copy of ArchiveFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchiveFilterStateImplCopyWith<_$ArchiveFilterStateImpl> get copyWith =>
      __$$ArchiveFilterStateImplCopyWithImpl<_$ArchiveFilterStateImpl>(
          this, _$identity);
}

abstract class _ArchiveFilterState implements ArchiveFilterState {
  const factory _ArchiveFilterState(
      {final ArchiveMode selectedMode,
      final String? selectedEra,
      final String searchQuery}) = _$ArchiveFilterStateImpl;

  @override
  ArchiveMode get selectedMode;
  @override
  String? get selectedEra;
  @override
  String get searchQuery;

  /// Create a copy of ArchiveFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchiveFilterStateImplCopyWith<_$ArchiveFilterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
