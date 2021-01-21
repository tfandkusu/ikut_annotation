import 'package:freezed_annotation/freezed_annotation.dart';
part 'main_ui_model.freezed.dart';

@freezed
abstract class LabeledImage with _$LabeledImage {
  factory LabeledImage(String path, String label) = _LabeledImage;
}

@freezed
abstract class MainUiModel with _$MainUiModel {
  factory MainUiModel(List<LabeledImage> images, int imageIndex, int previousImageIndex, List<String> labels) = _MainUiModel;
}

