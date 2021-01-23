import 'dart:io';
import 'package:path/path.dart';

import 'package:csv/csv.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:ikut_annotation/main_ui_model.dart';

class MainStateNotifier extends StateNotifier<MainUiModel> {
  MainStateNotifier() : super(MainUiModel([], 0, 0, [])) {
    _load();
  }

  File _file;

  // 書き込み中フラグ
  bool writing = false;

  void _load() async {
    // 環境変数からホームディレクトリを取得
    final home = Platform.environment['HOME'];
    // CSVを読み込む
    _file = new File('$home/work/ikut_model/images.csv');
    final csvString = await _file.readAsString();
    final fields = CsvToListConverter().convert(csvString);
    final images = fields.map((items) {
      String path = '$home/work/ikut_model/src_image/' + items[0];
      String label = items[1];
      return LabeledImage(path, label);
    }).toList();
    final labels = ['other', 'start', 'end', 'exclude'];
    state = state.copyWith(images: images, labels: labels);
  }

  void move(int diff) {
    int nextIndex = state.imageIndex + diff;
    if (nextIndex >= state.images.length) {
      nextIndex = state.images.length - 1;
    } else if (nextIndex < 0) {
      nextIndex = 0;
    }
    state = state.copyWith(
        imageIndex: nextIndex, previousImageIndex: state.imageIndex);
  }

  /// 選択している画像のラベルを更新する
  void update(int labelIndex) async {
    if (labelIndex >= state.labels.length) {
      return;
    }
    if(writing) {
      return;
    }
    writing = true;
    String label = state.labels[labelIndex];
    List<LabeledImage> images = List.from(state.images);
    var image = state.images[state.imageIndex];
    image = image.copyWith(label: label);
    images[state.imageIndex] = image;
    state = state.copyWith(images: images);
    final csvString = ListToCsvConverter().convert(state.images.map((image) {
      final name = basename(image.path);
      return [name, image.label];
    }).toList());
    _file.writeAsString(csvString);
    writing = false;
  }
}

final mainStateNotifierProvider = StateNotifierProvider((_) {
  return MainStateNotifier();
});
