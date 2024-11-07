import 'package:flutter/material.dart';
import 'DateOrderPage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SelectItemsPage extends StatefulWidget {
  @override
  _SelectItemsPageState createState() => _SelectItemsPageState();
}

class _SelectItemsPageState extends State<SelectItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allItems = [
    {
      "title": "Vintage Leather Jacket",
      "styleNumber": "#1023",
      "barcode": "9876543210",
      "brand": "Urban Outfitters",
      "color": "Brown",
      "size": "M",
      "image": "assets/1.jpg",
      "price": "\$180"
    },
    {
      "title": "Classic Denim Jeans",
      "styleNumber": "#2048",
      "barcode": "1234567890",
      "brand": "Levi's",
      "color": "Blue",
      "size": "32",
      "image": "assets/1.jpg",
      "price": "\$80"
    },
  ];
  List<Map<String, dynamic>> _filteredItems = [];
  int? _selectedIndex;
  Map<int, int> _itemQuantities = {};

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredItems = _allItems.where((item) {
        return item["title"].toString().toLowerCase().contains(query) ||
            item["styleNumber"].toString().toLowerCase().contains(query) ||
            item["barcode"].toString().toLowerCase().contains(query) ||
            item["brand"].toString().toLowerCase().contains(query) ||
            item["color"].toString().toLowerCase().contains(query) ||
            item["size"].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  void _selectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeItemQuantity(int index, int delta) {
    setState(() {
      _itemQuantities[index] = (_itemQuantities[index] ?? 0) + delta;
      if (_itemQuantities[index]! < 0) _itemQuantities[index] = 0;
    });
  }

  Future<void> _saveSelectedItemData() async {
    if (_selectedIndex != null && (_itemQuantities[_selectedIndex!] ?? 0) > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Create a map of selected item details
      Map<String, dynamic> selectedItemData = {
        'selectedItem': _filteredItems[_selectedIndex!],
        'quantity': _itemQuantities[_selectedIndex!]
      };

      // Save the selected item to SharedPreferences
      await prefs.setString('selectedItemData', jsonEncode(selectedItemData));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        decoration: _buildBackgroundGradient(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            _buildPageTitle(),
            const SizedBox(height: 20),
            _buildSearchField(),
            const SizedBox(height: 20),
            Expanded(child: _buildItemsList()),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFA6802D)),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Image.asset("assets/LRLogo1.png", height: 40),
      centerTitle: true,
    );
  }

  BoxDecoration _buildBackgroundGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.grey.shade200],
      ),
    );
  }

  Widget _buildPageTitle() {
    return const Text(
      "Select Items",
      style: TextStyle(
        color: Color(0xFFA6802D),
        fontWeight: FontWeight.bold,
        fontSize: 26,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search for items...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFA6802D)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Color(0xFFA6802D), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
        ),
        style: const TextStyle(color: Color(0xFFA6802D)),
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = index == _selectedIndex;
        return _buildItemCard(
          index,
          item["title"],
          item["styleNumber"],
          item["barcode"],
          item["brand"],
          item["color"],
          item["size"],
          item["image"],
          item["price"],
          isSelected,
        );
      },
    );
  }

  Widget _buildItemCard(
    int index,
    String title,
    String styleNumber,
    String barcode,
    String brand,
    String color,
    String size,
    String image,
    String price,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _selectItem(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF8E1) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFA6802D),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFFA6802D),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildItemDetail("Style Number", styleNumber),
                        _buildItemDetail("Barcode", barcode),
                        _buildItemDetail("Brand", brand),
                        _buildItemDetail("Color", color),
                        _buildItemDetail("Size", size),
                        _buildItemDetail("Price", price),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildItemImage(image),
                ],
              ),
              const SizedBox(height: 8),
              _buildQuantityControl(
                  index), // Add quantity control for each item
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              color: Color(0xFFA6802D),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(String imagePath) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildQuantityControl(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => _changeItemQuantity(index, -1),
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Color(0xFFA6802D),
              size: 28,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFA6802D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "${_itemQuantities[index] ?? 0}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA6802D),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _changeItemQuantity(index, 1),
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFFA6802D),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedIndex != null &&
                (_itemQuantities[_selectedIndex!] ?? 0) > 0
            ? () async {
                await _saveSelectedItemData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DateOrderPage(),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6802D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          shadowColor: Colors.grey.shade400,
        ),
        child: const Text(
          "Next",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Similarly, update DateOrderPage and LoginScreen to use SharedPreferences for saving order details and adding consistency in passing and storing data between pages.
