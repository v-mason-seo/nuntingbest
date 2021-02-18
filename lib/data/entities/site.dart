import 'package:ntbest/util/common_utils.dart';
import 'package:quiver/core.dart';

import 'board.dart';

class Site {
  final String id;
  final String nm;
  final String type;
  final List<Board> boards;
  int sortSeq;
  bool visible;

  Site({
    this.id,
    this.nm,
    this.type,
    this.boards,
    this.sortSeq = 999,
    this.visible = true,
  });

  ///
    /// 사이트 섬네일 이미지
    ///
    String getThumbnailUrl() {
      if ( CommonUtils.isEmpty(id)) {
        return "";
      }

      return 'http://image.nunting.kr/$id.png';
    }

  factory Site.fromJson(Map<String, dynamic> json) {
    var list = json['boards'] as List;
    return Site(
      id : json['id'],
      nm : json['nm'],
      type: json['type'],
      boards: list != null 
        ? list.map((i) => Board.fromJson(i)).toList() 
        : null,
      sortSeq: json['sort_seq']??999,
      visible: json['visible']??true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nm'] = this.nm;
    data['type'] = this.type;
    // data['id'] = this.id;
    data['sort_seq'] = this.sortSeq;
    data['visible'] = this.visible;

    return data;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
    other is Site &&
    runtimeType == other.runtimeType &&
    id == other.id &&
    visible == other.visible
    ;
  }

  @override
  int get hashCode => hash2(id.hashCode, visible.hashCode);

}