class Pokemon {
  final String name;
  final int id;
  final String imageUrl;

  Pokemon({required this.name, required this.id, required this.imageUrl});

  factory Pokemon.fromApiMap(Map<String, dynamic> m) {
    final String url = m['url'] as String;
    // Extract numeric id from URL: https://pokeapi.co/api/v2/pokemon/1/
    final segments = url.split('/');
    final id = int.tryParse(segments[segments.length - 2]) ?? 0;
    final image = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    return Pokemon(name: m['name'] as String, id: id, imageUrl: image);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
        'imageUrl': imageUrl,
      };
}