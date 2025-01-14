import 'package:get/get.dart';
import 'package:hive_database_service/interfaces/hive.handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabaseService extends GetxService {
  ///TO STATIC SERVICE
  static HiveDatabaseService get to => Get.find<HiveDatabaseService>();

  // Handler
  final HiveDatabaseHandler handler;

  /// CONSTRUCTION
  HiveDatabaseService({required this.handler});

  ///INITIALIZATION
  Future<HiveDatabaseService> init() async {
    await Hive.initFlutter();
    await handler.adaptersRegistrations();
    await handler.boxesCreation();
    return this;
  }

  /// Create the box or return box is exist
  static Future<Box<T>> createBox<T>(String name) async =>
      await Hive.openBox<T>(name);

  /// register Adapter
  static Future<void> registerAdapter<T>(TypeAdapter<T> adapter) async =>
      Hive.registerAdapter<T>(adapter);

  /// Get and read exist box
  Box<T> getBox<T>(String name) => Hive.box<T>(name);

  /// Get and read a data from box by index
  T? getByIndex<T>(String boxName, int index) =>
      (getBox<T>(boxName)).getAt(index);

  /// Get and read a data from box by key
  T? find<T>(String boxName, String id) => (getBox<T>(boxName)).get(id);

  /// Get and read a all data from box
  Iterable<T> all<T>(String boxName, String id) => (getBox<T>(boxName)).values;

  /// delete a data from box by index
  Future<void> deleteByIndex<T>(String boxName, int index) async =>
      await (getBox<T>(boxName)).deleteAt(index);

  /// delete a data from box by index
  Future<void> deleteByKey<T>(String boxName, String id) async =>
      await (getBox<T>(boxName)).delete(id);

  /// delete ids  from box by index
  Future<void> deleteAll<T>(String boxName, Set ids) async =>
      await (getBox<T>(boxName)).deleteAll(ids);

  /// delete And Close a Box
  Future<void> deleteAndCloseBox<T>(String boxName) async =>
      await (getBox<T>(boxName)).deleteFromDisk();

  /// delete And Close a Box
  Future<void> clear<T>(String boxName) async =>
      await (getBox<T>(boxName)).clear();
}
