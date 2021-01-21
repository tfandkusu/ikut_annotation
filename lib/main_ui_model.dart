import 'package:freezed_annotation/freezed_annotation.dart';
part 'main_ui_model.freezed.dart';

@freezed
abstract class MainUiModel with _$MainUiModel {
  factory MainUiModel(List<String> fileNames, int imageIndex, int previousImageIndex) = _MainUiModel;
}
