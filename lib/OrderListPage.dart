import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouseproject/ProductDetailPage.dart';
import 'OrderDetailsPage.dart';
import 'CreateOrder.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<Map<String, dynamic>> orders = [];
  String? _branchName;
  List<Map<String, dynamic>> _orderItems = [];
  String orderDate = '';
  String note = '';

  Future<void> _loadOrderData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedOrders = prefs.getString('orders');
    if (storedOrders != null) {
      List<dynamic> decodedOrders = jsonDecode(storedOrders);
      List<Map<String, dynamic>> allOrders =
          List<Map<String, dynamic>>.from(decodedOrders);

      Map<String, dynamic>? selectedOrder = allOrders.firstWhere(
          (order) => order['orderId'] == order['orderId'],
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
  void initState() {
    super.initState();
    _loadBranchName();
    _loadOrderData();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedOrders = prefs.getString('orders');
    if (storedOrders != null) {
      List<dynamic> decodedOrders = jsonDecode(storedOrders);
      setState(() {
        orders = List<Map<String, dynamic>>.from(decodedOrders);
      });
    }
  }

  Future<void> _loadBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _branchName = prefs.getString('selectedBranch') ?? "Branch";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageTitle(),
            const SizedBox(height: 20),
            Expanded(child: _buildOrderList(context)),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Image.asset("assets/LRLogo1.png", height: 40),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateOrderPage(),
              ),
            ).then((_) {
              _loadOrders();
            });
          },
          icon: const Icon(
            Icons.home_outlined,
            size: 35,
            color: Color(0xFFA6802D),
          ),
        ),
      ],
    );
  }

  Widget _buildPageTitle() {
    return const Text(
      "Your Orders",
      style: TextStyle(
        color: Color(0xFFA6802D),
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
    );
  }

  Widget _buildOrderList(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, color: Colors.grey.shade400, size: 80),
            const SizedBox(height: 10),
            const Text("No orders available.",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(
          context,
          orderId: order['orderId'] ?? 'N/A',
          status: order['status'] ?? 'Pending',
          details: order['details'] ?? '',
          items: List<Map<String, dynamic>>.from(order['items'] ?? []),
          orderDate: order['orderDate'] ?? 'N/A',
          branchName: order['branchName'] ?? 'Branch',
          orderedBy: order['orderedBy'] ?? 'Ricci',
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context,
      {required String orderId,
      required String status,
      required String details,
      required List<Map<String, dynamic>> items,
      required String orderDate,
      required String branchName,
      required String orderedBy}) {
    final statusInfo = _getStatusInfo(status);

    return GestureDetector(
      onTap: () {
        if (items.isNotEmpty) {
          final itemWithOrderDetails = {
            ...items[0],
            'orderId': orderId,
            'orderDate': orderDate,
          };

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailPage(item: itemWithOrderDetails),
            ),
          ).then((_) {
            _loadOrders();
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFA6802D), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusInfo.icon, color: statusInfo.color, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #$orderId",
                        style: const TextStyle(
                          color: Color(0xFFA6802D),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("Date: $orderDate"),
                      Text("Branch: $branchName"),
                      Text("Ordered by: $orderedBy"),
                      const SizedBox(height: 4),
                      Text(details,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 14)),
                    ],
                  ),
                ),
                _buildStatusBadge(status, statusInfo.color),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Items: ${items.length}",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case 'Shipped':
        return StatusInfo(
          color: Colors.blueGrey,
          icon: Icons.local_shipping,
        );
      case 'Delivered':
        return StatusInfo(
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case 'Cancelled':
        return StatusInfo(
          color: Colors.redAccent,
          icon: Icons.cancel,
        );
      default:
        return StatusInfo(
          color: Color(0xFFA6802D),
          icon: Icons.pending,
        );
    }
  }
}

class StatusInfo {
  final Color color;
  final IconData icon;

  StatusInfo({required this.color, required this.icon});
}
