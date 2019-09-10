import 'dart:async';
import 'dart:core';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/util/image_loader.dart';
import 'package:flutter_app/util/logger.dart';
import 'package:flutter_app/util/route_navigator.dart';

///
/// 闪屏
///
class SplashScreen extends StatefulWidget {
  final int seconds;
  final dynamic navigateTo;
  final Color backgroundColor;
  final String skipButtonText;
  final String imageUrl;
  final String imagePlaceholder;
  final Text bottomText;
  final bool Function(int value) onTickEvent;

  SplashScreen({
    @required this.seconds,
    this.navigateTo,
    this.backgroundColor = Colors.transparent,
    this.skipButtonText,
    this.imageUrl,
    this.imagePlaceholder = '',
    this.bottomText = const Text(''),
    this.onTickEvent,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;
  int _seconds;
  double _statusBarHeight;

  @override
  void initState() {
    super.initState();
    _seconds = widget.seconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      L.d('timer tick: $_seconds');
      if (widget.onTickEvent(_seconds)) {
        L.d('倒计时拦截');
        _goToNext();
        return;
      }
      if (_seconds == 0) {
        _goToNext();
        return;
      }
      setState(() {
        _seconds--;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    _statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        color: widget.backgroundColor,
        child: Column(
          children: <Widget>[
            _buildBody(),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      flex: 1,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImageLoader.fromNetwork(
            widget.imageUrl,
            fit: BoxFit.fitWidth,
            placeholder: widget.imagePlaceholder,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: _statusBarHeight, right: 20),
              child: _buildSkipButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    if (TextUtil.isEmpty(widget.skipButtonText)) {
      return SizedBox();
    }
    return Opacity(
      opacity: 0.7,
      child: FlatButton(
        textColor: Colors.white,
        color: Colors.grey[700],
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Text(
          widget.skipButtonText + (_seconds + 1).toString() + 'S',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          _goToNext();
        },
      ),
    );
  }

  Widget _buildBottom() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
        ),
        widget.bottomText,
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
        ),
      ],
    );
  }

  void _goToNext() {
    _cancelTimer();
    if (widget.navigateTo is String) {
      // It's fairly safe to assume this is using the in-built material
      // named route component
      RouteNavigator.goPath(context, widget.navigateTo);
    } else if (widget.navigateTo is Widget) {
      RouteNavigator.goPage(context, widget.navigateTo);
    } else {
      throw new ArgumentError('navigateTo must either be a String or Widget');
    }
  }

  void _cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
      L.d('timer canceled');
    }
  }
}
