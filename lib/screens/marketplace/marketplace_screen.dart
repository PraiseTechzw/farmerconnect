import 'package:flutter/material.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isFilterOpen = false;

  final List<String> _categories = [
    'All',
    'Crops',
    'Equipment',
    'Seeds',
    'Fertilizers',
    'Tools',
    'Livestock',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(text: 'Featured'),
                  Tab(text: 'New Arrivals'),
                  Tab(text: 'Best Sellers'),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: [
            _buildCategoryFilter(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProductGrid('Featured'),
                  _buildProductGrid('New Arrivals'),
                  _buildProductGrid('Best Sellers'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isFilterOpen = !_isFilterOpen;
          });
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.green[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.green[700] : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(String section) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildProductCard(index);
      },
    );
  }

  Widget _buildProductCard(int index) {
    final product = _getProductDetails(index);
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                const SizedBox(height: 4),
                Text(
                  product['category'] as String,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['price'] as String,
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        size: 16,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getProductDetails(int index) {
    final products = [
      {
        'name': 'Organic Wheat Seeds',
        'category': 'Seeds',
        'price': '\$24.99',
        'icon': Icons.grain,
      },
      {
        'name': 'Premium Fertilizer',
        'category': 'Fertilizers',
        'price': '\$49.99',
        'icon': Icons.spa,
      },
      {
        'name': 'Tractor Attachment',
        'category': 'Equipment',
        'price': '\$299.99',
        'icon': Icons.agriculture,
      },
      {
        'name': 'Garden Tools Set',
        'category': 'Tools',
        'price': '\$79.99',
        'icon': Icons.handyman,
      },
      {
        'name': 'Organic Pesticide',
        'category': 'Fertilizers',
        'price': '\$34.99',
        'icon': Icons.eco,
      },
      {
        'name': 'Drip Irrigation Kit',
        'category': 'Equipment',
        'price': '\$89.99',
        'icon': Icons.water_drop,
      },
      {
        'name': 'Hybrid Corn Seeds',
        'category': 'Seeds',
        'price': '\$29.99',
        'icon': Icons.eco,
      },
      {
        'name': 'Pruning Shears',
        'category': 'Tools',
        'price': '\$19.99',
        'icon': Icons.content_cut,
      },
      {
        'name': 'Soil Testing Kit',
        'category': 'Tools',
        'price': '\$44.99',
        'icon': Icons.science,
      },
      {
        'name': 'Chicken Feed',
        'category': 'Livestock',
        'price': '\$39.99',
        'icon': Icons.pets,
      },
    ];
    return products[index % products.length];
  }
} 