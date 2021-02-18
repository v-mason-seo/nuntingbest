import 'dart:collection';

import 'package:get_it/get_it.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/data/entities/top_post.dart';
import 'package:ntbest/data/models/base_model.dart';
import 'package:ntbest/util/common_utils.dart';

class TopPostModel extends BaseModel {

  final Api _api = GetIt.instance<Api>();
  final MyDatabase _myDatabase = GetIt.I<MyDatabase>();
  // 제외 사이트(site.visible == false)
  List<Site> exceptionSites;

  LinkedHashSet set1 = new LinkedHashSet();
  String _prevPid;


  TopPostModel({
    this.exceptionSites
  }) {
    if ( exceptionSites == null) {
      exceptionSites = [];
    }
  }
  

  ///
  /// 데이터 불러오기
  ///
  Future fetchPosts() async {
    
    try {
      setBusy(true);
      List<ReadContentData> readList = await _myDatabase.getAllReadContent(300);
      TopPost post = await _api.getTopPost("");
      //if ( posts == null ) posts = [];
      _prevPid = post.prevPid;
      //posts.add(post);

      //제외 사이트 제거
      List<TopPostItem> newTopPostList = removeExceptionSites(post.items, exceptionSites);

      // 읽은글 처리
      for ( TopPostItem data in newTopPostList) {
        var kk = readList?.firstWhere((d) => d.url == data.url, orElse: () => null);
        if ( kk != null) {
          data.read = true;
        }
      }

      newTopPostList?.shuffle();      
      set1.add(post.prevPid);
      set1.addAll(newTopPostList);

      setBusy(false);
    } catch(e) {
      setError(true, "실시간 글 불러오기 오류");
    }   
  }

  Future deletedContent(String url) async {
    await _api.deletedContent(url);
  }


  ///
  /// 다음 데이터 불러오기
  ///
  Future fetchMorePosts() async {

    try {
      List<ReadContentData> readList = await _myDatabase.getAllReadContent(300);
      TopPost post = await _api.getTopPost(_prevPid);
      _prevPid = post.prevPid;

      //제외 사이트 제거      
      List<TopPostItem> newTopPostList = removeExceptionSites(post.items, exceptionSites);

      // 읽은글 처리
      for ( TopPostItem data in newTopPostList) {
        var kk = readList?.firstWhere((d) => d.url == data.url, orElse: () => null);
        if ( kk != null) {
          data.read = true;
        }
      }

      newTopPostList?.shuffle();      
      set1.add(post.prevPid);
      set1.addAll(newTopPostList);

      notifyListeners();
    } catch(e) {
      setError(true, "실시간 글 불러오기 오류");
    }    
  }
  

  Future refresh() async {
    try {
      List<ReadContentData> readList = await _myDatabase.getAllReadContent(300);
      set1?.clear();
      _prevPid = "";

      notifyListeners();

      TopPost post = await _api.getTopPost("");
      _prevPid = post.prevPid;

      post.items.shuffle();

      //제외 사이트 제거
      List<TopPostItem> newTopPostList = removeExceptionSites(post.items, exceptionSites);

      // 읽은글 처리
      for ( TopPostItem data in newTopPostList) {
        var kk = readList?.firstWhere((d) => d.url == data.url, orElse: () => null);
        if ( kk != null) {
          data.read = true;
        }
      }

      newTopPostList?.shuffle();      
      set1.add(post.prevPid);
      set1.addAll(newTopPostList);

      notifyListeners();
    } catch(e) {
      setError(true, "실시간 글 새로고침 오류");
    }
    
    
    return Future;
  }


  ///
  /// 제외 사이트 제거
  ///
  List<TopPostItem> removeExceptionSites(List<TopPostItem> srcList, List<Site> siteList) {

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

  Object getPostItem(int index) {
    return set1.elementAt(index);
  }

  String getTitle(int index) {
    return set1.elementAt(index).title;
  }


  void readContent(int index) {
    set1.elementAt(index).read = true;
    notifyListeners();
  }
  

}