import 'dart:io';

import 'package:hooks_riverpod/all.dart';
import 'package:ikut_annotation/main_ui_model.dart';

class MainStateNotifier extends StateNotifier<MainUiModel> {
  MainStateNotifier() : super(MainUiModel([], 0, 0)) {
    _load();
  }

  void _load() async {
    // 環境変数からホームディレクトリを取得
    final home = Platform.environment['HOME'];
    // ファイル書き込み
    final file = File('$home/tmp/hoge.txt');
    file.writeAsString('Hello World !\n');
    // 特定ディレクトリのファイル一覧を取得
    final directory = Directory('$home/work/ikut_model/src_image');
    final futureFileNames = directory.list().map((entry) {
      return entry.path;
    }).toList();
    final fileNames = await futureFileNames;
    state = state.copyWith(fileNames: fileNames);
  }

  void next() {
    if (state.imageIndex + 1 < state.fileNames.length) {
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
