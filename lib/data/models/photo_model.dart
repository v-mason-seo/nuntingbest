import 'package:get_it/get_it.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/entities/photo.dart';
import 'package:ntbest/data/models/base_model.dart';

class PhotoModel extends BaseModel {
  Api _api = GetIt.instance<Api>();
  List<Photo> photos;

  Future getPhotos(int id) async {
    setBusy(true);
    photos = await _api.getPhotos(id);
    setBusy(false);
  }
}