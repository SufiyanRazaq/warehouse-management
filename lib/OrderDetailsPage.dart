import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProductDetailPage.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  OrderDetailsPage({required this.orderId});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  List<Map<String, dynamic>> _orderItems = [];
  String orderDate = '';
  String note = '';

  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }

  Future<void> _loadOrderData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedOrders = prefs.getString('orders');
    if (storedOrders != null) {
      List<dynamic> decodedOrders = jsonDecode(storedOrders);
      List<Map<String, dynamic>> allOrders =
          List<Map<String, dynamic>>.from(decodedOrders);

      Map<String, dynamic>? selectedOrder = allOrders.firstWhere(
          (order) => order['orderId'] == widget.orderId,
          orElse: () => {});

      if (selectedOrder.isNotEmpty && selectedOrder.containsKey('items')) {
        setState(() {
          orderDate = selectedOrder['orderDate'] ?? 'Unknown';
          note = selectedOrder['note'] ?? 'No notes available';

          _orderItems = List<Map<String, dynamic>>.from(selectedOrder['items'])
              .map((item) => {
                    ...item,
                    'orderId': selectedOrder['orderId'],
                    'orderDate': orderDate,
                    'note': note,
                  })
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order #${widget.orderId}',
          style: const TextStyle(
              color: Color(0xFFA6802D), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFA6802D)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade100, Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 20),
            Expanded(child: _buildOrderItemList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    double total = _orderItems.fold(0, (sum, item) {
      double price = (item['price'] is String)
          ? double.tryParse(item['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ??
              0.0
          : (item['price'] ?? 0.0).toDouble();
      int quantity = item['quantity'] ?? 1;
      return sum + (price * quantity);
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFA6802D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFA6802D),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Order Date: $orderDate",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            "Note: $note",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemList(BuildContext context) {
    if (_orderItems.isEmpty) {
      return const Center(
        child: Text(
          "No items available in this order.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: _orderItems.length,
      itemBuilder: (context, index) {
        final item = _orderItems[index];
        double price = (item['price'] is String)
            ? double.tryParse(
                    item['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0.0
            : (item['price'] ?? 0.0).toDouble();
        int quantity = item['quantity'] ?? 1;
        double itemTotal = price * quantity;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        AssetImage(item['image'] ?? "assets/default.png"),
                  ),
                  title: Text(
                    item['title'] ?? "Untitled",
                    style: const TextStyle(
                        color: Color(0xFFA6802D),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  subtitle: Text(
                    'Size: ${item['size'] ?? "N/A"}, Color: ${item['color'] ?? "N/A"}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity: $quantity',
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 14),
                    ),
                    Text(
                      '\$${itemTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFFA6802D),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(item: item),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA6802D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
