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
            mainStateNotifier.move(1);
          } else if (key.logicalKey.keyLabel == '[') {
            mainStateNotifier.move(-1);
          } else if (key.logicalKey.keyLabel == 'p') {
            mainStateNotifier.move(100);
          } else if (key.logicalKey.keyLabel == 'o') {
            mainStateNotifier.move(-100);
          }
        }
      },
      focusNode: _focusNode,
      child: Scaffold(
          appBar: AppBar(
            title: Text('iKut annotation'),
          ),
          body: Stack(children: [
            _buildPreviousImage(),
            _buildImage(),
            _buildLabels()
          ])),
    );
  }

  HookBuilder _buildImage() {
    return HookBuilder(builder: (context) {
      final mainUiModel = useProvider(mainStateNotifierProvider.state);
      if (mainUiModel.images.length >= 1) {
        return Image.file(
            File(mainUiModel.images[mainUiModel.imageIndex].path));
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  HookBuilder _buildPreviousImage() {
    return HookBuilder(builder: (context) {
      final mainUiModel = useProvider(mainStateNotifierProvider.state);
      if (mainUiModel.images.length >= 1) {
        return Image.file(
            File(mainUiModel.images[mainUiModel.previousImageIndex].path));
      } else {
        return Container();
      }
    });
  }

  HookBuilder _buildLabels() {
    return HookBuilder(builder: (context) {
      final textStyle = TextStyle(color: Colors.white, fontSize: 32);
      final mainUiModel = useProvider(mainStateNotifierProvider.state);
      if (mainUiModel.images.length >= 1) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                    color: Colors.black54,
                    padding: EdgeInsets.all(16),
                    child:
                        Text(mainUiModel.imageIndex.toString(), style: textStyle)),
                Spacer()
              ],
            ),
            Spacer(),
            Container(
                color: Colors.black54,
                padding: EdgeInsets.all(16),
                child: Row(
                    children: mainUiModel.labels.map((label) {
                  return Expanded(
                      child: Visibility(
                          visible: label ==
                              mainUiModel.images[mainUiModel.imageIndex].label,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Text(label, style: textStyle)));
                }).toList()))
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
