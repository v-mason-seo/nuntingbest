import 'package:flutter/material.dart';
import 'package:ntbest/data/models/daily_model.dart';
import 'package:ntbest/data/models/site_model.dart';
import 'package:ntbest/ui/widgets/error_page.dart';
import 'package:ntbest/ui/widgets/today_content_cell.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';


class DailyPostPage extends StatefulWidget {
  @override
  _DailyPostPageState createState() => _DailyPostPageState();
}


// 오늘, 주간
class _DailyPostPageState extends State<DailyPostPage> 
  with AutomaticKeepAliveClientMixin<DailyPostPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<SiteModel>(
      builder: (context, siteModel, _) {

        return BaseWidget<DailyPostModel>(
          key: ValueKey(siteModel.isChangedSites),
          model: DailyPostModel(exceptionSites: siteModel.exceptionSites),
          onModelReady: (model) => model.fetchPosts(),
          builder: (context, model, child) {
            //---------------------------
            // error
            //---------------------------
            if ( model.isError) {
              return ErrorPage(
                errorMessage: model.errorMessage,
                onPressed: () => model.fetchPosts(),
              );
            }

            return model.busy
              ? Center(child: CircularProgressIndicator(),)
              : RefreshIndicator(
                  onRefresh: () => model.refresh(),
                  child: _buildDailyPostItems(model),
              );
          },
        );
      }
    );    
  }


  ///
  /// 일간 게시글 리스트뷰
  ///
  Widget _buildDailyPostItems(DailyPostModel model) {
    return ListView.separated(
      key: PageStorageKey('daily_post_items_key'),
      separatorBuilder: (context, index) => Divider(indent: 5, endIndent: 5,),
      itemCount: model.getPostItemCount() == 0 ? 0 : model.getPostItemCount(),
      itemBuilder: (context, index) {

        return TodayContentCell(
          content: model.getPostItem(index),
          onClicked: () => model.readContent(index),
        );
      },
    );
  }
}