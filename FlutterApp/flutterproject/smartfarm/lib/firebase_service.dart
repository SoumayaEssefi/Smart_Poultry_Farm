import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<Map<String, dynamic>> getData() async {
    DataSnapshot snapshot = await _database.child('Data').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      return {};
    }
  }

  Future<void> updateData(String key, dynamic value) async {
    await _database.child('Data').update({key: value});
  }

  Future<Map<String, dynamic>> getEggsData() async {
    DataSnapshot snapshot = await _database.child('eggs').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      return {};
    }
  }

  Future<void> updateEggsData(String key, dynamic value) async {
    await _database.child('eggs').update({key: value});
  }
}
