import 'package:flutter/material.dart';
import 'package:warehouseproject/CreateOrder.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  ProductDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Soft background color
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Color(0xFFA6802D),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFA6802D)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageCarousel([item['image'] ?? 'assets/1.jpg']),
              const SizedBox(height: 16),
              _buildProductInfo(
                orderId: item['orderId'] ?? 'N/A',
                status: item['status'] ?? 'Active',
                title: item['title'] ?? 'Untitled',
                description: item['details'] ??
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                styleNumber: item['styleNumber'] ?? 'N/A',
                barcode: item['barcode'] ?? 'N/A',
                brand: item['brand'] ?? 'Unknown',
                color: item['color'] ?? 'N/A',
                size: item['size'] ?? 'N/A',
                orderDate: item['orderDate'] ?? 'Unknown',
                note: item['note'] ?? 'No notes available',
              ),
              const SizedBox(height: 20),
              _buildPriceAndQuantityInfo(item['price'], item['quantity'] ?? 1),
              const SizedBox(height: 24),
              _buildActionButton(context), // New button for interaction
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo({
    required String orderId,
    required String status,
    required String title,
    required String description,
    required String styleNumber,
    required String barcode,
    required String brand,
    required String color,
    required String size,
    required String orderDate,
    required String note,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFA6802D),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 8),
          _buildInfoRow("Order ID", orderId),
          _buildInfoRow("Status", status),
          _buildInfoRow("Order Date", orderDate),
          _buildInfoRow("Style Number", styleNumber),
          _buildInfoRow("Barcode", barcode),
          _buildInfoRow("Brand", brand),
          _buildInfoRow("Color", color),
          _buildInfoRow("Size", size),
          _buildInfoRow("Order By", "Ricci"),
          const SizedBox(height: 12),
          Text(
            'Note: $note',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndQuantityInfo(dynamic price, int quantity) {
    double parsedPrice;
    if (price is String) {
      parsedPrice =
          double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    } else if (price is double) {
      parsedPrice = price;
    } else {
      parsedPrice = 0.0;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 8,
      color: const Color.fromARGB(255, 243, 230, 202),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quantity: $quantity",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Total: \$${(parsedPrice * quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFA6802D),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Price per item: \$${parsedPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFA6802D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return Container(
      height: 220,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateOrderPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA6802D),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
        ),
        child: const Text(
          "Back to Home",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
