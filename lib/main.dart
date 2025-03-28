import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math' as math;
import 'package:xtrandhand/screens/chat_screen.dart';
import 'package:xtrandhand/controllers/translation_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(TranslationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TranslationController translationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme:
            translationController.isDarkMode.value
                ? ThemeData.dark()
                : ThemeData.light(),
        home: const IntroPage(),
      ),
    );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragPosition = 0;
  bool _isProcessing = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, 180.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragPosition >= 150) {
      setState(() {
        _isProcessing = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isProcessing = false;
          _isCompleted = true;
        });

        Get.off(() => ChatScreen());
      });
    } else {
      setState(() {
        _dragPosition = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_buildBackground(), _buildContent()]),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: Colors.white)),
        Positioned.fill(
          child: Image.asset(
            'assets/intro.jpg',
            //fit: BoxFit.cover,
            // errorBuilder: (context, error, stackTrace) {
            //   return const Center(child: Text('Image not found')
            // );
            // },
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTitle(),
          const SizedBox(height: 40),
          _buildAnimatedCircles(),
          const SizedBox(height: 20),
          _buildSwipeButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Image.asset(
          'assets/logo.png',
          height: 100,
          color: Colors.black.withAlpha((0.8 * 255).toInt()),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Xtrahand Translation App',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Colors.black.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedCircles() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: math.sin(_controller.value * 2 * math.pi) * 0.2,
              child: WaveCircle(
                radius: 120,
                color: Colors.blue.withOpacity(0.2),
                controller: _controller,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle:
                  math.sin(_controller.value * 2 * math.pi + math.pi / 2) * 0.2,
              child: WaveCircle(
                radius: 160,
                color: Colors.green.withOpacity(0.2),
                controller: _controller,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: math.sin(_controller.value * 2 * math.pi + math.pi) * 0.2,
              child: WaveCircle(
                radius: 200,
                color: Colors.orange.withOpacity(0.2),
                controller: _controller,
              ),
            );
          },
        ),
        Column(
          children: <Widget>[
            FloatingSkewedLanguageButton(
              controller: _controller,
              language: 'English',
              icon: Icons.code,
              skewAngle: -0.1,
            ),
            const SizedBox(height: 16),
            FloatingSkewedLanguageButton(
              controller: _controller,
              language: 'Hausa',
              icon: Icons.code,
              skewAngle: 0.1,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwipeButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: AnimatedOpacity(
        opacity: _isCompleted ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isCompleted ? 0 : 250,
          height: 50,
          decoration: BoxDecoration(
            color:
                _isCompleted
                    ? Colors.transparent
                    : (_isProcessing ? Colors.green : Colors.grey),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              if (!_isCompleted)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  _isProcessing ? 'Sarrafawa....' : 'Swipe zuwa Chat',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: _isCompleted ? 200 : _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: CircleAvatar(
                    radius: 25, // Increased size
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/logo.png',
                      // height: 48, // Increased size
                      // width: 48, // Increased size
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveCircle extends StatelessWidget {
  final double radius;
  final Color color;
  final AnimationController controller;

  const WaveCircle({
    super.key,
    required this.radius,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: CustomPaint(painter: WavePainter(controller)),
    );
  }
}

class WavePainter extends CustomPainter {
  final AnimationController controller;

  WavePainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (double angle = 0; angle <= 2 * math.pi; angle += 0.1) {
      final x =
          centerX +
          radius * math.cos(angle) +
          math.sin(angle * 5 + controller.value * 10) * 5;
      final y =
          centerY +
          radius * math.sin(angle) +
          math.cos(angle * 5 + controller.value * 10) * 5;
      if (angle == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FloatingSkewedLanguageButton extends StatelessWidget {
  final AnimationController controller;
  final String language;
  final IconData icon;
  final double skewAngle;

  const FloatingSkewedLanguageButton({
    super.key,
    required this.controller,
    required this.language,
    required this.icon,
    required this.skewAngle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(controller.value * 2 * math.pi) * 10),
          child: Transform(
            transform: Matrix4.skewY(skewAngle),
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to language-specific page
              },
              icon: Icon(icon, color: Colors.white),
              label: Text(
                language,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
