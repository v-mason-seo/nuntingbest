import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ntbest/data/Ad/ad_manager.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/models/app_model.dart';
import 'package:ntbest/data/service_locator/service_locator.dart';
import 'package:ntbest/ui/screens/report_screen.dart';
import 'package:provider/provider.dart';
import '../../data/constants/app_contstants.dart';
import '../../data/entities/best_post.dart';
import '../../data/entities/content_parameter.dart';
import 'site_logo_widget.dart';

class TodayContentCell extends StatefulWidget {
  final BestPost content;
  final Function() onClicked;

  TodayContentCell({
    Key key, 
    this.content, 
    this.onClicked
  }) : super(key: key);

  _TodayContentCellState createState() => _TodayContentCellState();
}


class _TodayContentCellState extends State<TodayContentCell> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //---------------------------------
      onTap: _handleTap,
      //---------------------------------
      leading: SiteLogo(
        url: widget.content.getThumbnailUrl(),
        size: 35,
      ),
      //---------------------------------
      title: widget.content.deleteCount > 0 
        ? Text("[신고 ${widget.content.deleteCount ?? 0}]" + widget.content.title , style: TextStyle(color: Colors.redAccent))
        : Text( 
            widget.content.title,
            style: widget.content.read ? TextStyle(color: Theme.of(context).textTheme.caption.color) : null,
          ),
      //---------------------------------
      trailing: buildReportButton(context),
      //---------------------------------
    );
  }


  ///
  /// 신고 버튼 위젯
  ///
  ButtonTheme buildReportButton(BuildContext context) {
    return ButtonTheme(
      minWidth: 48.0,
      child: FlatButton(
        child: Text(
          '신고',
          style: TextStyle(color: Colors.grey),
        ),
        onPressed: () async {
          Navigator.push(context, 
           MaterialPageRoute(
              fullscreenDialog: true,
            builder: (context) =>
              ReportScreen(content: widget.content)
            ));
        },
      ),
    );
  }


  void _handleTap() async {

    widget.onClicked();

    ContentParam param = ContentParam(
      sid: widget.content.sid,
      sname: "",
      url: widget.content.url,
      title: widget.content.title,
      isDelete: widget.content.isDelete()
    );    
   
    // 북마크된 글인지 확인
    try {
      param.isBookmark 
        = await GetIt.I<MyDatabase>().getBookmarkContent(param.url) != null 
            ? true 
            : false;
    } catch(e) {
      param.isBookmark = false;
    }
    
    await Navigator.pushNamed(context, RoutePaths.Content, arguments: param);
    bool canShowFullAd = Provider.of<AppModel>(context).canShowAds();
    if ( canShowFullAd ) {
      serviceLocator.get<AdManager>().showFullAd();
    }
  }  

  // Widget buildReportButton() {

  // }
}
