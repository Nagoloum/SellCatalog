import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../services/session_service.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static const String routeName = '/products';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const String _allCategories = 'Toutes';

  final _apiService = ApiService();
  final _sessionService = SessionService();
  final _favoritesService = FavoritesService();
  final _searchController = TextEditingController();

  late Future<_ProductsPageData> _pageDataFuture;
  AppUser? _currentUser;
  Set<int> _favoriteIds = {};
  String _selectedCategory = _allCategories;
  bool _onlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _pageDataFuture = _loadPageData();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<_ProductsPageData> _loadPageData() async {
    // Recuperation de la session locale, du catalogue et des favoris.
    final user = await _sessionService.getUser();
    final favoriteIds = await _favoritesService.getFavoriteIds();

    if (mounted) {
      setState(() {
        _currentUser = user;
        _favoriteIds = favoriteIds;
      });
    }

    final products = await _apiService.fetchProducts();
    return _ProductsPageData(user: user, products: products);
  }

  Future<void> _reloadProducts() async {
    final future = _loadPageData();
    setState(() {
      _pageDataFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // L'etat erreur est affiche par le FutureBuilder.
    }
  }

  Future<void> _reloadFavorites() async {
    final favoriteIds = await _favoritesService.getFavoriteIds();

    if (mounted) {
      setState(() {
        _favoriteIds = favoriteIds;
      });
    }
  }

  Future<void> _toggleFavorite(int productId) async {
    final favoriteIds = await _favoritesService.toggleFavorite(productId);

    if (mounted) {
      setState(() {
        _favoriteIds = favoriteIds;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _sessionService.clear();

    if (!context.mounted) {
      return;
    }

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ProductsPageData>(
      future: _pageDataFuture,
      builder: (context, snapshot) {
        final user = snapshot.data?.user ?? _currentUser;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              user == null ? 'Ventes privees' : 'Bonjour ${user.prenom}',
            ),
            actions: [
              IconButton(
                tooltip: 'Se deconnecter',
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: _ProductsBody(
            snapshot: snapshot,
            searchController: _searchController,
            selectedCategory: _selectedCategory,
            onlyFavorites: _onlyFavorites,
            favoriteIds: _favoriteIds,
            onRetry: _reloadProducts,
            onCategoryChanged: (category) {
              setState(() {
                _selectedCategory = category ?? _allCategories;
              });
            },
            onOnlyFavoritesChanged: (value) {
              setState(() {
                _onlyFavorites = value;
              });
            },
            onToggleFavorite: _toggleFavorite,
            onDetailClosed: _reloadFavorites,
          ),
        );
      },
    );
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody({
    required this.snapshot,
    required this.searchController,
    required this.selectedCategory,
    required this.onlyFavorites,
    required this.favoriteIds,
    required this.onRetry,
    required this.onCategoryChanged,
    required this.onOnlyFavoritesChanged,
    required this.onToggleFavorite,
    required this.onDetailClosed,
  });

  static const String _allCategories = 'Toutes';

  final AsyncSnapshot<_ProductsPageData> snapshot;
  final TextEditingController searchController;
  final String selectedCategory;
  final bool onlyFavorites;
  final Set<int> favoriteIds;
  final Future<void> Function() onRetry;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<bool> onOnlyFavoritesChanged;
  final Future<void> Function(int productId) onToggleFavorite;
  final Future<void> Function() onDetailClosed;

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return _ProductsError(onRetry: onRetry);
    }

    final products = snapshot.data?.products ?? [];

    if (products.isEmpty) {
      return const _EmptyProducts();
    }

    final categories = products.map((product) => product.categorie).toSet()
      ..removeWhere((category) => category.trim().isEmpty);
    final sortedCategories = categories.toList()..sort();
    final filteredProducts = _filterProducts(products);

    return RefreshIndicator(
      onRefresh: onRetry,
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _ProductsFilters(
            searchController: searchController,
            categories: sortedCategories,
            selectedCategory: selectedCategory,
            onlyFavorites: onlyFavorites,
            onCategoryChanged: onCategoryChanged,
            onOnlyFavoritesChanged: onOnlyFavoritesChanged,
          ),
          const SizedBox(height: 16),
          if (filteredProducts.isEmpty)
            const _FilteredProductsEmpty()
          else
            for (final product in filteredProducts) ...[
              _ProductListItem(
                product: product,
                isFavorite: favoriteIds.contains(product.id),
                onToggleFavorite: () => onToggleFavorite(product.id),
                onOpenDetail: () async {
                  await Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: product,
                  );
                  await onDetailClosed();
                },
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  List<Product> _filterProducts(List<Product> products) {
    final query = searchController.text.trim().toLowerCase();

    return products.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product.titre.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      final matchesCategory =
          selectedCategory == _allCategories ||
          product.categorie == selectedCategory;
      final matchesFavorite =
          !onlyFavorites || favoriteIds.contains(product.id);

      return matchesSearch && matchesCategory && matchesFavorite;
    }).toList();
  }
}

class _ProductsFilters extends StatelessWidget {
  const _ProductsFilters({
    required this.searchController,
    required this.categories,
    required this.selectedCategory,
    required this.onlyFavorites,
    required this.onCategoryChanged,
    required this.onOnlyFavoritesChanged,
  });

  static const String _allCategories = 'Toutes';

  final TextEditingController searchController;
  final List<String> categories;
  final String selectedCategory;
  final bool onlyFavorites;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<bool> onOnlyFavoritesChanged;

  @override
  Widget build(BuildContext context) {
    final categoryValue = categories.contains(selectedCategory)
        ? selectedCategory
        : _allCategories;

    return Column(
      children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Rechercher',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Effacer la recherche',
                    onPressed: searchController.clear,
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: ValueKey(categoryValue),
          initialValue: categoryValue,
          decoration: const InputDecoration(
            labelText: 'Categorie',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: [
            const DropdownMenuItem(
              value: _allCategories,
              child: Text(_allCategories),
            ),
            for (final category in categories)
              DropdownMenuItem(value: category, child: Text(category)),
          ],
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          value: onlyFavorites,
          onChanged: onOnlyFavoritesChanged,
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.favorite),
          title: const Text('Favoris uniquement'),
        ),
      ],
    );
  }
}

class _ProductListItem extends StatelessWidget {
  const _ProductListItem({
    required this.product,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onOpenDetail,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpenDetail,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 88,
                      height: 88,
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.titre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.categorie,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.formattedPrice,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: isFavorite
                        ? 'Retirer des favoris'
                        : 'Ajouter aux favoris',
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: colorScheme.primary,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colorScheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductsError extends StatelessWidget {
  const _ProductsError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 54,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger les produits.',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Verifiez que le serveur Python est lance, puis reessayez.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => onRetry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Aucun produit disponible pour le moment.'),
    );
  }
}

class _FilteredProductsEmpty extends StatelessWidget {
  const _FilteredProductsEmpty();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(child: Text('Aucun produit ne correspond aux filtres.')),
    );
  }
}

class _ProductsPageData {
  const _ProductsPageData({required this.user, required this.products});

  final AppUser? user;
  final List<Product> products;
}
