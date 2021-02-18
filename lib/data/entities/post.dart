  import 'package:ntbest/util/common_utils.dart';

class Post {
    final String pid;
    final String prevPid;
    final List<PostItem> items;

    Post({
      this.pid,
      this.prevPid,
      this.items
    });

    factory Post.fromJson(Map<String, dynamic> json) {
      var list = json['items'] as List;
      return Post(
        pid: json['pid'],
        prevPid: json['prev_pid'],
        items: list != null 
          ? list.map((i) => PostItem.fromJson(i)).toList() 
          : null,
      );
    }
  }


  class PostItem {
    final String dt;
    final String bad;
    final String hit;
    final String uid;
    final String unm;
    final String url;
    final String good;
    final String rcnt;
    final String urlm;
    final String title;
    bool read;

    PostItem({
      this.dt,
      this.bad,
      this.hit,
      this.uid,
      this.unm,
      this.url,
      this.good,
      this.rcnt,
      this.urlm,
      this.title,
      this.read = false
    });


    ///
    /// 사이트 섬네일 이미지
    ///
    String getThumbnailUrl() {
      if ( CommonUtils.isEmpty(uid)) {
        return "";
      }

      return 'http://image.nunting.kr/$uid.png';
    }

    @override
    bool operator ==(Object other) => 
      identical(this, other) || 
      other is PostItem &&
      runtimeType == other.runtimeType &&
      url == other.url &&
      title == other.title;

    @override
    int get hashCode => title.hashCode^url.hashCode;

    factory PostItem.fromJson(Map<String, dynamic> json) {
      return PostItem(
        dt: json['dt'],
        bad: json['bad'],
        hit: json['hit'],
        uid: json['uid'],
        unm: json['unm'],
        url: json['url'],
        good: json['good'],
        rcnt: json['rcnt'],
        urlm: json['urlm'],
        title: json['title'],
      );
    }
  }