import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pokemon.dart';

class PokemonProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final List<Pokemon> _items = [];

  int _offset = 0;
  final int _limit = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  String _search = '';

  List<Pokemon> get items {
    if (_search.isEmpty) return List.unmodifiable(_items);
    return _items
        .where((p) => p.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> refresh() async {
    _items.clear();
    _offset = 0;
    _hasMore = true;
    _isLoading = true; // ✅ Show loading state immediately
    notifyListeners();
    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_isLoading && _offset != 0) return; // avoid duplicate calls
    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _api.fetchPokemonPage(offset: _offset, limit: _limit);
      final List results = (data['results'] as List?) ?? [];
      if (results.isEmpty) {
        _hasMore = false;
      } else {
        final newOnes = results.map((e) => Pokemon.fromApiMap(e as Map<String, dynamic>));
        _items.addAll(newOnes);
        _offset += _limit;
      }
    } catch (e) {
      debugPrint('Pokémon fetch error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearch(String q) {
    _search = q;
    notifyListeners();
  }
}
