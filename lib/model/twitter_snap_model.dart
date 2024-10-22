import 'package:freezed_annotation/freezed_annotation.dart';

part 'twitter_snap_model.freezed.dart';

@freezed
class TwitterSnapModel with _$TwitterSnapModel {
  const factory TwitterSnapModel({
    required bool isLoading,
    required List<String> log,
    required List<String> files,
  }) = _TwitterSnapModel;
}
