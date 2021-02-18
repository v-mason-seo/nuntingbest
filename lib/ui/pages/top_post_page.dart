import 'package:get_it/get_it.dart';
import 'package:ntbest/data/Ad/ad_manager.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/entities/content_parameter.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/data/models/site_model.dart';
import 'package:ntbest/data/models/app_model.dart';
import 'package:ntbest/data/service_locator/service_locator.dart';
import 'package:ntbest/ui/widgets/error_page.dart';
import 'package:ntbest/ui/widgets/site_logo_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:ntbest/data/constants/app_contstants.dart';
import 'package:ntbest/data/entities/top_post.dart';
import 'package:ntbest/data/models/top_post_model.dart';
import 'package:ntbest/util/date_utils.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

///
/// 실시간 페이지
///
class TopPostPage extends StatefulWidget {
  TopPostPage({Key key}) : super(key: key);

  @override
  _TopPostPageState createState() => _TopPostPageState();
}

class _TopPostPageState extends State<TopPostPage>
    with AutomaticKeepAliveClientMixin<TopPostPage> {
  int prevLength;

  @override
  bool wantKeepAlive = true;

  // DateTime calledTime = DateTime.now();
  // bool get wantKeepAlive {

  //   if (calledTime == null) {
  //     calledTime = DateTime.now();
  //     return false;
  //   }

  //   Duration diff =DateTime.now().difference(calledTime);

  //   if ( diff.inMinutes > 60 ){
  //     calledTime = DateTime.now();
  //     return false;
  //   }

  //   return true;
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<SiteModel>(
      builder: (context, siteModel, _) {
        return BaseWidget<TopPostModel>(
          key: ValueKey(siteModel.isChangedSites),
          model: TopPostModel(exceptionSites: siteModel.exceptionSites),
          onModelReady: (model) => model.fetchPosts(),
          builder: (context, model, child) {
            //---------------------------
            // error
            //---------------------------
            if (model.isError) {
              return ErrorPage(
                errorMessage: model.errorMessage,
                onPressed: () => model.fetchPosts(),
              );
            }
            //---------------------------
            // loadiong
            //---------------------------
            if (model.busy)
              return Center(
                child: CircularProgressIndicator(),
              );
            //---------------------------
            // main page
            //---------------------------
            return RefreshIndicator(
              onRefresh: () => model.refresh(),
              child: _buildTopPostListView(),
            );
          },
        );
      },
    );
  }

  ///
  /// TopPost 리스트뷰
  ///
  Widget _buildTopPostListView() {
    return Consumer<TopPostModel>(builder: (context, model, _) {
      return ListView.separated(
        key: PageStorageKey('top-post-list-view'),
        separatorBuilder: (context, index) => Divider(
          indent: 5,
          endIndent: 5,
        ),
        itemCount:
            model.getPostItemCount() == 0 ? 0 : model.getPostItemCount() + 1,
        itemBuilder: (context, index) {
          if (index == model.getPostItemCount()) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12.0),
                    primary: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: Text('다음 게시글 불러오기'),
                onPressed: () => model.fetchMorePosts(),
              ),
            );
          }

          var item = model.getPostItem(index);

          // 업데이트 시간
          if (item is String) {
            var strDate = DateUtils.convertDateFromyyyymmddhh(item);
            return ListTile(
              title: Text(timeago.format(strDate, locale: "ko")),
            );
          }

          // 실시간 인기글
          TopPostItem postItem = item as TopPostItem;
          return topPostListTile(postItem, model, index);
        },
      );
    });
  }

  ///
  /// 실시간 게시글 ListTile
  ///
  ListTile topPostListTile(
      TopPostItem postItem, TopPostModel model, int index) {
    return ListTile(
      onTap: () {
        Site site = Provider.of<SiteModel>(context, listen: false)
            .findItem(postItem.sid);
        ContentParam param = ContentParam(
          sid: postItem.sid,
          sname: site != null ? site.nm : "",
          url: postItem.url,
          title: postItem.title,
        );
        _handleTap(param);
        model.readContent(index);
      },
      leading: SiteLogo(
        url: postItem.getThumbnailUrl(),
      ),
      title: Text(
        model.getTitle(index),
        style: postItem.read
            ? TextStyle(color: Theme.of(context).textTheme.caption.color)
            : null,
      ),
    );
  }

  void _handleTap(ContentParam param) async {
    try {
      MyDatabase _dbApi = GetIt.I<MyDatabase>();
      _dbApi.insertReadContent(ReadContentData(
          url: param.url, sid: param.sid, dueDate: DateTime.now()));
      param.isBookmark =
          await _dbApi.getBookmarkContent(param.url) != null ? true : false;
    } catch (e) {
      param.isBookmark = false;
    }

    await Navigator.pushNamed(context, RoutePaths.Content, arguments: param);
    bool canShowFullAd = Provider.of<AppModel>(context).canShowAds();
    if (canShowFullAd) {
      serviceLocator.get<AdManager>().showFullAd();
    }
  }
}
