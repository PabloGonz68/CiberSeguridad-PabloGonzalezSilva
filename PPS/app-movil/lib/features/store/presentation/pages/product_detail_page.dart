// lib/features/store/presentation/pages/product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/config/app_theme.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  // Simula carga del producto (en producción: BLoC + UseCase)
  Product _demoProduct() => Product(
        id: productId,
        name: 'Pienso Premium Adultos',
        description: 'Nutrición completa formulada por veterinarios para perros adultos de todas las razas. '
            'Con proteínas de alta calidad (pollo y salmón), sin colorantes ni conservantes artificiales. '
            'Enriquecido con Omega-3 y Omega-6 para una piel y pelaje saludables.',
        price: 45.99,
        imageUrl: 'https://placehold.co/800x500/1C2128/00BFA5?text=Pienso+Premium',
        category: 'Alimentación',
        inStock: true,
        stockCount: 24,
      );

  @override
  Widget build(BuildContext context) {
    final product = _demoProduct();
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // Hero image con AppBar transparente
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.backgroundDark,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: AppTheme.surfaceColor,
                  child: const Icon(Icons.image_not_supported,
                      color: AppTheme.textSecondary, size: 60),
                ),
              ),
            ),
          ),
          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría + disponibilidad
                  Row(
                    children: [
                      _Chip(label: product.category, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      _Chip(
                        label: product.inStock ? 'Disponible' : 'Agotado',
                        color: product.inStock ? AppTheme.successColor : AppTheme.errorColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${product.price.toStringAsFixed(2)} €',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppTheme.borderColor),
                  const SizedBox(height: 16),
                  Text(
                    'Descripción',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Info de stock
                  if (product.inStock)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined,
                              color: AppTheme.successColor, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            '${product.stockCount} unidades disponibles',
                            style: GoogleFonts.inter(
                              color: AppTheme.successColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Nota de seguridad: redirigir a pasarela externa
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined,
                            color: AppTheme.primaryColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'El pago se procesa de forma segura en nuestra web. '
                            'Nunca introducirás datos bancarios en la app.',
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Botón CTA — redirige a la web para completar el pedido
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: product.inStock
                            ? AppTheme.primaryGradient
                            : null,
                        color: product.inStock ? null : AppTheme.borderColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: product.inStock
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: product.inStock ? () {
                          // TODO: Abrir URL de la tienda web con el producto
                          // url_launcher → openUrl(ApiConstants.baseUrl/store/product.id)
                        } : null,
                        icon: const Icon(Icons.open_in_browser, size: 18),
                        label: Text(
                          product.inStock
                              ? 'Comprar en la web'
                              : 'Sin stock',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
            color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
