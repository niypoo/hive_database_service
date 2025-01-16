import 'package:flutter/foundation.dart';
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
  T? find<T>(String boxName, String id, {T? defaultValue}) =>
      (getBox<T>(boxName)).get(id, defaultValue: defaultValue);

  /// Get and read a data from box by key
  Future<int> add<T>(String boxName, T object) async =>
      await (getBox<T>(boxName)).add(object);

  /// Get and read a data from box by key
  Future<Iterable<int>> addAll<T>(String boxName, Iterable<T> objects) async =>
      await (getBox<T>(boxName)).addAll(objects);

  /// Get and read a data from box by key
  Future<void> put<T>(String boxName,
          {required String id, required T value}) async =>
      await (getBox<T>(boxName)).put(id, value);

  /// Get and read a data from box by key
  Future<void> putAll<T>(String boxName, Map<dynamic, T> values) async =>
      await (getBox<T>(boxName)).putAll(values);

  /// Get and read a data from box by key
  Future<void> putAt<T>(String boxName,
          {required int index, required T value}) async =>
      await (getBox<T>(boxName)).putAt(index, value);

  /// Get and read a all data from box
  ValueListenable<Box<T>> listenable<T>(String boxName) =>
      (getBox<T>(boxName)).listenable();

  /// Get and read a all data from box
  void addListener<T>(String boxName, void Function() listener) =>
      listenable<T>(boxName).addListener(listener);

  /// Get and read a all data from box
  Stream<BoxEvent> watch<T>(String boxName) => (getBox<T>(boxName)).watch();

  /// Get and read a all data from box
  Iterable<T> all<T>(String boxName) => (getBox<T>(boxName)).values;

  /// Get and read a all data from box
  Map<dynamic, T> toMap<T>(String boxName) => (getBox<T>(boxName)).toMap();

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
