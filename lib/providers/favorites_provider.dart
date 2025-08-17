import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pokemon.dart';
import '../services/firestore_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirestoreService _fs = FirestoreService();
  StreamSubscription<List<Map<String, dynamic>>>? _sub;

  final Map<String, Pokemon> _favorites = {}; 

  Map<String, Pokemon> get favorites => Map.unmodifiable(_favorites);
  List<Pokemon> get asList => _favorites.values.toList();

  void start() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    _sub?.cancel();
    _sub = _fs.streamFavorites(uid).listen((docs) {
      _favorites.clear();
      for (final m in docs) {
        final p = Pokemon(
          name: (m['name'] ?? '') as String,
          id: (m['id'] ?? 0) as int,
          imageUrl: (m['imageUrl'] ?? '') as String,
        );
        _favorites[p.name] = p;
      }
      notifyListeners();
    });
  }

  void stop() {
    _sub?.cancel();
  }

  bool isFavorite(String name) => _favorites.containsKey(name);

  Future<void> toggle(Pokemon p) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    if (isFavorite(p.name)) {
      await _fs.removeFavorite(uid: uid, name: p.name);
    } else {
      await _fs.addFavorite(uid: uid, data: p.toMap());
    }
  }
}