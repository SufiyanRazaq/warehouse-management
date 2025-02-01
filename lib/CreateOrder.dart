import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouseproject/SelectItemsPage.dart';
import 'OrderDetailsPage.dart';
import 'SelectStorePage.dart';
import 'verification.dart';

class CreateOrderPage extends StatefulWidget {
  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  String? _branchName;

  @override
  void initState() {
    super.initState();
    _loadBranchName();
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
      appBar: AppBar(
        title: Text(
          _branchName ?? "Branch",
          style: const TextStyle(color: Color(0xFFA6802D)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade200],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildActionButton(
                      context,
                      "New Item",
                      Icons.add_circle,
                      () {},
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      context,
                      "Sales Item",
                      Icons.attach_money,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectItemsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      context,
                      "Customer Request",
                      Icons.person,
                      () {},
                    ),
                  ],
                ),
              ),
            ),
            _buildViewOrdersButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFA6802D).withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Image.asset(
            "assets/LRLogo.png",
            height: 100,
            width: 100,
            color: const Color(0xFFA6802D),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Create Order",
          style: TextStyle(
            color: Color(0xFFA6802D),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon,
      VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 28),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6802D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8,
          shadowColor: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildViewOrdersButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerificationScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6802D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(),
          elevation: 10,
          shadowColor: Colors.grey.shade400,
        ),
        child: const Text(
          "View Orders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
