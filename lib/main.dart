import 'package:flutter/material.dart';

void main() {
  runApp(const AppRoot());
}

/// We keep MaterialApp here so we can switch ThemeMode dynamically.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CW1 – Counter + Image Toggle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onToggleTheme: _toggleTheme, isDark: _isDark),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  final VoidCallback onToggleTheme;
  final bool isDark;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _counter = 0;

  // Toggle between two images
  bool _isImageOne = true;

  // Animation: Fade in/out the image when toggled
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0, // start fully visible
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() => _counter++);
  }

  /// Requirement: _toggleImage method that triggers the animation
  Future<void> _toggleImage() async {
    // Fade out, switch image, fade back in.
    await _controller.reverse(); // 1.0 -> 0.0
    setState(() => _isImageOne = !_isImageOne);
    await _controller.forward(); // 0.0 -> 1.0
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _isImageOne ? 'assets/img1.png' : 'assets/img2.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('CW1: Counter + Image Toggle'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Counter display
                Text(
                  'Counter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                // Buttons row: Increment, Toggle Image, Toggle Theme
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: _increment,
                      child: const Text('Increment'),
                    ),
                    ElevatedButton(
                      onPressed: _toggleImage,
                      child: const Text('Toggle Image'),
                    ),
                    OutlinedButton(
                      onPressed: widget.onToggleTheme,
                      child: Text(widget.isDark ? 'Light Mode' : 'Dark Mode'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // Animated image (FadeTransition requirement)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: FadeTransition(
                          opacity: _fade,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isImageOne ? 'Showing: img1.png' : 'Showing: img2.png',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
