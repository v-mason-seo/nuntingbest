import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/data/models/base_model.dart';
import 'package:ntbest/util/common_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySiteModel extends BaseModel {

  Api _api = GetIt.I<Api>();

  // 전체 사이트 리스트
  List<Site> sites = [];


  Site getItem(int index) => sites.isNotEmpty ? sites[index] : null;


  ///
  /// 사이트 이름
  ///
  String getTitle(int index) {
    if ( sites == null || sites.length == 0) {
      return "no_name";
    }

    return getItem(index).nm;
  }

  void setVisible(Site site, bool isVisible) async{
    site.visible = isVisible;
    notifyListeners();
  }


  bool isVisible(int index) {
    if ( sites == null || sites.length == 0) {
      return false;
    }

    return getItem(index).visible;
  }


  ///
  /// 사이트 섬네일 이미지
  ///
  String getThumbnailUrl(int index) {
    if ( sites == null || sites.length == 0) {
      return "";
    }

    return 'http://image.nunting.kr/${getItem(index).id}.png';
  }


  ///
  /// 사이트 목록을 가져온다.
  ///
  Future fetchSitesWithBoards() async {
    setBusy(true);
    //List<Site> remoteSites = await _api.getSitesWithBoards();
    List<Site> remoteSites = await _api.getSitesWithBoards();
    List<Site> localSites = [];
    
    if ( CommonUtils.isEmpty(remoteSites))
      return;
    
    // (2) 로컬에 저장된 사이트 정보를 불러온다.
    SharedPreferences pref = await SharedPreferences.getInstance();
    String raw = pref.getString('my_site_list');

    if( CommonUtils.isEmpty(raw)) {
      // (3-1) 사이트정보를 json 형태로 로컬에 저장한다.
      String encodeSites = json.encode(remoteSites);
      pref.setString("my_site_list", encodeSites);
    } else {
      // (3-2) 로컬에 저장된 정렬순서, 감추기 여부 정보를 새로 받은 데이터에 세팅함.
      var parsed = json.decode(raw) as List<dynamic>;
      for(var site in parsed) {
        localSites.add(Site.fromJson(site));
      }
      
      for(Site remoteSite in remoteSites) {
        for(Site localSite in localSites) {
          if ( localSite.id == remoteSite.id) {
            remoteSite.sortSeq = localSite.sortSeq;
            remoteSite.visible = localSite.visible;
          }
        }
      }
    }

    sites = remoteSites;

    // sites.sort((Site a, Site b) => a.sortSeq.compareTo(b.sortSeq));

    // for( var site in sites) {
    //   if ( site.visible == true) {
    //     visibleSites.add(site);
    //   }
    // }

    setBusy(false);
  }

  void saveSites() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String encodeSites = json.encode(sites);
    pref.setString("my_site_list", encodeSites);
  }

  void allSelection() {
    for(Site site in sites) {
      site.visible = true;
    }

    notifyListeners();
  }

  void allUnselection() {
    for(Site site in sites) {
      site.visible = false;
    }

    notifyListeners();
  }
}