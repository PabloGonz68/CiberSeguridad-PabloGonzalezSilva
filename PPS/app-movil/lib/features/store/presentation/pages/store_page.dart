// lib/features/store/presentation/pages/store_page.dart
// Catálogo de la tienda con búsqueda, filtros por categoría y grid de productos

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/config/app_theme.dart';
import '../../domain/entities/product.dart';

// ── Stub BLoC para compilación inmediata ──────────────────────────
// En producción: reemplazar con el StoreBloc real (ver store_bloc.dart)
class _StoreState {
  final bool isLoading;
  final List<Product> products;
  final String? error;
  final String selectedCategory;
  const _StoreState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.selectedCategory = 'Todos',
  });
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  // Datos de demostración (sustituir por BLoC)
  final List<Product> _demoProducts = const [
    Product(id: '1', name: 'Pienso Premium Adultos', description: 'Nutrición completa para perros adultos de todas las razas. Rico en proteínas y sin aditivos artificiales.', price: 45.99, imageUrl: 'https://placehold.co/400x300/1C2128/00BFA5?text=Pienso', category: 'Alimentación', inStock: true, stockCount: 24),
    Product(id: '2', name: 'Juguete Interactivo Kong', description: 'Estimula la inteligencia de tu mascota con este juguete resistente para rellenar con premios.', price: 18.50, imageUrl: 'https://placehold.co/400x300/1C2128/00BFA5?text=Juguete', category: 'Juguetes', inStock: true, stockCount: 12),
    Product(id: '3', name: 'Collar Antiparasitario', description: 'Protección de 8 meses contra pulgas, garrapatas y mosquitos. Resistente al agua.', price: 32.00, imageUrl: 'https://placehold.co/400x300/1C2128/00BFA5?text=Collar', category: 'Higiene', inStock: true, stockCount: 8),
    Product(id: '4', name: 'Transportín de Viaje', description: 'Cómodo y seguro para viajes. Homologado para cabina de avión. Talla M.', price: 89.95, imageUrl: 'https://placehold.co/400x300/1C2128/00BFA5?text=Transportín', category: 'Accesorios', inStock: false, stockCount: 0),
    Product(id: '5', name: 'Arena Aglomerante Premium', description: 'Para gatos exigentes. Control de olores 48h. Sin polvo.', price: 12.99, imageUrl: 'https://placehold.co/400x300/1C2128/00BFA5?text=Arena', category: 'Higiene', inStock: true, stockCount: 50),
    Product(id: '6', name: 'Vitaminas Articulaciones', description: 'Suplemento con glucosamina y condroitina para perros mayores. Formato golosina.', price: 27.40, imageUrl: 'https://placehold.co/400x300/1C2128/00BFA5?text=Vitaminas', category: 'Salud', inStock: true, stockCount: 30),
  ];

  final List<String> _categories = ['Todos', 'Alimentación', 'Juguetes', 'Higiene', 'Accesorios', 'Salud'];

  List<Product> get _filteredProducts {
    return _demoProducts.where((p) {
      final matchCategory = _selectedCategory == 'Todos' || p.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSearchBar(),
          _buildCategoryFilter(),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: AppTheme.backgroundDark,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tienda',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1117), Color(0xFF0D1117)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: TextField(
          controller: _searchController,
          // SEGURIDAD: Sin autocorrect en búsqueda (M4 - Input Validation)
          autocorrect: false,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Buscar productos...',
            hintStyle: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppTheme.textSecondary, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: AppTheme.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final isSelected = cat == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.primaryGradient : null,
                  color: isSelected ? null : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                  ),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;
    if (products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, color: AppTheme.textSecondary, size: 48),
              const SizedBox(height: 12),
              Text('Sin resultados para "$_searchQuery"',
                  style: GoogleFonts.inter(color: AppTheme.textSecondary)),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ProductCard(product: products[index]),
          childCount: products.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/home/store/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: AppTheme.surfaceColor,
                        highlightColor: AppTheme.borderColor,
                        child: Container(color: AppTheme.surfaceColor),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppTheme.surfaceColor,
                        child: const Icon(Icons.image_not_supported,
                            color: AppTheme.textSecondary),
                      ),
                    ),
                    if (!product.inStock)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Agotado',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info del producto
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.category,
                        style: GoogleFonts.inter(
                            color: AppTheme.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.3),
                    ),
                    const Spacer(),
                    Text(
                      '${product.price.toStringAsFixed(2)} €',
                      style: GoogleFonts.inter(
                          color: AppTheme.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
