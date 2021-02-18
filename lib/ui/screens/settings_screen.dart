import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ntbest/data/constants/app_contstants.dart';
import 'package:ntbest/data/models/app_model.dart';
import 'package:ntbest/ui/widgets/dialog_round.dart';
import 'package:ntbest/ui/widgets/radio_cell.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_setting/system_setting.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScrreenState createState() => SettingsScrreenState();
}

class SettingsScrreenState extends State<SettingsScreen> {
  Themes _themeIndex;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _themeIndex = Provider.of<AppModel>(context).theme;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('설정'),
        ),
        body: Consumer<AppModel>(
          builder: (context, model, child) => ListView(
            children: <Widget>[
              //--------------------------------------
              ListTile(
                leading: Icon(Icons.notification_important),
                title: Text(
                  '푸시 알림',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '푸시알림 설정하기',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () => SystemSetting.goto(SettingTarget.NOTIFICATION),
              ),
              //--------------------------------------
              Divider(),
              //--------------------------------------
              ListTile(
                title: Text(
                  '테마선택',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  'Light & Dart 테마 선택',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Icon(Icons.palette),
                trailing: Icon(Icons.chevron_right),
                onTap: () => showDialog(
                    context: context,
                    builder: (context) => RoundDialog(
                          title: '테마선택',
                          children: <Widget>[
                            RadioCell<Themes>(
                              title: '다크테마',
                              groupValue: _themeIndex,
                              value: Themes.dark,
                              onChanged: (value) => _changeTheme(value),
                            ),
                            RadioCell<Themes>(
                              title: '블랙테마',
                              groupValue: _themeIndex,
                              value: Themes.black,
                              onChanged: (value) => _changeTheme(value),
                            ),
                            RadioCell<Themes>(
                              title: '라이트테마',
                              groupValue: _themeIndex,
                              value: Themes.light,
                              onChanged: (value) => _changeTheme(value),
                            ),
                            RadioCell<Themes>(
                              title: '시스템테마',
                              groupValue: _themeIndex,
                              value: Themes.system,
                              onChanged: (value) => _changeTheme(value),
                            ),
                          ],
                        )),
              ),
              //--------------------------------------
              Divider(),
              //--------------------------------------
              //브라우저 선택 옵션창은 삭제한다.
              //webview_flutter도 Widget 처럼 사용할 수 있기 때문에 webview_flutter 통일함.
              //
              // ListTile(
              //   title: Text('브라우저선택', maxLines: 1, overflow: TextOverflow.ellipsis,),
              //   subtitle: Text('브라우저 종류를 선택합니다.', maxLines: 1, overflow: TextOverflow.ellipsis,),
              //   leading: Icon(MaterialCommunityIcons.getIconData("web")),
              //   trailing: Icon(Icons.chevron_right),
              //   onTap: () => showDialog(
              //     context: context,
              //     builder: (context) => RoundDialog(
              //       title: '웹 브라우저 종류 선택',
              //       children: <Widget>[
              //         RadioCell<WebviewType>(
              //           title: '일반',
              //           groupValue: _webviewType,
              //           value: WebviewType.webview_plugin,
              //           onChanged: (value) => _changeWebviewType(value),
              //         ),
              //         RadioCell<WebviewType>(
              //           title: '스와이프로 화면 종료 가능\n(속도와 안전성 부족)',
              //           groupValue: _webviewType,
              //           value: WebviewType.inappbroser,
              //           onChanged: (value) => _changeWebviewType(value),
              //         ),
              //       ],
              //     )
              //   )
              // ),
              //--------------------------------------
              Divider(),
              //--------------------------------------
              ListTile(
                title: Text(
                  '사이트 설정',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '순서 또는 보이기/감추기를 설정할 수 있어요',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Icon(Icons.lightbulb_outline),
                trailing: Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.pushNamed(context, RoutePaths.MySiteList),
              ),
              //--------------------------------------
              Divider(),
              //--------------------------------------
              ListTile(
                title: Text(
                  '개인정보처리방침',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Icon(MdiIcons.alertCircleOutline),
                trailing: Icon(Icons.chevron_right),
                onTap: () async {
                  const url =
                      'https://s3.ap-northeast-2.amazonaws.com/food.nunting.kr/privacy_ntbest_android.html';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              //--------------------------------------
            ],
          ),
        ),
      ),
    );
  }

  void _changeTheme(Themes theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    Provider.of<AppModel>(context).theme = theme;
    prefs.setInt('theme', theme.index);

    // Updates UI
    setState(() => _themeIndex = theme);

    // Hides dialog
    Navigator.of(context).pop();
  }
}
