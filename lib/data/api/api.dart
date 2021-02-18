import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:ntbest/data/entities/best_post.dart';
import 'package:ntbest/data/entities/photo.dart';
import 'package:ntbest/data/entities/post.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/data/entities/top_post.dart';

class Api {
  
  static const endpoint_test = 'https://jsonplaceholder.typicode.com';
  static const endpoint = 'http://api.nunting.kr:4000';

  var client = new http.Client();
  
  //https://jsonplaceholder.typicode.com/albums/1/photos

  ///
  /// 포토 리스트 정보를 가져온다. ( 테스트용 )
  ///
  Future<List<Photo>> getPhotos(int id) async {
    var photos = List<Photo>();

    final response = await client.get('$endpoint_test/albums/$id/photos');

    var parsed = json.decode(response.body) as List<dynamic>;

    for (var photo in parsed) {
      photos.add(Photo.fromJson(photo));
    }

    return photos;
  }


  ///
  /// 사이트 목록을 가져온다.
  ///
  Future<List<Site>> getSites() async {
    var sites = List<Site>();

    final response = await client.get('$endpoint/best/sites');

    var parsed = json.decode(response.body) as List<dynamic>;

    for(var site in parsed) {
      sites.add(Site.fromJson(site));
    }

    return sites;
  }


  ///
  /// 사이트 목록과 게시판 정보를 가져온다.
  ///
  Future<List<Site>> getSitesWithBoards() async {

    var sites = List<Site>();
    final response = await client.get('$endpoint/best/sites2');
    var parsed = json.decode(response.body) as List<dynamic>;

    for(var site in parsed) {
      sites.add(Site.fromJson(site));
    }

    return sites;
  }


  ///
  /// 사이트의 게시글을 가져온다.
  ///
  Future<Post> getPost(String siteId, String boardId, String pid) async {

    String url = "";
    url = pid.isEmpty
            ? '$endpoint/best/$siteId/board/$boardId'
            : '$endpoint/best/$siteId/board/$boardId?q=$pid';

    final response = await client.get(url);

    var parsed = json.decode(response.body);

    return Post.fromJson(parsed);
  }


  ///
  /// 최근 베스트 게시글 가져오기
  ///
  Future<TopPost> getTopPost(String pid) async {

    String url = pid.isEmpty
            ? '$endpoint/top'
            : '$endpoint/top?pid=$pid';
    final response = await client.get(url);

    var parsed = json.decode(response.body);

    return TopPost.fromJson(parsed);
  }


  ///
  /// 일간 베스트 게시글 가져오기
  ///
  Future<List<BestPost>> getDailyPost() async {

    var posts = List<BestPost>();
    final response = await client.get('$endpoint/tot');
    var parsed = json.decode(response.body) as List<dynamic>;

    for(var post in parsed) {
      posts.add(BestPost.fromJson(post));
    }

    return posts;
  }


  ///
  /// 주간 베스트 게시글 가져오기
  ///
  Future<List<BestPost>> getWeeklyPost() async {

    var posts = List<BestPost>();
    final response = await client.get('$endpoint/tot/week');
    var parsed = json.decode(response.body) as List<dynamic>;

    for(var post in parsed) {
      posts.add(BestPost.fromJson(post));
    }
    
    return posts;
  }


  ///
  ///
  ///
  Future<Response> readContent(String sid, String url, String title) async {

    var body = json.encode({
        'sid': sid,
        'url': url,
        'title': title
      });
    String serverUrl = '$endpoint/log';
    return await client.post(
      serverUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: body
    );
  }

  Future readTopOfTopContent(String sid, String url, String title) async {
    var body = json.encode({
        'sid': sid,
        'url': url,
        'title': title
      });
    String serverUrl = '$endpoint/tot';
    await client.post(
      serverUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: body
    );
  }


  Future<bool> deletedContent(String url) async {
    var body = json.encode({
        'url': url,
      });
    String serverUrl = '$endpoint/tot/deleted';
    final response = await client.put(
      serverUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: body
    );

    if (response.statusCode == 200){
      return true;
    }
    return false;
  }


  ///
  /// 푸시토큰 등록
  ///
  Future<http.Response> onRegisterPush(String deviceId, String pushType, String pushToken) async {
    var body = json.encode({
      'device_id': deviceId,
      'push_type': pushType,
      'push_token': pushToken
    });

    String serverUrl = '$endpoint/users/push';
    return await client.post(
      serverUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: body
    );
  }

  ///
  /// 푸시토큰 삭제
  ///
  Future onUnregisterPush(String deviceId, String pushType) async {
    var body = json.encode({
      'device_id': deviceId,
      'push_type': pushType,
    });

    String serverUrl = '$endpoint/users/push';

    await client.send(
      http.Request(
        'DELETE', 
        Uri.parse(serverUrl))
          ..headers['content-type'] = 'application/json'
          ..body = body
    );
  }
}