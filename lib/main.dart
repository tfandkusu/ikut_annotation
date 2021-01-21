import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:ikut_annotation/main_state_notifer_provider.dart';

void main() {
  runApp(ProviderScope(child: IkutAnnotationApp()));
}

class IkutAnnotationApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iKut Annotation',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends HookWidget {
  final FocusNode _focusNode = FocusNode()..requestFocus();

  @override
  Widget build(BuildContext context) {
    final mainStateNotifier = useProvider(mainStateNotifierProvider);
    return RawKeyboardListener(
      onKey: (key) {
        if (key is RawKeyDownEvent) {
          if (key.logicalKey.keyLabel == ']') {
            mainStateNotifier.next();
          } else if (key.logicalKey.keyLabel == '[') {
            mainStateNotifier.previous();
          }
        }
      },
      focusNode: _focusNode,
      child: Scaffold(
          appBar: AppBar(
            title: Text('iKut annotation'),
          ),
          body: Stack(children: [_buildPreviousImage(), _buildImage()])),
    );
  }

  HookBuilder _buildImage() {
    return HookBuilder(builder: (context) {
      final mainUiModel = useProvider(mainStateNotifierProvider.state);
      if (mainUiModel.fileNames.length >= 1) {
        return Image.file(File(mainUiModel.fileNames[mainUiModel.imageIndex]));
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  HookBuilder _buildPreviousImage() {
    return HookBuilder(builder: (context) {
      final mainUiModel = useProvider(mainStateNotifierProvider.state);
      if (mainUiModel.fileNames.length >= 1) {
        return Image.file(
            File(mainUiModel.fileNames[mainUiModel.previousImageIndex]));
      } else {
        return Container();
      }
    });
  }
}
