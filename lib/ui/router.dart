import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntbest/data/constants/app_contstants.dart';
import 'package:ntbest/data/entities/content_parameter.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/ui/screens/bookmark_post_list.dart';
import 'package:ntbest/ui/screens/my_site_list_screen.dart';
import 'package:ntbest/ui/screens/post_list_screen.dart';
import 'package:ntbest/ui/screens/settings_screen.dart';
import 'screens/content_screen.dart';

class AppRouter {
  static Route<dynamic> getnerateRoute(RouteSettings settings) {
    switch(settings.name) {
      //--------------------------------------
      case RoutePaths.PostList:
        var site = settings.arguments as Site;
        return CupertinoPageRoute(builder: (_) => PostListScreen(site: site,));
      //--------------------------------------
      case RoutePaths.BookmarkPostList:
        return CupertinoPageRoute(builder: (_) => BookmarkPostListScreen());
      //--------------------------------------
      case RoutePaths.Content:
        var contentParam = settings.arguments as ContentParam;
        return CupertinoPageRoute(
          //fullscreenDialog: false,
          builder: (context) {
            return ContentScreen(param: contentParam);
          } 
        );
      //--------------------------------------
      case RoutePaths.Settings:
        return CupertinoPageRoute(builder: (_) => SettingsScreen());
      //--------------------------------------
      case RoutePaths.MySiteList:
        return CupertinoPageRoute(builder: (_) => MySiteListScreen());
      //--------------------------------------
      default:  
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('${settings.name} 화면이 정의되지 않았습니다.'),
            ),
          )
        );
      //--------------------------------------
    }
  }
}