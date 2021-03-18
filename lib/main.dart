import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  @override
  Widget build(BuildContext context) {
    final mainStateNotifier = useProvider(mainStateNotifierProvider);
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey.keyLabel == ']') {
            mainStateNotifier.move(1);
          } else if (event.logicalKey.keyLabel == '[') {
            mainStateNotifier.move(-1);
          } else if (event.logicalKey.keyLabel == 'p') {
            mainStateNotifier.move(100);
          } else if (event.logicalKey.keyLabel == 'o') {
            mainStateNotifier.move(-100);
          } else if (event.logicalKey.keyLabel == 'z') {
            mainStateNotifier.update(0);
          } else if (event.logicalKey.keyLabel == 'x') {
            mainStateNotifier.update(1);
          } else if (event.logicalKey.keyLabel == 'c') {
            mainStateNotifier.update(2);
          } else if (event.logicalKey.keyLabel == 'v') {
            mainStateNotifier.update(3);
          }
        }
        return true;
      },
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
        return Container(
          color: Colors.black,
          constraints: BoxConstraints.expand(),
          child: Image.file(
              File(mainUiModel.images[mainUiModel.imageIndex].path),
              fit: BoxFit.contain),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  HookBuilder _buildPreviousImage() {
    return HookBuilder(builder: (context) {
      final mainUiModel = useProvider(mainStateNotifierProvider.state);
      if (mainUiModel.images.length >= 1) {
        return Container(
          color: Colors.black,
          constraints: BoxConstraints.expand(),
          child: Image.file(
              File(mainUiModel.images[mainUiModel.previousImageIndex].path),
              fit: BoxFit.contain),
        );
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
                    child: Text(mainUiModel.imageIndex.toString(),
                        style: textStyle)),
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
