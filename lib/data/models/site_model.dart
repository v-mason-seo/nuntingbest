import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/entities/board.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/util/common_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_model.dart';

class SiteModel extends BaseModel {

  Api _api = GetIt.I<Api>();
  // 전체 사이트 리스트
  List<Site> sites = [];
  // 내가 설정한 사이트 정보(site.visible == true)
  List<Site> visibleSites = [];
  // 제외 사이트(site.visible == false)
  List<Site> exceptionSites = [];


  ///
  /// 새로고침
  ///
  Future refresh() async {

    this.sites.clear();
    
    List<Site> remoteSites = await _api.getSitesWithBoards();
    List<Site> localSites = [];
    if ( CommonUtils.isNotEmpty(visibleSites)) {
      visibleSites.clear();
    } else {
      visibleSites = [];
    }
    
    if ( CommonUtils.isEmpty(remoteSites)) {
      notifyListeners();
      return Future;
    }
      
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

      bool isChange = false;
      for(Site remoteSite in remoteSites) {

        Site findSite;
        for(Site localSite in localSites) {
          if ( localSite.id == remoteSite.id) {
            findSite = localSite;
          }
        }

        if ( findSite != null) {
          //print('[$tempIndex, ${findSite.nm}] findSite is true, sortSeq : ${findSite.sortSeq}');
          remoteSite.sortSeq = findSite.sortSeq;
          remoteSite.visible = findSite.visible;
        } else {
          //print('findSite is false');
          isChange = true;
        }
      }

      if ( isChange) {
        String encodeSites = json.encode(remoteSites);
        pref.setString("my_site_list", encodeSites);
      }
    }

    sites = remoteSites;

    sites.sort((Site a, Site b) => a.sortSeq.compareTo(b.sortSeq));

    visibleSites?.clear();
    exceptionSites?.clear();
    for( var site in sites) {
      if ( site.visible == true) {
        visibleSites.add(site);
      } else {
        exceptionSites.add(site);
      }
    }
    
    notifyListeners();
    
    return Future;
  }

  ///
  /// 사이트 목록을 가져온다.
  ///
  Future fetchSites() async {
    setBusy(true);
    sites = await _api.getSites();
    if ( sites == null ) sites = [];
    setBusy(false);
  }


  ///
  /// 사이트 목록과 게시판 정보를 가져온다.
  ///
  // Future fetchSitesWithBoards() async {
  //   setBusy(true);
  //   sites = await _api.getSitesWithBoards();
  //   if ( sites == null ) sites = [];

  //   String encodeSites = json.encode(sites);
  //   print('=====> encodeSites : $encodeSites');

  //   if ( sites != null && sites.length > 0) {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     String raw = pref.getString('my_site_list');
  //     print('-----------------------------');
  //     print('[pref] raw : $raw, sites length : ${sites.length}');
  //     print('-----------------------------');
  //     if ( raw.isEmpty && sites.length > 0 ) {
  //       print('[pref] raw.isEmpty is true');
  //       String encodeSites = json.encode(sites);
  //       print('=====> encodeSites : $encodeSites');
  //       pref.setString("my_site_list", encodeSites);
  //     } else {
  //       print('[pref] raw.isEmpty is false');
  //     }
  //   }
    
  //   setBusy(false);
  // }

  Future fetchSitesWithBoards() async {
    setBusy(true);
    List<Site> remoteSites = await _api.getSitesWithBoards();
    List<Site> localSites = [];
    // if ( CommonUtils.isNotEmpty(visibleSites)) {
    //   visibleSites.clear();
    // } else {
    //   visibleSites = [];
    // }
    
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
      
      bool isChange = false;
      for(Site remoteSite in remoteSites) {

        Site findSite;
        for(Site localSite in localSites) {
          if ( localSite.id == remoteSite.id) {
            findSite = localSite;
          }
        }

        if ( findSite != null) {
          //print('[$tempIndex, ${findSite.nm}] findSite is true, sortSeq : ${findSite.sortSeq}');
          remoteSite.sortSeq = findSite.sortSeq;
          remoteSite.visible = findSite.visible;
        } else {
          //print('findSite is false');
          isChange = true;
        }
      }

      if ( isChange) {
        String encodeSites = json.encode(remoteSites);
        pref.setString("my_site_list", encodeSites);
      }
    }

    sites = remoteSites;

    sites.sort((Site a, Site b) => a.sortSeq.compareTo(b.sortSeq));

    exceptionSites?.clear();
    for( var site in sites) {
      if ( site.visible == true) {
        visibleSites.add(site);
      } else {
        exceptionSites.add(site);
      }
    }

    setBusy(false);
  }

  int get getItemCount => sites.length;

  int get getVisibleSiteItemCount => visibleSites!= null ? visibleSites.length : 0;

  Site getItem(int index) => sites.isNotEmpty ? sites[index] : null;

  Site getVisibleSiteItem(int index) => visibleSites.isNotEmpty ? visibleSites[index] : null;
  
  Site findItem(String id) {
    if (CommonUtils.isEmpty(sites)) {
      return null;
    }

    for(Site site in sites) {
      if ( site.id == id) {
        return site;
      }
    }

    return null;
  }
  
  ///
  /// 사이트 이름
  ///
  String getTitle(int index) {
    if ( sites == null || sites.length == 0) {
      return "no_name";
    }

    return getItem(index).nm;
  }


  String getVisibleSiteTitle(int index) {
    if ( visibleSites == null || visibleSites.length == 0) {
      return "no_name";
    }

    return getVisibleSiteItem(index).nm;
  }


  ///
  /// 사이트 타입
  ///
  String getType(int index) {
    if ( sites == null || sites.length == 0) {
      return "no_type";
    }

    return getItem(index).nm;
  }

  bool isVisible(int index) {
    if ( sites == null || sites.length == 0) {
      return false;
    }

    return getItem(index).visible;
  }


  ///
  /// 사이트 게시판 이름을 가져온다. ( 콤마로 연결 )
  ///
  String getBoardNames(int index) {
    if ( sites == null 
        || sites.length == 0 
        || sites[index].boards == null 
        || sites[index].boards.length == 0) {
        return "";
    }

    String boardNames = "";

    for(int i=0; i < sites[index].boards.length; i++) {
      Board board = sites[index].boards[i];
      if ( i == sites[index].boards.length-1) {
        boardNames += ( board.bnm );
      } else {
        boardNames += ( board.bnm + ", " );
      }
      
    }

    return boardNames;
  }


  String getVisibleSiteBoardNames(int index) {
    if ( visibleSites == null 
        || visibleSites.length == 0 
        || visibleSites[index].boards == null 
        || visibleSites[index].boards.length == 0) {
        return "";
    }

    String boardNames = "";

    for(int i=0; i < visibleSites[index].boards.length; i++) {
      Board board = visibleSites[index].boards[i];
      if ( i == visibleSites[index].boards.length-1) {
        boardNames += ( board.bnm );
      } else {
        boardNames += ( board.bnm + ", " );
      }
      
    }

    return boardNames;
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


  String getVisibleSiteThumbnailUrl(int index) {
    if ( visibleSites == null || visibleSites.length == 0) {
      return "";
    }

    return 'http://image.nunting.kr/${getVisibleSiteItem(index).id}.png';
  }

  void updateSite(int oldIndex, int newIndex) async{
    //print('[updateSite] oldIndex : $oldIndex, newIndex : $newIndex');
    if (newIndex > oldIndex) {
        newIndex -= 1;
      }
    final Site item = sites.removeAt(oldIndex);
    sites.insert(newIndex, item);

    for(var i=0; i < sites.length; i++) {
      sites[i].sortSeq = i;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String encodeSites = json.encode(sites);
    pref.setString("my_site_list", encodeSites);

    if ( CommonUtils.isNotEmpty(visibleSites)) {
      visibleSites.clear();
    } else {
      visibleSites = [];
    }
    for( var site in sites) {
      if ( site.visible == true) {
        visibleSites.add(site);
      }
    }
    
    notifyListeners();
  }

  void setVisible(Site site, bool isVisible) async{
    site.visible = isVisible;

    SharedPreferences pref = await SharedPreferences.getInstance();
    String encodeSites = json.encode(sites);
    pref.setString("my_site_list", encodeSites);

    if ( CommonUtils.isNotEmpty(visibleSites)) {
      visibleSites.clear();
    } else {
      visibleSites = [];
    }

    for( var site in sites) {
      if ( site.visible == true) {
        visibleSites.add(site);
      }
    }

    notifyListeners();
  }

  bool isChangedSites = false;

  Future saveSites(List<Site> newSites) async {

    // print("--------------------------------");
    // print("[OLD]");
    // print("--------------------------------");
    // for(Site origin in sites) {
    //   print("site.id : ${origin.id}, visible: ${origin.visible}");
    // }

    // print("--------------------------------");
    // print("[NEW]");
    // print("--------------------------------");
    // for(Site origin in newSites) {
    //   print("newSite.id : ${origin.id}, visible: ${origin.visible}");
    // }

    Function deepEq = const DeepCollectionEquality.unordered().equals;
    bool isEqual = deepEq(newSites, sites);
    if ( isEqual) {
      return;
    }

    isChangedSites = !isChangedSites;
    sites = newSites;

    exceptionSites?.clear();
    visibleSites?.clear();
    for( var site in sites) {
      if ( site.visible == true) {
        visibleSites.add(site);
      } else {
        exceptionSites.add(site);
      }
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String encodeSites = json.encode(sites);
    pref.setString("my_site_list", encodeSites);

    notifyListeners();
  }

}