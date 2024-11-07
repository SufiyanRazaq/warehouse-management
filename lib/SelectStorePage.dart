import 'package:flutter/material.dart';
import 'package:warehouseproject/SelectItemsPage.dart';

class SelectStorePage extends StatelessWidget {
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
            const SizedBox(height: 30),
            _buildSearchField(),
            const SizedBox(height: 30),
            Expanded(child: _buildStoreList(context)),
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
      "Select Store",
      style: TextStyle(
        color: Color(0xFFA6802D),
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search for a store...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFA6802D)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFFA6802D), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
        ),
        style: const TextStyle(color: Color(0xFFA6802D)),
      ),
    );
  }

  Widget _buildStoreList(BuildContext context) {
    return ListView(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SelectItemsPage()),
            );
          },
          child: _buildStoreCard(
            context,
            storeId: "Store Id: 6576",
            storeName: "Premium Outlet",
            location: "Downtown Area",
            isHighlighted: true,
            icon: Icons.store,
          ),
        ),
        const SizedBox(height: 12),
        _buildStoreCard(
          context,
          storeId: "Store Id: 6577",
          storeName: "Local Mart",
          location: "Uptown Plaza",
          icon: Icons.shopping_cart,
        ),
        const SizedBox(height: 12),
        _buildStoreCard(
          context,
          storeId: "Store Id: 6578",
          storeName: "Grocery King",
          location: "City Square",
          icon: Icons.local_grocery_store,
        ),
      ],
    );
  }

  Widget _buildStoreCard(
    BuildContext context, {
    required String storeId,
    required String storeName,
    required String location,
    bool isHighlighted = false,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SelectItemsPage()),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFFFFF5E5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFA6802D),
            width: isHighlighted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFA6802D).withOpacity(0.1),
              child: Icon(icon, color: const Color(0xFFA6802D)),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildStoreInfo(storeId, storeName, location)),
            Icon(Icons.chevron_right, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreInfo(String storeId, String storeName, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          storeId,
          style: const TextStyle(
            color: Color(0xFFA6802D),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          storeName,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          location,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
