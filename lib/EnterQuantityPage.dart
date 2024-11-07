// import 'package:flutter/material.dart';
// import 'DateOrderPage.dart';

// class EnterQuantityPage extends StatefulWidget {
//   final Map<String, dynamic> selectedItem;

//   EnterQuantityPage({required this.selectedItem});

//   @override
//   _EnterQuantityPageState createState() => _EnterQuantityPageState();
// }

// class _EnterQuantityPageState extends State<EnterQuantityPage> {
//   int _quantity = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: Container(
//         decoration: _buildBackgroundGradient(),
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildPageTitle(),
//             const SizedBox(height: 20),
//             Expanded(child: _buildSelectedItemCard()),
//             const SizedBox(height: 20),
//             _buildNextButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       leading: IconButton(
//         onPressed: () => Navigator.pop(context),
//         icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFA6802D)),
//       ),
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       title: Image.asset("assets/LRLogo1.png", height: 40),
//       centerTitle: true,
//     );
//   }

//   BoxDecoration _buildBackgroundGradient() {
//     return BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [Colors.white, Colors.grey.shade100],
//       ),
//     );
//   }

//   Widget _buildPageTitle() {
//     return const Text(
//       "Enter Quantity",
//       style: TextStyle(
//         color: Color(0xFFA6802D),
//         fontWeight: FontWeight.bold,
//         fontSize: 28,
//         letterSpacing: 1.5,
//       ),
//     );
//   }

//   Widget _buildSelectedItemCard() {
//     final item = widget.selectedItem;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildItemPhoto(item['image']),
//           const SizedBox(height: 8),
//           _buildItemDetails(
//             item['title'],
//             item['styleNumber'],
//             item['barcode'],
//             item['brand'],
//             item['color'],
//             item['size'],
//           ),
//           const SizedBox(height: 8),
//           _buildQuantityControl(),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemDetails(String title, String styleNumber, String barcode,
//       String brand, String color, String size) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             color: Color(0xFFA6802D),
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         _buildItemDetail("Style Number", styleNumber),
//         _buildItemDetail("Barcode", barcode),
//         _buildItemDetail("Brand", brand),
//         _buildItemDetail("Color", color),
//         _buildItemDetail("Size", size),
//       ],
//     );
//   }

//   Widget _buildItemDetail(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4.0),
//       child: Text(
//         "$label: $value",
//         style: const TextStyle(
//           color: Colors.black87,
//           fontSize: 14,
//         ),
//       ),
//     );
//   }

//   Widget _buildQuantityControl() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: () => _changeQuantity(-1),
//           icon: const Icon(
//             Icons.remove_circle_outline,
//             color: Color(0xFFA6802D),
//             size: 28,
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//           decoration: BoxDecoration(
//             color: Color(0xFFA6802D).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             "$_quantity",
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFFA6802D),
//             ),
//           ),
//         ),
//         IconButton(
//           onPressed: () => _changeQuantity(1),
//           icon: const Icon(
//             Icons.add_circle_outline,
//             color: Color(0xFFA6802D),
//             size: 28,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildItemPhoto(String imagePath) {
//     return Container(
//       height: 120,
//       width: 120,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//         image: DecorationImage(
//           image: AssetImage(imagePath),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   void _changeQuantity(int delta) {
//     setState(() {
//       _quantity = (_quantity + delta).clamp(0, 100);
//     });
//   }

//   Widget _buildNextButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _quantity > 0
//             ? () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => DateOrderPage(
//                             selectedItem: widget.selectedItem,
//                           )),
//                 );
//               }
//             : null,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFFA6802D),
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: const Text(
//           "Next",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
