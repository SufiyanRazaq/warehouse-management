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
  final List<Map<String, dynamic>> _allItems = [
    {
      "title": "Women's Sandals",
      "styleNumber": "#1023",
      "barcode": "9876543210",
      "brand": "Urban Outfitters",
      "color": "Pink",
      "size": "41",
      "image": "assets/sandals.jpg",
      "price": "\$180"
    },
    {
      "title": "Women's Clothes",
      "styleNumber": "#1023",
      "barcode": "9876543210",
      "brand": "Urban Outfitters",
      "color": "Red",
      "size": "31",
      "image": "assets/clothes.jpg",
      "price": "\$100"
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];
  Map<String, dynamic>? _displayedItem;
  final Map<int, int> _itemQuantities = {};

  @override
  void initState() {
    super.initState();
    _displayedItem = null; // Initially, no item is displayed
    _filteredItems = [];
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredItems = [];
      } else {
        _filteredItems = _allItems.where((item) {
          return item["title"].toString().toLowerCase().contains(query) ||
              item["styleNumber"].toString().toLowerCase().contains(query) ||
              item["barcode"].toString().toLowerCase().contains(query) ||
              item["brand"].toString().toLowerCase().contains(query) ||
              item["color"].toString().toLowerCase().contains(query) ||
              item["size"].toString().toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _scanBarcode() async {
    if (_displayedItem != null &&
        _itemQuantities[_allItems.indexOf(_displayedItem!)] != 0) {
      _showAlreadySelectedDialog();
    } else {
      // Navigate to the dummy scanner screen
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScannerScreen()),
      );

      // Automatically select the first item after returning from scanner
      setState(() {
        _displayedItem = _allItems[0];
        _itemQuantities[_allItems.indexOf(_displayedItem!)] =
            1; // Set quantity to 1
      });

      // Show confirmation dialog
      _showItemSelectedDialog();
    }
  }

  void _showItemSelectedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Item Selected'),
        content: const Text('The first item has been selected automatically.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAlreadySelectedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Item Already Selected'),
        content: const Text(
            'You already have a selected item. Select a new item only if needed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _changeItemQuantity(int index, int delta) {
    setState(() {
      int newQuantity = (_itemQuantities[index] ?? 0) + delta;
      if (newQuantity <= 0) {
        _itemQuantities.remove(index); // Remove item if quantity reaches zero
      } else {
        _itemQuantities[index] = newQuantity;
      }
    });
  }

  bool get _isNextButtonEnabled {
    return _itemQuantities.values.any((quantity) => quantity > 0);
  }

  Future<void> _saveSelectedItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic>? selectedItemData;
    if (_displayedItem != null &&
        _itemQuantities[_allItems.indexOf(_displayedItem!)] != null &&
        _itemQuantities[_allItems.indexOf(_displayedItem!)]! > 0) {
      selectedItemData = {
        'selectedItem': _displayedItem,
        'quantity': _itemQuantities[_allItems.indexOf(_displayedItem!)]!,
      };
    }

    if (selectedItemData != null) {
      await prefs.setString('selectedItemData', jsonEncode(selectedItemData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Column(
                children: [
                  _buildPageTitle(),
                  const SizedBox(height: 20),
                  _buildSearchField(),
                  _buildSearchSuggestions(),
                  const SizedBox(height: 20),
                  if (_displayedItem != null &&
                      _itemQuantities[_allItems.indexOf(_displayedItem!)]! > 0)
                    _buildItemCard(_displayedItem!),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildNextButton(context), // Place Next button at the end
        ],
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
      actions: [
        IconButton(
          onPressed: _scanBarcode,
          icon: const Icon(
            Icons.qr_code_2_outlined,
            color: Color(0xFFA6802D),
            size: 30,
          ),
        ),
      ],
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

  Widget _buildSearchSuggestions() {
    if (_searchController.text.isEmpty || _filteredItems.isEmpty) {
      return const SizedBox();
    }

    return Container(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return ListTile(
            title: Text(item["title"]),
            subtitle: Text("Brand: ${item["brand"]}, Color: ${item["color"]}"),
            leading: Image.asset(item["image"], width: 50, height: 50),
            onTap: () => _selectItem(index),
          );
        },
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    int index = _allItems.indexOf(item);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFA6802D), width: 1.5),
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
                        item["title"],
                        style: const TextStyle(
                          color: Color(0xFFA6802D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Style Number: ${item["styleNumber"]}"),
                      Text("Barcode: ${item["barcode"]}"),
                      Text("Brand: ${item["brand"]}"),
                      Text("Color: ${item["color"]}"),
                      Text("Size: ${item["size"]}"),
                      Text("Price: ${item["price"]}"),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Image.asset(item["image"], height: 100, width: 100),
              ],
            ),
            const SizedBox(height: 8),
            _buildQuantityControl(index),
          ],
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
              color: const Color(0xFFA6802D).withOpacity(0.1),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isNextButtonEnabled
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
      ),
    );
  }

  void _selectItem(int index) {
    setState(() {
      _displayedItem = _filteredItems[index];
      _itemQuantities[_allItems.indexOf(_displayedItem!)] = 1;
      _searchController.clear();
      _filteredItems = [];
    });
  }
}

// Dummy scanner screen that closes itself after a delay
class ScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_2_outlined, color: Colors.white, size: 150),
            SizedBox(height: 20),
            Text(
              "Scanning...",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
