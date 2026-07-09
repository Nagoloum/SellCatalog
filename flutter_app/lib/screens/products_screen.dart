import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../services/api_service.dart';
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
  final _apiService = ApiService();
  final _sessionService = SessionService();

  late Future<_ProductsPageData> _pageDataFuture;
  AppUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _pageDataFuture = _loadPageData();
  }

  Future<_ProductsPageData> _loadPageData() async {
    // Recuperation de la session locale puis appel API du catalogue.
    final user = await _sessionService.getUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
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
          body: _ProductsBody(snapshot: snapshot, onRetry: _reloadProducts),
        );
      },
    );
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody({required this.snapshot, required this.onRetry});

  final AsyncSnapshot<_ProductsPageData> snapshot;
  final Future<void> Function() onRetry;

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

    return RefreshIndicator(
      onRefresh: onRetry,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _ProductListItem(product: products[index]);
        },
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  const _ProductListItem({required this.product});

  final Product product;

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
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed(ProductDetailScreen.routeName, arguments: product);
        },
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
                      _formatPrice(product.prix),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2).replaceAll('.', ',')} EUR';
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

class _ProductsPageData {
  const _ProductsPageData({required this.user, required this.products});

  final AppUser? user;
  final List<Product> products;
}
