import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _priceRange = const RangeValues(0, 1000);
  final List<String> _selectedCategories = [];
  String _sortBy = 'Popularity';
  bool _inStockOnly = false;
  bool _organicOnly = false;

  final List<String> _categories = [
    'Crops',
    'Equipment',
    'Seeds',
    'Fertilizers',
    'Tools',
    'Livestock',
  ];

  final List<String> _sortOptions = [
    'Popularity',
    'Price: Low to High',
    'Price: High to Low',
    'Newest First',
    'Best Rated',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Products'),
        actions: [
          TextButton(
            onPressed: () {
              // Reset all filters
              setState(() {
                _priceRange = const RangeValues(0, 1000);
                _selectedCategories.clear();
                _sortBy = 'Popularity';
                _inStockOnly = false;
                _organicOnly = false;
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPriceRangeFilter(),
          const Divider(height: 32),
          _buildCategoryFilter(),
          const Divider(height: 32),
          _buildSortByFilter(),
          const Divider(height: 32),
          _buildOtherFilters(),
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
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Apply filters
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${_priceRange.start.round()}'),
            Text('\$${_priceRange.end.round()}'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.green[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.green[700] : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortByFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sort By',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._sortOptions.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _sortBy,
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOtherFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Other Filters',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('In Stock Only'),
          value: _inStockOnly,
          onChanged: (value) {
            setState(() {
              _inStockOnly = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Organic Products Only'),
          value: _organicOnly,
          onChanged: (value) {
            setState(() {
              _organicOnly = value;
            });
          },
        ),
      ],
    );
  }
} 