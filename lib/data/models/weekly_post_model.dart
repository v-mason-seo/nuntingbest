import 'dart:collection';

import 'package:get_it/get_it.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/entities/best_post.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/data/models/base_model.dart';
import 'package:ntbest/util/common_utils.dart';


class WeeklyPostModel extends BaseModel {

  final Api _api = GetIt.instance<Api>();
  final MyDatabase _myDatabase = GetIt.I<MyDatabase>();
  LinkedHashSet set1 = new LinkedHashSet();
 

  ///
  /// 새로고침
  ///
  Future refresh(List<Site> excetionSites) async {

    try {

      List<ReadContentData> readList = await _myDatabase.getAllReadContent(300);

    
      set1?.clear();

      List<BestPost> posts = await _api.getWeeklyPost();
      
      if ( posts == null ) posts = [];

      //제외 사이트 제거
      List<BestPost> newPostList = removeExceptionSites(posts, excetionSites);

      // 읽은글 처리
      for ( BestPost data in newPostList) {
        var kk = readList?.firstWhere((d) => d.url == data.url, orElse: () => null);
        if ( kk != null) {
          data.read = true;
        }
      }

      set1.addAll(newPostList);

      notifyListeners();

    } catch(e) {
      setError(true, "주간베스트 글 새로고침 오류");
    }
  }


  ///
  /// 데이터 불러오기
  ///
  Future fetchPosts(List<Site> excetionSites) async {
    
    try {
      setBusy(true);

      List<ReadContentData> readList = await _myDatabase.getAllReadContent(300);
      List<BestPost> posts = await _api.getWeeklyPost();
      if ( posts == null ) posts = [];

      //제외 사이트 제거
      List<BestPost> newPostList = removeExceptionSites(posts, excetionSites);

      // 읽은글 처리
      for ( BestPost data in newPostList) {
        var kk = readList?.firstWhere((d) => d.url == data.url, orElse: () => null);
        if ( kk != null) {
          data.read = true;
        }
      }
      
      set1.clear();
      set1.addAll(newPostList);
      setBusy(false);
    } catch(e) {
      setError(true, "주간베스트 글 불러오기 오류");
    } 
  }


  ///
  /// 제외 사이트 제거
  ///
  List<BestPost> removeExceptionSites(List<BestPost> srcList, List<Site> siteList) {

    if ( CommonUtils.isNotEmpty(siteList)) {
      for(var site in siteList) {
        srcList.removeWhere((v) => v.sid == site.id);
      }
    }

    return srcList;
  }



  int getPostItemCount() {
    return set1.length;
  }

  BestPost getPostItem(int index) {
    return set1.elementAt(index);
  }

  void readContent(int index) {
    set1.elementAt(index).read = true;
    notifyListeners();
  }
}