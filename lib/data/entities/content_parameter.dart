import 'package:ntbest/util/common_utils.dart';

class ContentParam {
  String sid;
  String sname;
  String url;
  String title;
  bool isDelete;
  PostType postType;
  bool isBookmark;

  ContentParam({
    this.sid,
    this.sname,
    this.url,
    this.title,
    this.isDelete = false,
    this.postType = PostType.general,
    this.isBookmark = false,
  });

  String getThumbnailUrl() {
    if ( CommonUtils.isEmpty(sid)) {
      return "";
    }

    return 'http://image.nunting.kr/$sid.png';
  }
}

enum PostType {general, topOfTop}