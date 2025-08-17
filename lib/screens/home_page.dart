import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/favorites_page.dart';
import '../screens/pokemon_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonProvider>().refresh();
      context.read<FavoritesProvider>().start();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<PokemonProvider>().fetchMore();
      }
    });

    // ✅ Listen for internet changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      final online =
          results.isNotEmpty && results.first != ConnectivityResult.none;

      if (online != _isOnline) {
        setState(() => _isOnline = online);
        _showNetworkStatus(online);

        // 🔄 If internet comes back, refresh automatically
        if (online) {
          context.read<PokemonProvider>().refresh();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _showNetworkStatus(bool isOnline) {
    final message = isOnline
        ? '✅ Back Online — refreshing data...'
        : '❌ No Internet Connection';
    final color = isOnline ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = context.watch<PokemonProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.red,
            tooltip: "Favorites",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthProvider>().logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text("Logout"),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              onChanged: pokemonProvider.setSearch,
              decoration: InputDecoration(
                hintText: 'Search Pokémon by name or number',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),

        

      ),
      backgroundColor: const Color(0xFFF5F5F5),

      // ✅ Pull-to-refresh + automatic refresh
      body: RefreshIndicator(
        onRefresh: () => context.read<PokemonProvider>().refresh(),
        child: pokemonProvider.isLoading && pokemonProvider.items.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // two cards per row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85, // makes card taller
                ),
                itemCount: pokemonProvider.items.length +
                    (pokemonProvider.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < pokemonProvider.items.length) {
                    final p = pokemonProvider.items[index];
                    final isFav = favoritesProvider.isFavorite(p.name);

                    return AnimatedOpacity(
                      opacity: 1,
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      child: AnimatedSlide(
                        offset: const Offset(0, 0.1),
                        duration: Duration(milliseconds: 300 + (index * 50)),
                        curve: Curves.easeOut,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PokemonDetailPage(pokemon: p),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.network(
                                          p.imageUrl,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            p.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            p.id.toString().padLeft(3, '0'),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () => favoritesProvider.toggle(p),
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
    );
  }
}
