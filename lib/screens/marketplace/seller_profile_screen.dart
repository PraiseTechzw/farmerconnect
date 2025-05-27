import 'package:flutter/material.dart';

class SellerProfileScreen extends StatelessWidget {
  final String sellerName;
  final double rating;
  final int totalSales;
  final int totalProducts;

  const SellerProfileScreen({
    super.key,
    required this.sellerName,
    required this.rating,
    required this.totalSales,
    required this.totalProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.green[700]!,
                      Colors.green[500]!,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.store,
                          size: 40,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        sellerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSellerStats(),
                  const SizedBox(height: 24),
                  _buildSellerDescription(),
                  const SizedBox(height: 24),
                  _buildSellerProducts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          Icons.star,
          rating.toString(),
          'Rating',
        ),
        _buildStatItem(
          Icons.shopping_cart,
          totalSales.toString(),
          'Sales',
        ),
        _buildStatItem(
          Icons.inventory,
          totalProducts.toString(),
          'Products',
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.green[700],
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSellerDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Seller',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'AgriTech Store is a trusted supplier of high-quality agricultural products. We specialize in organic seeds, premium fertilizers, and professional farming equipment. Our commitment to quality and customer satisfaction has made us a leading provider in the agricultural industry.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSellerProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildProductCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(int index) {
    final products = [
      {
        'name': 'Organic Wheat Seeds',
        'price': '\$24.99',
        'icon': Icons.grain,
      },
      {
        'name': 'Premium Fertilizer',
        'price': '\$49.99',
        'icon': Icons.spa,
      },
      {
        'name': 'Garden Tools Set',
        'price': '\$79.99',
        'icon': Icons.handyman,
      },
      {
        'name': 'Organic Pesticide',
        'price': '\$34.99',
        'icon': Icons.eco,
      },
    ];

    final product = products[index];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Icon(
                  product['icon'] as IconData,
                  size: 50,
                  color: Colors.green[700],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  product['price'] as String,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
