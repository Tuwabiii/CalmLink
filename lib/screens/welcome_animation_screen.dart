import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome_screen.dart';
import 'home_screen.dart'; // Import HomeScreen

class WelcomeAnimationScreen extends StatefulWidget {
  final VoidCallback onRegistrationComplete;
  
  const WelcomeAnimationScreen({
    super.key,
    required this.onRegistrationComplete,
  });

  @override
  State<WelcomeAnimationScreen> createState() => _WelcomeAnimationScreenState();
}

class _WelcomeAnimationScreenState extends State<WelcomeAnimationScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _crossFadeController;
  late Animation<double> _currentImageOpacity;
  late Animation<double> _nextImageOpacity;
  int _currentImageIndex = 0;
  int _nextImageIndex = 1;
  bool _animationComplete = false;
  
  // List of welcome animation images
  final List<String> _animationImages = [
    'assets/animations/Welcome Animation - 1.png',
    'assets/animations/Welcome Animation - 2.png',
    'assets/animations/Welcome Animation - 3.png',
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Hide the navigation bar and status bar on Android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
    
    // Initialize main animation controller for timing
    // Each image will be shown for exactly 2 seconds total
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Exactly 2 seconds per image
    );
    
    // Initialize crossfade controller for smooth transitions between images
    _crossFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Crossfade duration (faster for a 2-second cycle)
    );
    
    // Create animations for fading current image out and next image in
    _currentImageOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _crossFadeController,
        curve: Curves.easeOut,
      ),
    );
    
    _nextImageOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _crossFadeController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_currentImageIndex < _animationImages.length - 1) {
          // Set the next image index
          _nextImageIndex = _currentImageIndex + 1;
          
          // Start crossfade animation
          _crossFadeController.forward().then((_) {
            // When crossfade completes, update current image
            setState(() {
              _currentImageIndex = _nextImageIndex;
            });
            
            // Reset controllers for next transition
            _crossFadeController.reset();
            _animationController.reset();
            _animationController.forward();
          });
        } else {
          // Animation sequence complete, navigate to registration
          setState(() {
            _animationComplete = true;
          });
          // Navigate to registration screen after a short delay
          Future.delayed(const Duration(milliseconds: 400), () {
            // Replace this screen with the registration screen
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => WelcomeScreen(
                  onRegistrationComplete: widget.onRegistrationComplete,
                ),
                transitionDuration: const Duration(milliseconds: 600),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          });
        }
      }
    });
    
    // Start the animation sequence
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _crossFadeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background to ensure no white parts are visible
      body: _animationComplete
          ? Container(key: const ValueKey<String>('empty'))
          : Stack(
              fit: StackFit.expand,
              children: [
                // Current image
                AnimatedBuilder(
                  animation: _currentImageOpacity,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _currentImageOpacity.value,
                      child: SizedBox.expand(
                        child: Image.asset(
                          _animationImages[_currentImageIndex],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
                // Next image (shown during crossfade)
                AnimatedBuilder(
                  animation: _nextImageOpacity,
                  builder: (context, child) {
                    if (_nextImageIndex >= _animationImages.length) {
                      // Return empty container if we're at the last image
                      return Container();
                    }
                    return Opacity(
                      opacity: _nextImageOpacity.value,
                      child: SizedBox.expand(
                        child: Image.asset(
                          _animationImages[_nextImageIndex],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
