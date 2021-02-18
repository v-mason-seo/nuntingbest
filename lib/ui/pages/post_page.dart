import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ntbest/data/constants/app_contstants.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/entities/board.dart';
import 'package:ntbest/data/entities/content_parameter.dart';
import 'package:ntbest/data/entities/post.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/data/models/post_model.dart';
import 'package:ntbest/ui/widgets/site_logo_widget.dart';
import 'package:ntbest/util/date_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base_widget.dart';


// 최신, 오늘, 주간
class PostPage extends StatelessWidget {

  final Site _site;
  final Board _board;


  PostPage({@required Site site, @required Board board}) 
    : _site = site, 
      _board = board;

  @override
  Widget build(BuildContext context) {

    return BaseWidget<PostModel>(
      model: PostModel(
        site: _site, 
        board: _board
      ),
      onModelReady: (model) => model.fetchPosts(/*_site.id, _board.bid, ""*/),
      builder: (context, model, child) {

        if ( model.isError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.error_outline, color: Colors.red, size: 48.0,),
                SizedBox(height: 64,),
                Text(model.errorMessage, style: TextStyle(color: Colors.red.shade400),),
                SizedBox(height: 32,),
                RaisedButton(
                  child: Text('다시시도'),
                  onPressed: () {
                    model.fetchPosts();
                  },
                )
              ],
            ),
          );
        }

        return model.busy
          ? Center(child: CircularProgressIndicator(),)
          : ListView.separated(
              key: PageStorageKey('site_post_itmes.key'),
              separatorBuilder: (context, index) => Divider(indent: 5, endIndent: 5,),
              itemCount: model.getPostItemCount2() == 0 ? 0 : model.getPostItemCount2() + 1,
              itemBuilder: (context, index) {
                if ( index == model.getPostItemCount2() ) {
                  return RaisedButton(
                    color: Colors.teal,
                    child: Text('다음 게시글 불러오기'),
                    onPressed: () {
                      model.fetchMorePosts();
                    },
                  );
                }

                var postItem = model.getPostItem2(index);

                if ( postItem is String) {
                  var strDate = DateUtils.convertDateFromyyyymmddhh(postItem);
                  return ListTile(
                    //title: Text(postItem.toString()),
                    title: Text(timeago.format(strDate, locale: "ko")),
                  );
                }

                var param = ContentParam(
                  sid: _site.id,
                  sname: _site.nm,
                  url: (postItem as PostItem).url,
                  title: (postItem as PostItem).title,
                );

                return ListTile(
                  onTap: () { 
                    model.readContent(index);
                    _handleTap(context, param); 
                  },
                  leading: SiteLogo(url: _site.getThumbnailUrl(), size: 35,),
                  title: Text(
                     (postItem as PostItem).title,
                     style: (postItem as PostItem).read ? TextStyle(color: Theme.of(context).textTheme.caption.color) : null,
                  ),
                );
              },
          );
      },
    );
  }

  void _handleTap(BuildContext context, ContentParam param) async {
    //WebviewType type = Provider.of<AppModel>(context, listen: false).webviewType;
    //print('url: ${param.url}, sid: ${param.sid}, dueDate: ${DateTime.now()}');

    try {

      // 북마크된 글인지 확인
      MyDatabase _dbApi = GetIt.I<MyDatabase>();
      _dbApi.insertReadContent(
        ReadContentData(
          url: param.url, 
          sid: param.sid, 
          dueDate: DateTime.now()
        )
      );

      param.isBookmark 
        = await GetIt.I<MyDatabase>().getBookmarkContent(param.url) != null ? true : false;
    } catch (e) {
      param.isBookmark = false;
    }

    // Ads().hideBanner();
    await Navigator.pushNamed(context, RoutePaths.Content, arguments: param);
    // Ads().showBanner();
  }
}