import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:ikut_annotation/main_ui_model.dart';

class MainStateNotifier extends StateNotifier<MainUiModel> {
  MainStateNotifier() : super(MainUiModel([], 0, 0, [])) {
    _load();
  }

  void _load() async {
    // 環境変数からホームディレクトリを取得
    final home = Platform.environment['HOME'];
    // CSVを読み込む
    final file = new File('$home/work/ikut_model/images.csv');
    final csvString = await file.readAsString();
    final fields = CsvToListConverter().convert(csvString);
    final images = fields.map((items) {
      String path = '$home/work/ikut_model/src_image/' + items[0];
      String label = items[1];
      return LabeledImage(path, label);
    }).toList();
    final labels = ['other', 'start', 'end', 'exclude'];
    state = state.copyWith(images: images, labels: labels);
  }

  void next() {
    if (state.imageIndex + 1 < state.images.length) {
      state = state.copyWith(
          imageIndex: state.imageIndex + 1,
          previousImageIndex: state.imageIndex);
    }
  }

  void previous() {
    if (state.imageIndex - 1 >= 0) {
      state = state.copyWith(
          imageIndex: state.imageIndex - 1,
          previousImageIndex: state.imageIndex);
    }
  }
}

final mainStateNotifierProvider = StateNotifierProvider((_) {
  return MainStateNotifier();
});
