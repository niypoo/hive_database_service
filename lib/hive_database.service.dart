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
    this.cipherKey,
    this.adapters,
  });

  ///NAME OF COLLECTION (REQUIRED)*
  final String name;

  ///BOXES NAMES (REQUIRED)*
  final Set<String> boxNames;

  ///OBJECT ADAPTERS (OPTIONAL)
  final Set<TypeAdapter>? adapters;

  ///ENCRYPTION KEY (OPTIONAL)
  final HiveCipher? cipherKey;

  ///INITIALIZATION
  Future<HiveDatabaseService> init() async {
    ///defined path
    final appDocumentDirectory = await getApplicationDocumentsDirectory();

    ///register Objects adapters is exist
    registerAdapter(adapters);

    ///instantiate collection
    collection = await BoxCollection.open(
      name,
      boxNames,
      path: appDocumentDirectory.path,
      key: cipherKey,
    );

    return this;
  }

  ///Register Objects Adapters
  void registerAdapter<T>(Set<TypeAdapter<T>>? adapters) {
    ///skip
    if (adapters == null || adapters.isEmpty) return;

    ///register
    for (var adapter in adapters) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter<T>(adapter);
      }
    }
  }

  ///BOX METHODS
  Future<void> put<T>(
    String boxName, {
    required String id,
    dynamic value,
  }) async =>
      (await openBox<T>(boxName)).put(id, value);

  Future<T?> get<T>(
    String boxName, {
    required String id,
  }) async =>
      (await openBox<T>(boxName)).get(id);

  Future<Map<String, T>> getAllValues<T>(String boxName) async =>
      (await openBox<T>(boxName)).getAllValues();

  Future<void> delete<T>(
    String boxName, {
    required String id,
  }) async =>
      (await openBox<T>(boxName)).delete(id);

  Future<void> deleteAll<T>(
    String boxName, {
    required List<String> ids,
  }) async =>
      (await openBox<T>(boxName)).deleteAll(ids);

  Future<void> clear<T>(String boxName) async =>
      (await openBox<T>(boxName)).clear();

  Future<void> flush<T>(String boxName) async =>
      (await openBox<T>(boxName)).flush();

  Future<List<T?>> getAll<T>(
    String boxName, {
    required List<String> ids,
  }) async =>
      (await openBox<T>(boxName)).getAll(ids);

  Future<List<String>> getAllKeys<T>(String boxName) async =>
      (await openBox<T>(boxName)).getAllKeys();

  ///COLLECTIONS METHODS
  Future<CollectionBox<T>> openBox<T>(String boxName) async {
    final CollectionBox<T> box = await collection.openBox<T>(boxName);
    return box;
  }

  void collectionClose() async => collection.close();
  void collectionDeleteFromDisk() async => collection.deleteFromDisk();
}
