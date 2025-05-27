import 'package:flutter/material.dart';
import 'package:farmer_connect/screens/marketplace/seller_profile_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
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
                  child: Icon(
                    widget.product['icon'] as IconData,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product['name'] as String,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.product['category'] as String,
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product['price'] as String,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getProductDescription(widget.product['name'] as String),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Specifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSpecificationsList(widget.product['name'] as String),
                  const SizedBox(height: 24),
                  const Text(
                    'Seller Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSellerInfo(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Add to cart functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Buy now functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getProductDescription(String productName) {
    final descriptions = {
      'Organic Wheat Seeds': 'High-quality organic wheat seeds perfect for sustainable farming. These seeds are certified organic and have a high germination rate. Ideal for both small-scale and large-scale farming operations.',
      'Premium Fertilizer': 'Advanced formula fertilizer that provides essential nutrients for optimal plant growth. Contains balanced NPK ratio and micronutrients for healthy crop development.',
      'Tractor Attachment': 'Versatile tractor attachment compatible with most standard tractor models. Made from high-quality materials for durability and long-lasting performance.',
      'Garden Tools Set': 'Complete set of essential gardening tools including trowel, pruner, rake, and more. Ergonomic design for comfortable use during long gardening sessions.',
      'Organic Pesticide': 'Natural and eco-friendly pesticide that effectively controls pests while being safe for plants and the environment. Made from organic ingredients.',
      'Drip Irrigation Kit': 'Efficient water-saving irrigation system that delivers water directly to plant roots. Includes all necessary components for easy installation.',
      'Hybrid Corn Seeds': 'High-yield hybrid corn seeds with excellent disease resistance. Perfect for maximizing crop production in various climate conditions.',
      'Pruning Shears': 'Professional-grade pruning shears with sharp, durable blades. Comfortable grip and precise cutting for perfect pruning results.',
      'Soil Testing Kit': 'Comprehensive soil testing kit that measures pH, nitrogen, phosphorus, and potassium levels. Essential for maintaining optimal soil conditions.',
      'Chicken Feed': 'Nutritionally balanced feed for healthy chicken growth and egg production. Contains essential vitamins and minerals for poultry health.',
    };
    return descriptions[productName] ?? 'No description available.';
  }

  Widget _buildSpecificationsList(String productName) {
    final specifications = {
      'Organic Wheat Seeds': [
        'Germination Rate: 95%',
        'Purity: 99.9%',
        'Moisture Content: < 13%',
        'Shelf Life: 12 months',
      ],
      'Premium Fertilizer': [
        'NPK Ratio: 10-10-10',
        'Weight: 25kg',
        'Coverage: 1000 sq ft',
        'Organic Certified',
      ],
      'Tractor Attachment': [
        'Material: High-grade steel',
        'Weight: 150kg',
        'Compatibility: Universal',
        'Warranty: 2 years',
      ],
      'Garden Tools Set': [
        'Tools Included: 8 pieces',
        'Material: Stainless steel',
        'Handle: Ergonomic grip',
        'Storage: Included case',
      ],
      'Organic Pesticide': [
        'Volume: 1 liter',
        'Coverage: 500 sq ft',
        'Organic Certified',
        'Safe for all plants',
      ],
      'Drip Irrigation Kit': [
        'Coverage: 100 sq ft',
        'Components: 50 pieces',
        'Pressure: 15-30 PSI',
        'Installation: Easy setup',
      ],
      'Hybrid Corn Seeds': [
        'Germination Rate: 90%',
        'Maturity: 90 days',
        'Yield: High',
        'Disease Resistant',
      ],
      'Pruning Shears': [
        'Blade Length: 8 inches',
        'Material: Carbon steel',
        'Weight: 200g',
        'Lifetime warranty',
      ],
      'Soil Testing Kit': [
        'Tests: pH, NPK',
        'Accuracy: 99%',
        'Results: Instant',
        'Reusable: Yes',
      ],
      'Chicken Feed': [
        'Weight: 20kg',
        'Protein: 16%',
        'Shelf Life: 6 months',
        'Age: All stages',
      ],
    };

    final specs = specifications[productName] ?? ['No specifications available'];
    return Column(
      children: specs.map((spec) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[700],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              spec,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildSellerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[100],
            child: Icon(
              Icons.store,
              size: 30,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AgriTech Store',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Verified Seller • 4.8 ★',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SellerProfileScreen(
                    sellerName: 'AgriTech Store',
                    rating: 4.8,
                    totalSales: 1234,
                    totalProducts: 56,
                  ),
                ),
              );
            },
            child: const Text('View Profile'),
          ),
        ],
      ),
    );
  }
} 