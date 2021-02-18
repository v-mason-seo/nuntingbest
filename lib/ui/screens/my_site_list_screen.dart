import 'package:flutter/material.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/data/models/my_site_model.dart';
import 'package:ntbest/data/models/site_model.dart';
import 'package:ntbest/ui/base_widget.dart';
import 'package:ntbest/ui/widgets/site_logo_widget.dart';
import 'package:provider/provider.dart';


class MySiteListScreen extends StatefulWidget {
  @override
  MySiteListScreenState createState() => MySiteListScreenState();
}

class MySiteListScreenState extends State<MySiteListScreen> {
  @override
  Widget build(BuildContext context) {

    return BaseWidget<MySiteModel>(
      model: MySiteModel(),
      onModelReady: (model) => model.fetchSitesWithBoards(),
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Scaffold(
            appBar: AppBar(
              title: Text("숨김 사이트 설정"),
              centerTitle: true,
              actions: [
                FlatButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                
                SiteModel siteModel = Provider.of<SiteModel>(context);
                await siteModel.saveSites(model.sites);
                Navigator.pop(context);
              }, 
              label: Text("완료")
            ),
            body: Builder(
              builder: (context) {
                if (model.busy) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return RefreshIndicator(
                    onRefresh: () => Future.delayed(Duration(seconds: 1)),
                    child: _buildEditSiteGridView(),
                  );
              },
            )
          ),  
        );
      }
    );
  }


  Widget _buildEditSiteGridView() {
    return Consumer<MySiteModel>(
      builder: (context, model, child) {
        return GridView.builder(
          itemCount: model.sites.length + 2,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemBuilder: (context, i) {

            if ( i == 0 ) {
              return GestureDetector(
                onTap: () {
                  model.allSelection();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: DividerTheme.of(context).color ?? Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text("전체선택"),
                  ),
                ),
              );
            }

            if ( i == 1 ) {
              return GestureDetector(
                onTap: () {
                  model.allUnselection();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: DividerTheme.of(context).color ?? Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text("전체해제"),
                  ),
                ),
              );
            }

            int index = i - 2;
            Site site = model.getItem(index);
            return GestureDetector(
              onTap: () {
                model.setVisible(site, !site.visible);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: DividerTheme.of(context).color ?? Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                        child: ColorFiltered(
                        colorFilter: model.isVisible(index)
                          ? ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                          : ColorFilter.mode(Colors.grey, BlendMode.saturation),
                        child: SiteLogo(url: model.getThumbnailUrl(index)),
                      ),
                    ),
                    SizedBox(height: 12,),
                    Text(
                      model.getTitle(index), 
                      style: TextStyle(
                        fontSize: 13, 
                        fontWeight: FontWeight.w500,
                        color: model.isVisible(index) ? null : Theme.of(context).disabledColor
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}