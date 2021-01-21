import 'dart:io';

import 'package:hooks_riverpod/all.dart';
import 'package:ikut_annotation/image_index_state_provider.dart';

// ignore: top_level_function_literal_block
final filesProvider = Provider((context) async {
  // 環境変数からホームディレクトリを取得
  final home = Platform.environment['HOME'];
  // ファイル書き込み
  final file = File('$home/tmp/hoge.txt');
  file.writeAsString('Hello World !\n');
  // 特定ディレクトリのファイル一覧を取得
  final directory = Directory('$home/work/ikut_model/src_image');
  final files = directory.list().map((entry){
    return entry.path;
  }).toList();
  return files;
});
