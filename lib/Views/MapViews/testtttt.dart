// import 'package:flutter/material.dart';

// class EmergencyAlertScreen extends StatefulWidget {
//   @override
//   _EmergencyAlertScreenState createState() => _EmergencyAlertScreenState();
// }

// class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
//   ScrollController _scrollController = ScrollController();
//   double _containerHeight = 0.5; // 70% initial height

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     // Update height based on scroll position
//     setState(() {
//       _containerHeight = 0.7 - (_scrollController.offset / 500); 
//       if (_containerHeight < 0.2) {
//         _containerHeight = 0.2; // Minimum height of 20%
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Map behind the alert section
//           Positioned.fill(
//             child: Image.network(
//               'https://image.tmdb.org/t/p/original//iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg', // Replace with your map widget
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Scrollable content
//           Positioned.fill(
//             child: NotificationListener<ScrollNotification>(
//               onNotification: (scrollNotification) {
//                 if (scrollNotification is ScrollUpdateNotification) {
//                   _scrollListener();
//                 }
//                 return true;
//               },
//               child: CustomScrollView(
//                 controller: _scrollController,
//                 slivers: [
//                   SliverAppBar(
//                     expandedHeight: MediaQuery.of(context).size.height * _containerHeight,
//                     pinned: true,
//                     flexibleSpace: FlexibleSpaceBar(
//                       background: _buildEmergencyAlert(),
//                     ),
//                   ),
//                   SliverList(
//                     delegate: SliverChildListDelegate(
//                       [
//                         _buildEmergencyServices(),
//                         _buildRecentEmergencies(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmergencyAlert() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 5),
//         ],
//       ),
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Text(
//             'Emergency alert',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Card(
//             color: Colors.red.shade100,
//             child: ListTile(
//               leading: Icon(Icons.warning, color: Colors.red),
//               title: Text(
//                 'Active shooter alert',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text('An active shooter has been reported at 143 Randall Avenue.'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmergencyServices() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildServiceButton(Icons.local_police, 'Police'),
//           _buildServiceButton(Icons.fire_truck, 'Fire Rescue'),
//           _buildServiceButton(Icons.local_hospital, 'Ambulance'),
//         ],
//       ),
//     );
//   }

//   Widget _buildServiceButton(IconData icon, String label) {
//     return Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: Colors.blue.shade100,
//           child: Icon(icon, color: Colors.blue),
//         ),
//         SizedBox(height: 8),
//         Text(label),
//       ],
//     );
//   }

//   Widget _buildRecentEmergencies() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Recent emergencies',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           ...List.generate(20, (index){
//             return ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.blue.shade100,
//               child: Icon(Icons.local_police, color: Colors.blue),
//             ),
//             title: Text('Police Emergency'),
//             subtitle: Text('Home invasion with armed burglar'),
//           );
//           })
//         ],
//       ),
//     );
//   }
// }