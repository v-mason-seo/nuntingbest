import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ntbest/data/Ad/ad_manager.dart';
import 'package:ntbest/data/constants/app_contstants.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/entities/content_parameter.dart';
import 'package:ntbest/data/models/app_model.dart';
import 'package:ntbest/data/service_locator/service_locator.dart';
import 'package:ntbest/ui/widgets/site_logo_widget.dart';
import 'package:ntbest/util/common_utils.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookmarkPostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('북마크'),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 50.0),
        child: StreamBuilder<List<BookmarkContentData>>(
          stream: GetIt.I<MyDatabase>().watchAllBookmarkContent(),
          builder: (context, snapshot) {

            if ( snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } 
            
            if ( snapshot.hasError) {
              return Center(
                child: Text('북마크 데이터 로드 오류!'),
              );
            }


            final _data = snapshot.data;

            if ( CommonUtils.isEmpty(_data)) {
              //return Center(child: CircularProgressIndicator());
              return Center(
                child: Text('등록된 북마크 게시글이 없습니다.'),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final _item = _data[index];
                return ListTile(
                  leading: SiteLogo(url: getThumbnailUrl(_item.sid), size: 35,),
                  title: Text(_item.title),
                  subtitle: Text(timeago.format(_item.dueDate ?? DateTime.now(), locale: "ko")),
                  onTap: () async {

                    ContentParam param = ContentParam(
                        sid: _item.sid,
                        sname: _item != null ? "_item.nm" : "",
                        url: _item.url,
                        title: '_item.title',
                    );
                    
                    await Navigator.pushNamed(context, RoutePaths.Content, arguments: param);
                    bool canShowFullAd = Provider.of<AppModel>(context).canShowAds();
                    if ( canShowFullAd ) {
                      serviceLocator.get<AdManager>().showFullAd();
                    }

                  } ,
                );
              },
            );
          },
        ),
      ),
    );
  }


  String getThumbnailUrl(String id) {
      if ( CommonUtils.isEmpty(id)) {
        return "";
      }

      return 'http://image.nunting.kr/$id.png';
    }
}