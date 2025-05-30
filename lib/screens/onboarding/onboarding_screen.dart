import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmer_connect/service/auth_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to FarmerConnect',
      description: 'Your all-in-one farming companion that helps you grow smarter, not harder',
      icon: Icons.agriculture,
      color: Colors.green,
      features: ['Smart Crop Management', 'Real-time Weather Updates', 'Market Price Tracking'],
      illustration: _buildFarmingIllustration(Colors.green),
    ),
    OnboardingPage(
      title: 'AI-Powered Insights',
      description: 'Get personalized recommendations and predictions for your farm',
      icon: Icons.psychology,
      color: Colors.blue,
      features: ['Crop Disease Detection', 'Yield Predictions', 'Smart Irrigation'],
      illustration: _buildAIIllustration(Colors.blue),
    ),
    OnboardingPage(
      title: 'Connect & Grow',
      description: 'Join a community of farmers and access premium market insights',
      icon: Icons.people,
      color: Colors.orange,
      features: ['Community Forums', 'Expert Advice', 'Market Opportunities'],
      illustration: _buildCommunityIllustration(Colors.orange),
    ),
  ];

  static Widget _buildFarmingIllustration(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        Icon(
          Icons.agriculture,
          size: 100,
          color: color,
        ),
        ...List.generate(3, (index) {
          return Positioned(
            top: 50 + (index * 40),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).scale(
            duration: const Duration(seconds: 2),
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.2, 1.2),
          ).fadeOut(
            duration: const Duration(seconds: 2),
          );
        }),
      ],
    );
  }

  static Widget _buildAIIllustration(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        Icon(
          Icons.psychology,
          size: 100,
          color: color,
        ),
        ...List.generate(6, (index) {
          final angle = (index * 60) * (3.14159 / 180);
          return Positioned(
            left: 100 + (80 * cos(angle)),
            top: 100 + (80 * sin(angle)),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).scale(
            duration: const Duration(seconds: 1),
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.5, 1.5),
          ).fadeOut(
            duration: const Duration(seconds: 1),
          );
        }),
      ],
    );
  }

  static Widget _buildCommunityIllustration(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        Icon(
          Icons.people,
          size: 100,
          color: color,
        ),
        ...List.generate(4, (index) {
          final angle = (index * 90) * (3.14159 / 180);
          return Positioned(
            left: 100 + (70 * cos(angle)),
            top: 100 + (70 * sin(angle)),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 20,
                color: color,
              ),
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).scale(
            duration: const Duration(seconds: 2),
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.2, 1.2),
          );
        }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page?.round() ?? 0;
        });
        _animationController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (!mounted) return;
    
    final authService = AuthService();
    final session = authService.currentUser;

    if (session != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background with particles
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _pages[_currentPage].color.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
            child: CustomPaint(
              painter: ParticlePainter(
                color: _pages[_currentPage].color,
                currentPage: _currentPage,
              ),
            ),
          ),
          // Page content
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          // Bottom controls
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Animated page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[index].color
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            'Previous',
                            style: TextStyle(
                              color: _pages[_currentPage].color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      ElevatedButton(
                        onPressed: _currentPage == _pages.length - 1
                            ? _completeOnboarding
                            : () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage].color,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom illustration
              page.illustration
              .animate()
              .scale(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
              )
              .then()
              .shimmer(
                duration: const Duration(seconds: 2),
                color: page.color.withOpacity(0.3),
              ),
              const SizedBox(height: 48),
              // Animated title with underline
              Stack(
                children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 600))
                  .slideY(begin: 0.3, end: 0),
                  Positioned(
                    bottom: -8,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: page.color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )
                  .animate()
                  .scaleX(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Animated description
              Text(
                page.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200))
              .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 32),
              // Animated feature list
              ...page.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: page.color,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 400))
                .slideX(begin: 0.2, end: 0),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> features;
  final Widget illustration;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.features,
    required this.illustration,
  });
}

class ParticlePainter extends CustomPainter {
  final Color color;
  final int currentPage;
  final List<Particle> particles = [];

  ParticlePainter({required this.color, required this.currentPage}) {
    for (int i = 0; i < 20; i++) {
      particles.add(Particle(color));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update();
      particle.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  final Color color;
  double x = 0;
  double y = 0;
  double speed = 0;
  double size = 0;
  double opacity = 0;

  Particle(this.color) {
    reset();
  }

  void reset() {
    x = Random().nextDouble() * 400;
    y = Random().nextDouble() * 800;
    speed = Random().nextDouble() * 2 + 1;
    size = Random().nextDouble() * 4 + 2;
    opacity = Random().nextDouble() * 0.5 + 0.1;
  }

  void update() {
    y += speed;
    if (y > 800) {
      reset();
      y = 0;
    }
  }

  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), this.size, paint);
  }
} 