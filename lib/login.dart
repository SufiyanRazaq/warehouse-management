import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OrderConfirmationPage.dart';

class LoginScreen extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> selectedItem;
  final int quantity;
  final DateTime orderDate;
  final String note;

  LoginScreen({
    required this.orderId,
    required this.selectedItem,
    required this.quantity,
    required this.orderDate,
    required this.note,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userPinController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _saveOrderData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> orderData = {
      'orderId': widget.orderId,
      'status': 'Pending',
      'details': 'Order is being processed',
      'items': [
        {
          'title': widget.selectedItem['title'],
          'styleNumber': widget.selectedItem['styleNumber'],
          'barcode': widget.selectedItem['barcode'],
          'brand': widget.selectedItem['brand'],
          'color': widget.selectedItem['color'],
          'size': widget.selectedItem['size'],
          'image': widget.selectedItem['image'],
          'quantity': widget.quantity,
          'price': widget.selectedItem['price'] ?? 0.0,
        }
      ],
      'orderDate': DateFormat('yyyy-MM-dd').format(widget.orderDate),
      'note': widget.note,
    };

    String? storedOrders = prefs.getString('orders');
    List<dynamic> orderList =
        storedOrders != null ? jsonDecode(storedOrders) : [];
    orderList.add(orderData);

    await prefs.setString('orders', jsonEncode(orderList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: _buildBackButton(context),
                ),
                const SizedBox(height: 10),
                Center(child: _buildLogo()),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: _userIdController,
                  hintText: "User ID",
                  icon: Icons.person,
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _userPinController,
                  hintText: "User Pin",
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 40),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFA6802D)),
      padding: const EdgeInsets.all(8.0),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFA6802D).withOpacity(0.1),
      ),
      child: Image.asset(
        "assets/LRLogo.png",
        height: 150,
        width: 150,
        color: const Color(0xFFA6802D),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Staff Details",
      style: TextStyle(
        color: Color(0xFFA6802D),
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
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
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: const Color(0xFFA6802D)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFFA6802D),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFFA6802D), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
        ),
        style: const TextStyle(color: Color(0xFFA6802D)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ' Field is Required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            await _saveOrderData();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderConfirmationPage()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6802D),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          shadowColor: Colors.grey.shade300,
        ),
        child: const Text(
          "Submit",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
