import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/constants/app_contstants.dart';
import 'package:ntbest/data/models/app_model.dart';
import 'package:ntbest/ui/pages/top_post_page.dart';
import 'package:ntbest/ui/pages/weekly_post_page.dart';
import 'package:ntbest/ui/screens/my_site_list_screen.dart';
import 'package:ntbest/util/common_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'daily_post_page.dart';
import 'site_page.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  PageController _pageController;
  int _currentIndex = 0;

  final pages = [
    TopPostPage(),
    SitePage(),
    DailyPostPage(),
    WeeklyPostPage(),
  ];

  @override
  void initState() {
    super.initState();
    initPush();
    _pageController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          // icon: Icon(MaterialCommunityIcons.getIconData("bookmark-outline")),
          icon: Icon(MdiIcons.bookmarkCheck),
          onPressed: () =>
              Navigator.pushNamed(context, RoutePaths.BookmarkPostList),
        ),
        title: Text(
          '눈팅베스트',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          //-----------------------------
          // IconButton(icon: Icon(Feather.getIconData("search")), onPressed: () {
          //   serviceLocator.get<AdManager>().showFullAd();
          // },),
          //-----------------------------
          IconButton(
            // icon: Icon(Feather.getIconData("settings")),
            icon: Icon(MdiIcons.cogOutline),
            onPressed: () => Navigator.pushNamed(context, RoutePaths.Settings),
          ),
          //-----------------------------
        ],
      ),
      //------------------------------------------
      //사이트 페이지에서만 보임
      floatingActionButton:
          _currentIndex == 1 ? buildFloationActionButton() : null,
      //------------------------------------------
      body: buildPageView(),
      //------------------------------------------
      bottomNavigationBar: buildBottomNavigation(),
      //------------------------------------------
    );
  }

  ///
  /// [body] PageView - 실시간, 사이트, 오늘, 주간 페이지
  ///
  Widget buildPageView() {
    return PageView.builder(
        itemCount: pages.length,
        controller: _pageController,
        pageSnapping: true,
        onPageChanged: (position) {
          setState(() {
            _currentIndex = position;
          });
        },
        itemBuilder: (context, position) {
          return pages[position];
        });
  }

  ///
  /// [BottomNavigation] 하단 메뉴
  ///
  Widget buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        _currentIndex = index;
        _pageController.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      selectedItemColor:
          Provider.of<AppModel>(context, listen: false).theme == Themes.light
              ? Colors.teal
              : null,
      currentIndex: _currentIndex,
      items: <BottomNavigationBarItem>[
        //----------------------------------------
        BottomNavigationBarItem(label: "실시간", icon: Icon(MdiIcons.bomb)),
        //----------------------------------------
        BottomNavigationBarItem(
            label: "사이트", icon: Icon(MdiIcons.fileTreeOutline)),
        //----------------------------------------
        BottomNavigationBarItem(label: "오늘", icon: Icon(MdiIcons.podiumGold)),
        //----------------------------------------
        BottomNavigationBarItem(label: "주간", icon: Icon(MdiIcons.podium)),
        //----------------------------------------
      ],
    );
  }

  ///
  /// FloationActionButton - 사이트 설정
  /// 사이트 페이지 일때만 보임
  ///
  Widget buildFloationActionButton() {
    return FloatingActionButton.extended(
        icon: Icon(Icons.edit),
        label: Text("편집"),
        onPressed: () async {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (context) => MySiteListScreen());
          await Navigator.push(context, materialPageRoute);
        });
  }

  //------------------------------------------------------

  void initPush() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // 앱 실행중일때는 푸시가 와도 안보여준다.
        // --> 나중에 추가할 예정.
        // print("----------------------");
        // String title = "";
        // String subtitle = "";
        // try {
        //   title = message['data']['title'];
        // } catch (e) {
        //   print("1. error : $e");
        //   title = "눈팅베스트 알림";
        // }

        // try {
        //   subtitle = message['data']['message'];
        // } catch (e) {
        //   print("1. error : $e");
        //   subtitle = "-";
        // }

        // try {
        //   showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //               content: ListTile(
        //               title: Text(title??"눈팅베스트 알림"),
        //               subtitle: Text(subtitle??"-"),
        //               ),
        //               actions: <Widget>[
        //               FlatButton(
        //                   child: Text('Ok'),
        //                   onPressed: () => Navigator.of(context).pop(),
        //               ),
        //           ],
        //       ),
        //   );
        // } catch(e) {
        //   print("2. error : $e");
        // }
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");
      },
    );

    if (Platform.isIOS) {
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {});

      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
    }

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      //print('============(푸시토근 받음)============');
      //print('token =========> $token');
      //print('============(푸시토근 받음)============');

      //----------------------------------------------------
      // 푸시토큰 등록
      SharedPreferences.getInstance().then((pref) {
        String pushToken = pref.getString("push_token");
        String deviceId = pref.getString("device_id");

        if (CommonUtils.isEmpty(pushToken) && pushToken != token) {
          pref.setString("push_token", token);

          Api api = GetIt.instance<Api>();

          if (CommonUtils.isEmpty(deviceId)) {
            _getId().then((did) {
              pref.setString("device_id", did);
              api.onRegisterPush(did, "gcm", token);
            });
          } else {
            api.onRegisterPush(deviceId, "gcm", token);
          }
        }
      });
      //----------------------------------------------------
    });
  }

  ///
  /// 디바이스 아이디 가져오기
  ///
  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
