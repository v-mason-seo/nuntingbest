import 'package:ntbest/util/common_utils.dart';

class BestPost {
  String sid;
  String url;
  String title;
  DateTime created;
  int readCount;
  int deleteCount;
  bool read;

  BestPost({
    this.sid,
    this.url,
    this.title,
    this.created,
    this.readCount,
    this.deleteCount,
    this.read = false,
  });


  ///
  /// 사이트 섬네일 이미지
  ///
  String getThumbnailUrl() {
    if ( CommonUtils.isEmpty(sid)) {
      return "";
    }

    return 'http://image.nunting.kr/$sid.png';
  }

  bool isDelete() {
    return ( deleteCount == null || deleteCount == 0 ) ? false : true;
  }

  factory BestPost.fromJson(Map<String, dynamic> json) {
    return BestPost(
      sid: json['sid'],
      url: json['url'],
      title: json['title'],
      created: json['created'] != null ? DateTime.parse(json['created']).toLocal() : null,
      readCount: json['read_count'],
      deleteCount: json['delete_count'],
    );
  }
}