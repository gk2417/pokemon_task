import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Column(
          children: [
            Text(
              pokemon.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              pokemon.id.toString().padLeft(3, '0'),
              style: const TextStyle(
                  fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Main Pokémon image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1F2),
                borderRadius: BorderRadius.circular(16),
              ),
              height: 400,
              width: double.infinity,
              child: Image.network(
                pokemon.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicatorColor: Colors.black,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Forms'),
              Tab(text: 'Detail'),
              Tab(text: 'Types'),
              Tab(text: 'Stats'),
              Tab(text: 'Weakness'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Forms tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Forms list (example)
                      SizedBox(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFormImage(pokemon.imageUrl),
                            _buildFormImage(pokemon.imageUrl),
                            _buildFormImage(pokemon.imageUrl),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Mega Evolution',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'In order to support its flower, which has grown larger due to Mega Evolution, '
                        'its back and legs have become stronger.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Detail tab
                const Center(child: Text('Detail info here...')),

                // Types tab
                const Center(child: Text('Types info here...')),

                // Stats tab
                const Center(child: Text('Stats info here...')),

                // Weakness tab
                const Center(child: Text('Weakness info here...')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormImage(String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1F2),
          borderRadius: BorderRadius.circular(12),
        ),
        width: 60,
        height: 60,
        child: Image.network(url, fit: BoxFit.contain),
      ),
    );
  }
}
