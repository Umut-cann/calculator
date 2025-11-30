import 'package:calculator/presentation/widgets/modern_history_drawer_fixed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../providers/calculator_state.dart';
import '../providers/theme_provider.dart';
import '../widgets/display_panel.dart';
import '../widgets/modern_keypad.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  // Add a key for the scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lazy-load drawer to improve startup performance
  late final Widget _drawerWidget;
  bool _isDrawerInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize without expensive operations
    // Defer drawer initialization for better startup performance
    Future.microtask(() {
      if (!mounted) return;
      setState(() {
        _drawerWidget = const ModernHistoryDrawer();
        _isDrawerInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use select for specific properties to minimize rebuilds
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final calculatorState = ref.watch(calculatorProvider);
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return RepaintBoundary(
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        // Drawer is defined below
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDarkMode ? Brightness.light : Brightness.dark,
          ),
          centerTitle: true,
          title: const Text(
            'Hesap Makinesi',
            style: AppConstants.titleStyle,
          ),
          actions: [
            // Toggle between radians and degrees
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(
                    Theme.of(context).colorScheme.primary.red,
                    Theme.of(context).colorScheme.primary.green,
                    Theme.of(context).colorScheme.primary.blue,
                    0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  ref.read(calculatorProvider.notifier).toggleAngleMode();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: AppConstants.buttonPadding,
                ),
                child: Text(
                  calculatorState.isRadianMode ? 'RAD' : 'DEG',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            // Theme switcher without animation
            const SizedBox(width: 4), // Add spacing with const
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(
                    Theme.of(context).colorScheme.primary.red,
                    Theme.of(context).colorScheme.primary.green,
                    Theme.of(context).colorScheme.primary.blue,
                    0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),
          ],
        ),
        drawer: _isDrawerInitialized ? _drawerWidget : Container(),
        body: Container(
          // Use solid color instead of gradient for better performance during startup
          color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF9FFF9),
          child: SafeArea(
            child: isLandscape
                ? Row(
                    children: [
                      // Display panel on the left in landscape mode
                      const Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
                          child: DisplayPanel(),
                        ),
                      ),
                      // Keypad on the right in landscape mode
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, top: 16.0, bottom: 16.0, left: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                              color: isDarkMode
                                  ? const Color(
                                      0x4D000000) // black with 0.3 opacity
                                  : const Color(
                                      0x80FFFFFF), // white with 0.5 opacity
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      Theme.of(context).colorScheme.primary.red,
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .green,
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .blue,
                                      0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const ModernKeypad(),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Column(
                    children: [
                      // Display panel showing the expression and result in portrait mode
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: DisplayPanel(),
                        ),
                      ),
                      // Keypad with calculator buttons
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: ModernKeypad(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
