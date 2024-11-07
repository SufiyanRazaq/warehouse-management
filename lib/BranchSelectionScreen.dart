import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CreateOrder.dart';

class BranchSelectionScreen extends StatefulWidget {
  @override
  _BranchSelectionScreenState createState() => _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends State<BranchSelectionScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isPinVisible = false;
  String? _selectedBranch;

  final List<String> branches = [
    "Branch 1",
    "Branch 2",
    "Branch 3",
    "Branch 4"
  ];

  Future<void> _saveBranchAndNavigate() async {
    if (_selectedBranch != null && _pinController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedBranch', _selectedBranch!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CreateOrderPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a branch and enter your PIN"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(child: _buildLogo()),
              const SizedBox(height: 30),
              _buildTitle(),
              const SizedBox(height: 30),
              _buildBranchDropdown(),
              const SizedBox(height: 20),
              _buildPinField(),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
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
    return const Center(
      child: Text(
        "Select Branch & Enter PIN",
        style: TextStyle(
          color: Color(0xFFA6802D),
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBranchDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedBranch,
        hint: const Text("Select Branch", style: TextStyle(color: Colors.grey)),
        onChanged: (value) => setState(() => _selectedBranch = value),
        items: branches
            .map((branch) => DropdownMenuItem(
                value: branch,
                child:
                    Text(branch, style: TextStyle(color: Color(0xFFA6802D)))))
            .toList(),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _buildPinField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: TextField(
        controller: _pinController,
        obscureText: !_isPinVisible,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Branch PIN",
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.lock, color: Color(0xFFA6802D)),
          suffixIcon: IconButton(
            icon: Icon(_isPinVisible ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFFA6802D)),
            onPressed: () => setState(() => _isPinVisible = !_isPinVisible),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Color(0xFFA6802D), width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
        ),
        style: const TextStyle(color: Color(0xFFA6802D)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveBranchAndNavigate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6802D),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 5,
          shadowColor: Colors.grey.shade300,
        ),
        child: const Text("Submit",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
