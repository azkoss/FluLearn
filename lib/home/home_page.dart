import 'package:flutter/material.dart';
import 'package:flutter_app/common/application.dart';
import 'package:flutter_app/util/common_utils.dart';
import 'package:flutter_app/util/image_utils.dart';
import 'package:flutter_app/widget/exit_container.dart';

import 'home_drawer.dart';

///
/// 主页
///
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;
  var _tabIcons = [
    ["statistics_normal", "statistics_selected"],
    ["statistics_normal", "statistics_selected"],
    ["statistics_normal", "statistics_selected"],
    ["statistics_normal", "statistics_selected"],
    ["statistics_normal", "statistics_selected"],
  ];
  var _tabTexts = ['考试', '提问', '下载', '学习', '我的'];
  var _pageList;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    _pageList = [
      Column(
        children: <Widget>[
          RaisedButton(
            child: Text("简体中文"),
            onPressed: () {
              CommonUtils.changeLanguage(context, "zh_CN");
            },
          ),
          RaisedButton(
            child: Text("繁体中文"),
            onPressed: () {
              CommonUtils.changeLanguage(context, "zh_TW");
            },
          ),
          RaisedButton(
            child: Text("英语"),
            onPressed: () {
              CommonUtils.changeLanguage(context, "en_US");
            },
          ),
        ],
      ),
      Text("提问"),
      Text("下载"),
      Text("学习"),
      Text("我的"),
    ];
  }

  Widget _buildTabIcon(int index) {
    String name;
    if (index == _tabIndex) {
      name = _tabIcons[index][1];
    } else {
      name = _tabIcons[index][0];
    }
    String icon = "images/home/ic_$name.png";
    Application.logger.d("selected: $_tabIndex, index: $index, icon: $icon");
    return ImageUtils.fromAsset(icon);
  }

  Widget _buildTabText(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(
        _tabTexts[index],
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExitContainer(
      child: Scaffold(
        appBar: AppBar(title: Text("Flutter学习"), centerTitle: true),
        drawer: HomeDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: List.generate(
              _tabTexts.length,
                  (i) =>
                  BottomNavigationBarItem(
                    icon: _buildTabIcon(i),
                    title: _buildTabText(i),
                  )),
          type: BottomNavigationBarType.fixed,
          currentIndex: _tabIndex,
          elevation: 5.0,
          iconSize: 25.0,
          selectedFontSize: 15,
          unselectedFontSize: 15,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Color(0xFFBFBFBF),
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
        // 使用PageView的原因参看 https://zhuanlan.zhihu.com/p/58582876
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pageList,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _tabIndex = index;
    });
  }
}
