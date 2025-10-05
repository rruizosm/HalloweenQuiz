import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  //Create (update) operation
  Future<void> create({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final DatabaseReference ref = _database.ref().child(path);
    await ref.set(data);
  }

  //Read operation
  Future<DataSnapshot?> read({required String path}) async {
    final DatabaseReference ref = _database.ref().child(path);
    final DataSnapshot snapshot = await ref.get();
    return snapshot.exists ? snapshot : null;
  }

  //Update operation
  Future<void> update({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final DatabaseReference ref = _database.ref().child(path);
    await ref.update(data);
  }
}