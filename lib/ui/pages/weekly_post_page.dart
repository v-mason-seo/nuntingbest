import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/entities/best_post.dart';
import 'package:ntbest/data/models/site_model.dart';
import 'package:ntbest/data/models/weekly_post_model.dart';
import 'package:ntbest/ui/widgets/today_content_cell.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';



class WeeklyPostPage extends StatefulWidget {
  
  @override
  _WeeklyPostPageState createState() => _WeeklyPostPageState();
}

// 오늘, 주간
class _WeeklyPostPageState extends State<WeeklyPostPage> 
with AutomaticKeepAliveClientMixin<WeeklyPostPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<SiteModel>(
      builder: (context, siteModel, _) {

        return BaseWidget<WeeklyPostModel>(
          model: WeeklyPostModel(),
          onModelReady: (model) => model.fetchPosts(siteModel.exceptionSites),
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
                        model.fetchPosts(siteModel.exceptionSites);
                      },
                    )
                  ],
                ),
              );
            }

            return model.busy
              ? Center(child: CircularProgressIndicator(),)
              : RefreshIndicator(
                  onRefresh: () => model.refresh(siteModel.exceptionSites),
                  child: _buildWeeklyPostItems(model),
              );
          },
        );
      }
    );
  }


  ///
  ///
  ///
  Widget _buildWeeklyPostItems(WeeklyPostModel model) {
    return ListView.separated(
        key: PageStorageKey('weekly_post_items_key'),
        separatorBuilder: (context, index) => Divider(indent: 5, endIndent: 5,),
        itemCount: model.getPostItemCount() == 0 ? 0 : model.getPostItemCount(),
        itemBuilder: (context, index) {

          BestPost post = model.getPostItem(index);
          return TodayContentCell(
            content: post ,
            onClicked: () {
              GetIt.I<MyDatabase>().insertReadContent(ReadContentData(url: post.url, sid: post.sid, dueDate: DateTime.now()));
              model.readContent(index);
            },
          );
        },
    );
  }
}