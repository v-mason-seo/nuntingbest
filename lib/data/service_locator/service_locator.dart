import 'package:get_it/get_it.dart';
import 'package:ntbest/data/api/api.dart';
import 'package:ntbest/data/databse/app_database.dart';
import 'package:ntbest/data/Ad/ad_manager.dart';

final serviceLocator = GetIt.instance;


void setupLocator() {

  serviceLocator.registerSingleton<Api>(Api());
  serviceLocator.registerSingleton<MyDatabase>(MyDatabase());
  serviceLocator.registerSingleton<AdManager>(AdManager());

}