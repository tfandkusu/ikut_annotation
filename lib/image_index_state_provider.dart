import 'package:hooks_riverpod/all.dart';
import 'package:ikut_annotation/files_provider.dart';

class ImageIndex {


  int index = 0;

  int size = 0;

  ImageIndex(this.index, this.size);

}

final imageIndexStateProvider = StateProvider((context) {
  return ImageIndex(0, 0);
});

