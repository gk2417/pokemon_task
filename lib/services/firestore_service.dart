import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // Path: users/{uid}/favorites/{name}
  CollectionReference<Map<String, dynamic>> favoritesCol(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  Stream<List<Map<String, dynamic>>> streamFavorites(String uid) {
    return favoritesCol(uid).snapshots().map((snap) =>
        snap.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Future<void> addFavorite({required String uid, required Map<String, dynamic> data}) async {
    await favoritesCol(uid).doc(data['name'] as String).set(data, SetOptions(merge: true));
  }

  Future<void> removeFavorite({required String uid, required String name}) async {
    await favoritesCol(uid).doc(name).delete();
  }
}