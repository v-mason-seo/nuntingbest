import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    _isError = false;
    _errorMessage = "";
    notifyListeners();
  }


  bool _isError = false;
  String _errorMessage = "";
  
  bool get isError => _isError;
  String get errorMessage => _errorMessage;

  void setError(bool value, String message) {
    _isError = value;
    value == true ? _errorMessage = message : _errorMessage = "";
    notifyListeners();
  }
}














// import 'package:connectivity/connectivity.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/widgets.dart';

// enum Status {loading, error, loaded}

// abstract class BaseModel with ChangeNotifier {

//   final List items;

//   Status _status;

//   BaseModel([BuildContext context])
//     : items = List() {
//       startLoading();
//       loadData(context);
//     }

//   Future fetchData(String url, {Map<String, dynamic> parameter}) async {
//     final response = await Dio().get(url, queryParameters: parameter);
//     if (items.isNotEmpty) items.clear();

//     print(response.data);

//     return response.data;
//   }

//   Future loadData([BuildContext context]);
//   Future refreshData() async => await loadData();

//   dynamic getItem(index) => items.isNotEmpty ? items[index] : null;
//   int get getItemCount => items.length;

//   bool get isLoading => _status == Status.loading;
//   bool get loadingFailed => _status == Status.error;

//   void startLoading() {
//     _status = Status.loading;
//   }

//   void finishLoading() {
//     _status = Status.loaded;
//     notifyListeners();
//   }

//   void receivedError() {
//     _status = Status.error;
//     notifyListeners();
//   }

//   Future<bool> canLoadData() async {
//     await Connectivity().checkConnectivity() == ConnectivityResult.none
//       ? receivedError()
//       : startLoading();

//     return isLoading;
//   }
// }