import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';

import 'package:csv/csv.dart';
import 'package:ikut_annotation/main_ui_model.dart';

class MainStateNotifier extends StateNotifier<MainUiModel> {
  MainStateNotifier() : super(MainUiModel([], 0, 0, [])) {
    _load();
  }

  // result CSV file.
  // Columns are image file name and label.
  late File _file;

  bool _writing = false;

  void _load() async {
    final labels = await _loadLabels();
    final images = await _loadResults(labels);
    state = state.copyWith(images: images, labels: labels);
  }

  /// Update selected image
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

  /// Update selected image's label
  void update(int labelIndex) async {
    if (labelIndex >= state.labels.length) {
      return;
    }
    if (_writing) {
      return;
    }
    _writing = true;
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
    _writing = false;
  }

  /// Load labels from label.txt
  Future<List<String>> _loadLabels() async {
    final dir = Directory.current.path;
    final file = new File('$dir/label.txt');
    final csvString = await file.readAsString();
    final fields = CsvToListConverter().convert(csvString);
    final labels = fields.map((items) => items[0] as String).toList();
    return labels;
  }

  /// Load labeled images from result.csv
  /// [labels] Labels
  Future<List<LabeledImage>> _loadResults(List<String> labels) async {
    final dir = Directory.current.path;
    _file = new File('$dir/result.csv');
    final csvString = await _file.readAsString();
    final fields = CsvToListConverter().convert(csvString);
    return fields.map((items) {
      String path = '$dir/image/' + items[0];
      // ラベルが付いていないときは最初のラベルを使う
      String label = labels[0];
      if (items.length >= 2) {
        label = items[1];
      }
      return LabeledImage(path, label);
    }).toList();
  }
}

final mainStateNotifierProvider =
    StateNotifierProvider<MainStateNotifier, MainUiModel>(
        (_) => MainStateNotifier());
