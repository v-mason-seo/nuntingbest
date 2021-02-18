import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/entities/board.dart';
import 'package:ntbest/data/entities/post.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/data/models/base_model.dart';

class PostModel extends BaseModel {

  final Api _api = GetIt.instance<Api>();
  final MyDatabase _myDatabase = GetIt.I<MyDatabase>();
  
  final Site _site;
  final Board _board;
  LinkedHashSet set1 = new LinkedHashSet();
  String _prevPid;
  
  List<Post> posts;
  List<PostItem> postItems;

  PostModel({
    @required Site site,
    @required Board board,
  }) :_site = site,
      _board = board,
      posts = [], 
      postItems = [];

  @override
  void dispose() {
    super.dispose();
  }
  
  
  Future fetchPosts(/*String siteId, String bid, String pid*/) async {
    try {
      setBusy(true);
      List<ReadContentData> readList = await _myDatabase.getAllReadContent(300);
      Post post = await _api.getPost(_site.id, _board.bid, "");
      if ( posts == null ) posts = [];

      // 읽은글 처리
      for ( PostItem data in post.items) {
        var kk = readList?.firstWhere((d) => d.url == data.url, orElse: () => null);
        if ( kk != null) {
          data.read = true;
        }
      }

      _prevPid = post.prevPid;
      //print('current_prevPid : $_prevPid');
      posts.add(post);
      postItems.addAll(post.items);
      set1.add(post.prevPid);
      set1.addAll(post.items);
      setBusy(false);
    } catch(e) {
      setError(true, "데이터 불러오기 오류");
    }
  }


  Future fetchTopPosts() async {

  }

  Future fetchTodayPosts() async {

  }

  Future fetchWeeklyPosts() async {

  }

  Future deletedContent(String url) async {
    await _api.deletedContent(url);
  }

  Future fetchSitePosts() async {
    try {
      setBusy(true);
      List<ReadContentData> readList = await _myDatabase.getAllReadContent(300);
      Post post = await _api.getPost(_site.id, _board.bid, "");
      if ( posts == null ) posts = [];

      // 읽은글 처리
      for ( PostItem data in post.items) {
        var kk = readList?.firstWhere((d) => d.url == data.url, orElse: () => null);
        if ( kk != null) {
          data.read = true;
        }
      }

      _prevPid = post.prevPid;
      //print('current_prevPid : $_prevPid');
      posts.add(post);
      postItems.addAll(post.items);
      set1.add(post.prevPid);
      set1.addAll(post.items);
      setBusy(false);
    } catch(e) {
      setError(true, "데이터 불러오기 오류");
    }
  }



  Future fetchMorePosts() async {
    try {
      List<ReadContentData> readList = await _myDatabase.getAllReadContent(300);
      Post post = await _api.getPost(_site.id, _board.bid, _prevPid);
    
      if ( posts == null ) posts = [];
      
      // 읽은글 처리
      for ( PostItem data in post.items) {
        var kk = readList?.firstWhere((d) => d.url == data.url, orElse: () => null);
        if ( kk != null) {
          data.read = true;
        }
      }

      //todo - _prevId에 값을 넣어야함.
      _prevPid = post.prevPid;

      posts.add(post);
      postItems.addAll(post.items);
      set1.add(post.prevPid);
      set1.addAll(post.items);
      notifyListeners();
    } catch(e) {
      setError(true, "데이터 불러오기 오류");
    }
  }


  int get getItemCount => posts.length;

  Post getItem(int index) => posts.isNotEmpty ? posts[index] : null;

  String getSiteId() {
    return _site.id;
  }

  String getSiteName() {
    return _site.nm;
  }

  int getPostItemCount() {
    return postItems.length;
  }

  PostItem getPostItem(int index) {
    return postItems[index];
  }


  int getPostItemCount2() {
    return set1.length;
  }

  Object getPostItem2(int index) {
    return set1.elementAt(index);
  }

  String getTitle(int index) {
    return postItems[index].title;
  }

  String getTitle2(int index) {
    return set1.elementAt(index).title;
  }

  void readContent(int index) {
    //print('===== readContent ======');
    set1.elementAt(index).read = true;
    notifyListeners();
  }

}