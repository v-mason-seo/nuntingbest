
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ntbest/data/service_locator/service_locator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:ntbest/data/models/site_model.dart';
import 'package:ntbest/ui/base_widget.dart';
import 'package:provider/provider.dart';
import 'package:ntbest/data/constants/app_contstants.dart';
import 'package:ntbest/data/Ad/ad_manager.dart';

import 'data/models/app_model.dart';
import 'ui/router.dart';
import 'ui/pages/start_page.dart';


// todo - 1. 이미지 url 가져오는 함수 model -> site 클래스로 이동
// todo - 2. 위젯 함수 또는 클래스로 분리하기
// todo - 3. 사이트 이미지 decoration 넣기
// admob app id : ca-app-pub-6608605689570528~4790861499
// 하단배너 id : ca-app-pub-6608605689570528/3677068297
// 전면광고 id : ca-app-pub-6608605689570528/8885665800


final AppModel model = AppModel();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(testDeviceIds: ['E4B200C7136AD0708A2BF1FA76A2E94B',
                  'C688FB9C0634F2E6FF40ADFF71711FFF',
                  '70D53A4C46EFEAAA47D76A37CA7499DA',
                  '5729E8A35C13BBBAD9E1DBE06F7B1DE2',
                  'E734400E3568F17063613BBF53A2D239']);

  runApp(MyApp());
  setupLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_) => timeago.setLocaleMessages('ko', timeago.KoMessages()))
  .then((_) => model.init())
  ;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    serviceLocator.get<AdManager>().init();
  }

  @override
  void dispose() async {
    serviceLocator.get<AdManager>().dispose();
    super.dispose();
  }
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //----------------------------------------
      providers: [
        ChangeNotifierProvider(
          builder: (context) => model,
        ),
      ],
      //----------------------------------------
      child: Consumer<AppModel>(
        builder: (context, appModel, child) {
          return BaseWidget<SiteModel>(
            model: SiteModel(),
            onModelReady: (model) => model.fetchSitesWithBoards(),
            builder: (context, model, child) {
              return MaterialApp(
                title: '눈팅베스트',
                theme: appModel.requestTheme(Brightness.light),
                darkTheme: appModel.requestTheme(Brightness.dark),
                home: SafeArea(
                  bottom: true,
                  child: Column(
                    children: [
                      //--------------------------------------------
                      Expanded(
                        child: StartPage(),
                      ),
                      //--------------------------------------------
                      buildAdMob(),
                      //--------------------------------------------
                    ],
                  ),
                ),
                onGenerateRoute: AppRouter.getnerateRoute,
                //debugShowCheckedModeBanner: true,
              );
            }
          );
        },
      ),
    );
  }


  ///
  /// 애드몹
  ///
  Widget buildAdMob() {
    return AdmobBanner(
      adSize: AdmobBannerSize.BANNER,
      adUnitId: AdInfo.bannerId,
      onBannerCreated: (AdmobBannerController controller) {
      },
    );
  }
}