import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabaseService extends GetxService {
  ///TO STATIC SERVICE
  static HiveDatabaseService get to => Get.find();

  ///PROPERTIES
  late BoxCollection collection;
  late String path;

  HiveDatabaseService({
    required this.name,
    required this.boxNames,
    required this.registerAdapters,
    this.cipherKey,
  });

  ///NAME OF COLLECTION (REQUIRED)*
  final String name;

  ///BOXES NAMES (REQUIRED)*
  final Set<String> boxNames;

  ///OBJECT ADAPTERS (OPTIONAL)
  final Future<void> Function() registerAdapters;

  ///ENCRYPTION KEY (OPTIONAL)
  final HiveCipher? cipherKey;

  ///INITIALIZATION
  Future<HiveDatabaseService> init() async {
    ///defined path
    final appDocumentDirectory = await getApplicationDocumentsDirectory();

    ///register Objects adapters is exist
    registerAdapters();

    ///instantiate collection
    collection = await BoxCollection.open(
      name,
      boxNames,
      path: appDocumentDirectory.path,
      key: cipherKey,
    );

    return this;
  }

  static Future<void> registerAdapter<T>(TypeAdapter<T> adapter) async {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter<T>(adapter);
    }
  }

  ///BOX METHODS
  Future<void> put<T>(
    String boxName, {
    required String id,
    dynamic value,
  }) async =>
      box<T>(boxName).put(id, value);

  Future<T?> get<T>(
    String boxName, {
    required String id,
  }) async =>
      box<T>(boxName).get(id);

  Future<void> delete<T>(
    String boxName, {
    required String id,
  }) async =>
      box<T>(boxName).delete(id);

  Future<void> deleteAll<T>(
    String boxName, {
    required List<String> ids,
  }) async =>
      box<T>(boxName).deleteAll(ids);

  Future<void> clear<T>(String boxName) async => box<T>(boxName).clear();
  Future<void> flush<T>(String boxName) async => box<T>(boxName).flush();

  ///COLLECTIONS METHODS
  Box<T> box<T>(String boxName) => Hive.box<T>(boxName);
  List<T> values<T>(String boxName) => box<T>(boxName).values.toList();
  void collectionClose() async => collection.close();
  void collectionDeleteFromDisk() async => collection.deleteFromDisk();
}
