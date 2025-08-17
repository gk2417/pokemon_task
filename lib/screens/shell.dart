import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'favorites_page.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().start();
    });
  }

  @override
  void dispose() {
    context.read<FavoritesProvider>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [HomePage(), FavoritesPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.catching_pokemon), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
