import 'package:flutter/material.dart';
import 'package:ntbest/data/constants/app_contstants.dart';
import 'package:ntbest/data/models/site_model.dart';
import 'package:ntbest/ui/widgets/site_logo_widget.dart';
import 'package:provider/provider.dart';



class SitePage extends StatefulWidget {

  SitePage({
    Key key,
  }) : super(key: key);
  
  @override
  _SitePageState createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> 
  with AutomaticKeepAliveClientMixin<SitePage> {

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<SiteModel>(
      builder: (context, model, child) {

        if ( model.busy) {
          return  Center(child: CircularProgressIndicator(),);
        }
        
        return RefreshIndicator(
          onRefresh: () => model.refresh(),
          child: _buildSiteItems(model),
        );
      },
    );
  }


  ///
  /// 사이트 ListView
  ///
  Widget _buildSiteItems(SiteModel model) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount:  model.getVisibleSiteItemCount,
      itemBuilder: (context, index) {

        return ListTile(
          onTap: () => Navigator.pushNamed(context, RoutePaths.PostList, arguments: model.sites[index]),
          title: Text(model.getVisibleSiteTitle(index), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
          subtitle: Text(model.getVisibleSiteBoardNames(index), style: TextStyle(fontSize: 13, color: Colors.grey[700]),),
          leading: SiteLogo(url: model.getVisibleSiteThumbnailUrl(index),),
        );
      },
    );
  }
}
