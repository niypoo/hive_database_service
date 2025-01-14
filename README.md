# hive_database_service
A GetX service designed to provide access to and management of Hive databases.
This server, written in Dart, relies on a GetX service.


### Instruction
```
void main(){

    await Get.putAsync<HiveDatabaseService>(
        () => HiveDatabaseService(
          name: 'database_name',
          boxNames: {'persons'},
          registerAdapters: () async {
           HiveDatabaseService.registerAdapter<Person>(PersonAdapter());
          },
        ).init(),
      );
      
}

```

## GetX
GetX is an extra-light and powerful solution for Flutter. It combines high-performance state management, intelligent dependency injection, and route management quickly and practically.

For help getting started with GetX
[documentation](https://pub.dev/packages/get).

## Hive
Hive is a lightweight and blazing fast key-value database written in pure Dart. Inspired by Bitcask.


For help getting started with Hive
[documentation](https://pub.dev/packages/hive).
