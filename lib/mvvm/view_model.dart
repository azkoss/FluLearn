import 'dart:async';

import 'package:flutter/material.dart';

///
///ViewModel基类
///See [StreamController],[StreamBuilder],[Sink],[Stream]
///
abstract class ViewModelBase<T> {
  bool _initDone = false;
  StreamController<T> _streamController = StreamController.broadcast();

  Sink<T> get inputData => _streamController;

  Stream<T> get outputData => _streamController.stream;

  @mustCallSuper
  void onCreate(BuildContext context) {
    if (_initDone) {
      return;
    }
    _initDone = true;
    doInit(context);
  }

  @protected
  Future fetchData(BuildContext context);

  @protected
  void doInit(BuildContext context);

  @mustCallSuper
  void onDestroy() {
    _streamController.close();
  }
}

///
///将ViewModel和Widget绑定
///
class ViewModelProvider<T extends ViewModelBase> extends StatefulWidget {
  final T viewModel;
  final Widget child;

  ViewModelProvider({
    @required this.viewModel,
    @required this.child,
  });

  static T create<T extends ViewModelBase>(BuildContext context) {
    final Type type = _typeOf<ViewModelProvider<T>>();
    ViewModelProvider<T> provider = context.ancestorWidgetOfExactType(type);
    T viewModel = provider.viewModel;
    viewModel.onCreate(context);
    return viewModel;
  }

  static Type _typeOf<T>() {
    return T;
  }

  @override
  _ViewModelProviderState createState() => _ViewModelProviderState();
}

class _ViewModelProviderState extends State<ViewModelProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.viewModel.onDestroy();
    super.dispose();
  }
}
