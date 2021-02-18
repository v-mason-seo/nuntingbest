import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/colors.dart';

enum Themes { light, dark, black, system }
enum WebviewType { webview_plugin, inappbroser }

class AppModel with ChangeNotifier {

  DateTime baseAdDate = DateTime.now();
  int adYear = 0;
  int adMonth = 0;
  int adDay = 0;
  int clickCount = 0;
  String jsonExceptionSites;
  bool isEqualExceptionSites = false;

  bool canShowAds() {
    DateTime now = DateTime.now();
    if ( baseAdDate.year == now.year && baseAdDate.month == now.month && baseAdDate.day == now.day) {
      if ( clickCount > 12) {
        clickCount = -1;
        return true;
      } else if ( clickCount != -1) {
        clickCount = clickCount + 1;
      }
    } else {
      adYear = now.year;
      adMonth = now.month;
      adDay = now.day;
      clickCount = 0;
    }
    return false;
  }

  // Light, dark & OLED themes
  static final List<ThemeData> _themes = [
    ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      accentColor: lightAccentColor,
    ),
    ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      accentColor: darkAccentColor,
      canvasColor: darkCanvasColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      dividerColor: darkDividerColor,
      dialogBackgroundColor: darkCardColor,
    ),
    ThemeData(
      brightness: Brightness.dark,
      primaryColor: blackPrimaryColor,
      accentColor: blackAccentColor,
      canvasColor: blackBackgroundColor,
      scaffoldBackgroundColor: blackBackgroundColor,
      cardColor: blackCardColor,
      dividerColor: blackDividerColor,
      dialogBackgroundColor: darkCardColor,
    )
  ];


  Themes _theme = Themes.dark;
  ThemeData _themeData = _themes[1];
  bool _showAds = true;

  get showAds => _showAds;

  // set showAds(bool isShow) {
  //   _showAds = isShow;
  //   notifyListeners();
  // }

  // invisibleAds() {
  //   _showAds = false;
  //   notifyListeners();
  // }

  // visibleAds() {
  //   _showAds = true;
  //   notifyListeners();
  // }

  get theme => _theme;

  set theme(Themes theme) {
    if (theme != null) {
      _theme = theme;
      themeData = theme;
      notifyListeners();
    }
  }

  get themeData => _themeData;

  set themeData(Themes theme) {
    if (theme != Themes.system) _themeData = _themes[theme.index];
    notifyListeners();
  }


  WebviewType _webviewType = WebviewType.webview_plugin;

  get webviewType => _webviewType;

  set webviewType(WebviewType type) {
    if ( type != null) {
      _webviewType = type;
      notifyListeners();
    }
  }

//   List<Site> exceptionSites;
//   // Function eq = const ListEquality().equals;

// Future setExceptionSites(List<Site> siteList) async {

//   if ( CommonUtils.isNotEmpty(siteList)) {

//     List<Site> unselectedSiteList = [];

//     for( var site in siteList) {
//     if ( site.visible == false) {
//       //exceptionSites.add(site);
//       unselectedSiteList.add(site);
//       print("site : ${site.nm}, visible: ${site.visible}");
//     }
//   }

//   //Function eq = const ListEquality().equals;
//   Function deepEq = const DeepCollectionEquality().equals;
//   bool isEqual = deepEq(unselectedSiteList, exceptionSites);
//   print("---------------------------");
//   print("[isEqual] $isEqual");
//   print("---------------------------");


//   // if ( CommonUtils.isEmpty(exceptionSites)) {
//   //   exceptionSites = [];
//   // } else {
//   //   exceptionSites.clear();
//   // }

//   exceptionSites = unselectedSiteList;
      

//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       String encodeSites = json.encode(exceptionSites);
//       jsonExceptionSites = encodeSites;
//       prefs.setString("settings.exception_sites", encodeSites);

//       notifyListeners();
//     }

//   }

  /// Returns the app's theme depending on the device's settings
  ThemeData requestTheme(Brightness fallback) => theme == Themes.system
      ? fallback == Brightness.dark ? _themes[1] : _themes[0]
      : themeData;

  /// Method that initializes the [AppModel] itself.
  Future init() async {
    //print('AppModel-init(1)');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 테마
    try {
      theme = Themes.values[prefs.getInt('theme')];
    } catch (e) {
      prefs.setInt('theme', 1);
    }

    // 웹뷰 종류
    try {
      webviewType = WebviewType.values[prefs.getInt('webview_type')];
    } catch (e) {
      prefs.setInt('webview_type', 0);
    }

    notifyListeners();
  }
}