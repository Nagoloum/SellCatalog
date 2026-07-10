import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_product_ids';

  Future<Set<int>> getFavoriteIds() async {
    final preferences = await SharedPreferences.getInstance();
    final rawIds = preferences.getStringList(_favoritesKey) ?? [];

    return rawIds.map(int.tryParse).whereType<int>().toSet();
  }

  Future<bool> isFavorite(int productId) async {
    final favoriteIds = await getFavoriteIds();
    return favoriteIds.contains(productId);
  }

  Future<Set<int>> toggleFavorite(int productId) async {
    final preferences = await SharedPreferences.getInstance();
    final favoriteIds = await getFavoriteIds();

    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }

    final rawIds = favoriteIds.map((id) => id.toString()).toList()..sort();
    await preferences.setStringList(_favoritesKey, rawIds);

    return favoriteIds;
  }
}
