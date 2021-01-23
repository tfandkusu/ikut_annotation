import 'package:hooks_riverpod/all.dart';

class ImageIndex {


  int index = 0;

  int size = 0;

  ImageIndex(this.index, this.size);

}

final imageIndexStateProvider = StateProvider((context) {
  return ImageIndex(0, 0);
});

