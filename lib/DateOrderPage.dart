import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class DateOrderPage extends StatefulWidget {
  @override
  _DateOrderPageState createState() => _DateOrderPageState();
}

class _DateOrderPageState extends State<DateOrderPage> {
  DateTime _selectedOrderDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();
  Map<String, dynamic>? _selectedItemData;

  @override
  void initState() {
    super.initState();
    _loadSelectedItemData();
  }

  Future<void> _loadSelectedItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedItemDataString = prefs.getString('selectedItemData');
    if (selectedItemDataString != null) {
      setState(() {
        _selectedItemData = jsonDecode(selectedItemDataString);
      });
    }
  }

  Future<void> _selectOrderDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedOrderDate,
      firstDate: DateTime(2000), // Start date for selection
      lastDate: DateTime.now(), // Restrict to current or past dates only
    );
    if (picked != null && picked != _selectedOrderDate) {
      setState(() {
        _selectedOrderDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPageTitle(),
                    const SizedBox(height: 30),
                    _buildDatePickerField(
                      label: "Order Date",
                      date: _selectedOrderDate,
                      onTap: () => _selectOrderDate(context),
                    ),
                    const SizedBox(height: 30),
                    _buildNoteField(),
                  ],
                ),
              ),
            ),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFA6802D)),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Image.asset("assets/LRLogo1.png", height: 40),
      centerTitle: true,
    );
  }

  Widget _buildPageTitle() {
    return const Text(
      "Select Dates",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFA6802D),
        fontWeight: FontWeight.bold,
        fontSize: 28,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA6802D),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFA6802D), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(date),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.calendar_today, color: Color(0xFFA6802D)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Note (Optional)",
          style: TextStyle(
            color: Color(0xFFA6802D),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _noteController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Enter any notes here...",
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFA6802D), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFA6802D), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _selectedItemData != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      orderId: 'II-${DateTime.now().millisecondsSinceEpoch}',
                      selectedItem: _selectedItemData!['selectedItem'],
                      quantity: _selectedItemData!['quantity'],
                      orderDate: _selectedOrderDate,
                      note: _noteController.text,
                    ),
                  ),
                );
              }
            : null, // Disable button if _selectedItemData is null
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6802D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 6,
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
