// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:math' as math;
// import 'package:xtrandhand/screens/chat_screen.dart';

// class IntroApp extends StatelessWidget {
//   const IntroApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       home: const IntroPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class IntroPage extends StatefulWidget {
//   const IntroPage({super.key});

//   @override
//   _IntroPageState createState() => _IntroPageState();
// }

// class _IntroPageState extends State<IntroPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   double _dragPosition = 0;
//   bool _isProcessing = false;
//   bool _isCompleted = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onDragUpdate(DragUpdateDetails details) {
//     setState(() {
//       _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, 180.0);
//     });
//   }

//   void _onDragEnd(DragEndDetails details) {
//     if (_dragPosition >= 150) {
//       setState(() {
//         _isProcessing = true;
//       });

//       Future.delayed(const Duration(seconds: 2), () {
//         setState(() {
//           _isProcessing = false;
//           _isCompleted = true;
//         });

//         Get.off(() => ChatScreen());
//       });
//     } else {
//       setState(() {
//         _dragPosition = 0;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [_buildBackground(), _buildContent()]),
//     );
//   }

//   Widget _buildBackground() {
//     return Positioned.fill(
//       child: Image.asset(
//         'assets/images/intro.jpg', // Ensure image is in the correct assets path
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _buildTitle(),
//           const SizedBox(height: 40),
//           _buildAnimatedCircles(),
//           const SizedBox(height: 20),
//           _buildSwipeButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTitle() {
//     return Text(
//       'AI DON FASSARAR KALAMAN \nENGLISH zuwa HAUSA',
//       style: TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'Roboto',
//         color: Colors.black.withOpacity(0.8),
//       ),
//       textAlign: TextAlign.center,
//     );
//   }

//   Widget _buildAnimatedCircles() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         _animatedCircle(120, Colors.blue.withOpacity(0.2), 0),
//         _animatedCircle(160, Colors.green.withOpacity(0.2), math.pi / 2),
//         _animatedCircle(200, Colors.orange.withOpacity(0.2), math.pi),
//       ],
//     );
//   }

//   Widget _animatedCircle(double radius, Color color, double angleOffset) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (_, __) {
//         return Transform.rotate(
//           angle: math.sin(_controller.value * 2 * math.pi + angleOffset) * 0.2,
//           child: _buildWaveCircle(radius, color),
//         );
//       },
//     );
//   }

//   Widget _buildWaveCircle(double radius, Color color) {
//     return Container(
//       width: radius,
//       height: radius,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: color, width: 4),
//       ),
//     );
//   }

//   Widget _buildSwipeButton() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 30.0),
//       child: AnimatedOpacity(
//         opacity: _isCompleted ? 0.0 : 1.0,
//         duration: const Duration(milliseconds: 300),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           width: _isCompleted ? 0 : 250,
//           height: 50,
//           decoration: BoxDecoration(
//             color:
//                 _isCompleted
//                     ? Colors.transparent
//                     : (_isProcessing ? Colors.green : Colors.grey),
//             borderRadius: BorderRadius.circular(25),
//             boxShadow: [
//               if (!_isCompleted)
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 5,
//                   blurRadius: 10,
//                   offset: const Offset(0, 3),
//                 ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               Center(
//                 child: Text(
//                   _isProcessing ? 'Sarrafawa....' : 'Swipe zuwa Chat',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               AnimatedPositioned(
//                 duration: const Duration(milliseconds: 300),
//                 left: _isCompleted ? 200 : _dragPosition,
//                 top: 0,
//                 bottom: 0,
//                 child: GestureDetector(
//                   onHorizontalDragUpdate: _onDragUpdate,
//                   onHorizontalDragEnd: _onDragEnd,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color:
//                           _isCompleted
//                               ? Colors.green
//                               : (_isProcessing ? Colors.white : Colors.white),
//                       shape: BoxShape.circle,
//                     ),
//                     child:
//                         _isCompleted
//                             ? const Icon(Icons.check, color: Colors.white)
//                             : const Icon(
//                               Icons.arrow_forward,
//                               color: Colors.green,
//                             ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
