import 'package:freezed_annotation/freezed_annotation.dart';

part 'archive_filter_state.freezed.dart';

enum ArchiveMode {
  map,
  timeline,
  vault,
}

@freezed
class ArchiveFilterState with _$ArchiveFilterState {
  const factory ArchiveFilterState({
    @Default(ArchiveMode.vault) ArchiveMode selectedMode,
    String? selectedEra,
    @Default('') String searchQuery,
  }) = _ArchiveFilterState;
}
