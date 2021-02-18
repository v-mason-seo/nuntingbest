  import 'package:ntbest/util/common_utils.dart';

class TopPost {
    final String pid;
    final String prevPid;
    final List<TopPostItem> items;

    TopPost({
      this.pid,
      this.prevPid,
      this.items
    });

    factory TopPost.fromJson(Map<String, dynamic> json) {
      var list = json['contents'] as List;
      return TopPost(
        pid: json['pid'],
        prevPid: json['prev_pid'],
        items: list != null 
          ? list.map((i) => TopPostItem.fromJson(i)).toList() 
          : null,
      );
    }
  }


  class TopPostItem {
    final String sid;
    final String url;
    final String title;
    bool read;

    TopPostItem({
      this.sid,
      this.url,
      this.title,
      this.read = false
    });

    String getThumbnailUrl() {
    if ( CommonUtils.isEmpty(sid)) {
      return "";
    }

    return 'http://image.nunting.kr/$sid.png';
  }

    @override
    bool operator ==(Object other) => 
      identical(this, other) || 
      other is TopPostItem &&
      runtimeType == other.runtimeType &&
      url == other.url &&
      title == other.title;

    @override
    int get hashCode => title.hashCode^url.hashCode;

    factory TopPostItem.fromJson(Map<String, dynamic> json) {
      return TopPostItem(
        sid: json['sid'],
        url: json['url'],
        title: json['title'],
      );
    }
  }