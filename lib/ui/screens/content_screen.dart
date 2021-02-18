import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/entities/content_parameter.dart';
import 'package:ntbest/ui/widgets/site_logo_widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentScreen extends StatefulWidget {
  final Api _api = GetIt.instance<Api>();
  final ContentParam _param;

  //ContentScreen(this.postItem);
  ContentScreen({
    @required ContentParam param,
  }) : _param = param;

  @override
  ContentScreenState createState() => ContentScreenState();
}

class ContentScreenState extends State<ContentScreen>
    with SingleTickerProviderStateMixin {
  Widget bookmarkIcon;
  bool isLoading = true;
  WebViewController _webViewController;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    if (!widget._param.isDelete) {
      Future.delayed(Duration(minutes: 3)).then((onValue) {
        if (this.mounted) {
          if (widget._param.postType == PostType.general) {
            widget._api.readContent(
                widget._param.sid, widget._param.url, widget._param.title);
          } else {
            widget._api.readTopOfTopContent(
                widget._param.sid, widget._param.url, widget._param.title);
          }
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///
  /// C:\dev\flutter-sdk\flutter\.pub-cache\hosted\pub.dartlang.org\webview_flutter-1.0.7\android\src\main\java\io\flutter\plugins\webviewflutter\FlutterWebView.java
  /// FlutterWebView() 함수에서
  /// webView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE);
  /// 위 코드를 추가했다.
  /// 저 코드가 없으면 웹뷰에서 이미지나 동영상이 안나오는경우가 있다.
  /// webview 플로그인 업데이트 하면 저 코드를 추가해야줘 함.
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---------------------------------------------
      appBar: buildAppBar(),
      //---------------------------------------------
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              _webViewController?.reload();
            },
            child: WebView(
              debuggingEnabled: false,
              initialUrl: widget._param.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onPageStarted: (stared) async {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (finished) async {
                setState(() {
                  isLoading = false;
                });
              },
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Row(
        children: <Widget>[
          SiteLogo(
            url: widget._param.getThumbnailUrl(),
            size: 32.0,
          ),
          SizedBox(
            width: 12.0,
          ),
          //Text(widget._param.sname, overflow: TextOverflow.ellipsis,)
        ],
      ),
      actions: <Widget>[
        //---------------------------------
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _webViewController?.reload();
          },
        ),
        //---------------------------------
        IconButton(
          icon: Icon(MdiIcons.shareVariantOutline),
          onPressed: () async {
            String currentUrl = widget._param.url;
            Share.share(currentUrl);
          },
        ),
        //---------------------------------
        IconButton(
          icon: Icon(MdiIcons.googleChrome),
          onPressed: () async {
            if (await canLaunch(widget._param.url)) {
              await launch(widget._param.url);
            } else {
              throw 'Could not launch ${widget._param.url}}';
            }
          },
        ),
        //---------------------------------
        IconButton(
          icon: widget._param.isBookmark
              ? Icon(
                  MdiIcons.bookmark,
                  color: Theme.of(context).accentColor,
                )
              : Icon(
                  MdiIcons.bookmarkPlusOutline,
                ),
          onPressed: () {
            GetIt.I<MyDatabase>().insertBookmarkContent(BookmarkContentData(
              sid: widget._param.sid,
              title: widget._param.title,
              url: widget._param.url,
              read: false,
              dueDate: DateTime.now(),
            ));

            setState(() {
              widget._param.isBookmark = true;
            });
          },
        ),
        //---------------------------------
      ],
    );
  }
}
