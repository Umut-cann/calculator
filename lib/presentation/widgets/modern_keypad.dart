import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for HapticFeedback
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_state.dart';
import 'modern_calculator_button.dart';

class ModernKeypad extends ConsumerStatefulWidget {
  const ModernKeypad({super.key});

  @override
  ConsumerState<ModernKeypad> createState() => _ModernKeypadState();
}

class _ModernKeypadState extends ConsumerState<ModernKeypad> {
  // Cache buttons to prevent rebuilding them on every state change
  late final Map<String, Widget> _buttonCache = {};
  
  // Get a cached button or create and cache a new one
  Widget _getCachedButton(BuildContext context, String text, {required ModernButtonType type, required double size}) {
    final key = '$text-$type-$size';
    return _buttonCache.putIfAbsent(key, () => _buildButton(context, ref, text, type: type, size: size));
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    
    return isLandscape 
      ? _buildLandscapeKeypad(context, ref)
      : _buildPortraitKeypad(context, ref);
  }
  
  Widget _buildPortraitKeypad(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    // Calculate button size with additional padding to prevent overflow
    final buttonSize = (size.width - 80) / 4.2; // More conservative sizing
    
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
        children: [
          // Scientific functions row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getCachedButton(context, 'sin', type: ModernButtonType.function, size: buttonSize),
                _getCachedButton(context, 'cos', type: ModernButtonType.function, size: buttonSize),
                _getCachedButton(context, 'tan', type: ModernButtonType.function, size: buttonSize),
                _getCachedButton(context, 'π', type: ModernButtonType.constant, size: buttonSize),
              ],
            ),
          ),
          // Additional functions
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getCachedButton(context, 'log', type: ModernButtonType.function, size: buttonSize),
                _getCachedButton(context, 'ln', type: ModernButtonType.function, size: buttonSize),
                _getCachedButton(context, '√', type: ModernButtonType.function, size: buttonSize),
                _getCachedButton(context, 'e', type: ModernButtonType.constant, size: buttonSize),
              ],
            ),
          ),
          // First row of numbers/operations
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getCachedButton(context, '(', type: ModernButtonType.operator, size: buttonSize),
                _getCachedButton(context, ')', type: ModernButtonType.operator, size: buttonSize),
                _getCachedButton(context, '%', type: ModernButtonType.operator, size: buttonSize),
                _getCachedButton(context, 'AC', type: ModernButtonType.clear, size: buttonSize),
              ],
            ),
          ),
          // Second row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getCachedButton(context, '7', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '8', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '9', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '÷', type: ModernButtonType.operator, size: buttonSize),
              ],
            ),
          ),
          // Third row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getCachedButton(context, '4', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '5', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '6', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '×', type: ModernButtonType.operator, size: buttonSize),
              ],
            ),
          ),
          // Fourth row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getCachedButton(context, '1', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '2', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '3', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '-', type: ModernButtonType.operator, size: buttonSize),
              ],
            ),
          ),
          // Fifth row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _getCachedButton(context, '0', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '.', type: ModernButtonType.number, size: buttonSize),
                _getCachedButton(context, '=', type: ModernButtonType.equals, size: buttonSize),
                _getCachedButton(context, '+', type: ModernButtonType.operator, size: buttonSize),
              ],
            ),
          ),
        ],
      ),
    ));
  }
  
  Widget _buildLandscapeKeypad(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    // Use more conservative sizing to prevent overflow
    final buttonSize = min(
      (size.width - 140) / 8.2, 
      (size.height - 100) / 4.2
    ); // Calculate button size based on screen dimensions with safety margin
    
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left section - Scientific functions
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, ref, 'sin', type: ModernButtonType.function, size: buttonSize),
                      _buildButton(context, ref, 'cos', type: ModernButtonType.function, size: buttonSize),
                      _buildButton(context, ref, 'tan', type: ModernButtonType.function, size: buttonSize),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, ref, 'log', type: ModernButtonType.function, size: buttonSize),
                      _buildButton(context, ref, 'ln', type: ModernButtonType.function, size: buttonSize),
                      _buildButton(context, ref, '√', type: ModernButtonType.function, size: buttonSize),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, ref, 'π', type: ModernButtonType.constant, size: buttonSize),
                      _buildButton(context, ref, 'e', type: ModernButtonType.constant, size: buttonSize),
                      _buildButton(context, ref, '^', type: ModernButtonType.operator, size: buttonSize),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, ref, '(', type: ModernButtonType.operator, size: buttonSize),
                      _buildButton(context, ref, ')', type: ModernButtonType.operator, size: buttonSize),
                      _buildButton(context, ref, '%', type: ModernButtonType.operator, size: buttonSize),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right section - Numbers and basic operators
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, ref, 'AC', type: ModernButtonType.clear, size: buttonSize),
                      _buildButton(context, ref, '⌫', type: ModernButtonType.clear, size: buttonSize),
                      _buildButton(context, ref, '÷', type: ModernButtonType.operator, size: buttonSize),
                      _buildButton(context, ref, '×', type: ModernButtonType.operator, size: buttonSize),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, ref, '7', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '8', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '9', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '-', type: ModernButtonType.operator, size: buttonSize),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, ref, '4', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '5', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '6', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '+', type: ModernButtonType.operator, size: buttonSize),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(context, ref, '1', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '2', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '3', type: ModernButtonType.number, size: buttonSize),
                      _buildButton(context, ref, '=', type: ModernButtonType.equals, size: buttonSize),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
  
  Widget _buildButton(
    BuildContext context, 
    WidgetRef ref, 
    String text, 
    {required ModernButtonType type, required double size}
  ) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ModernCalculatorButton(
        text: text,
        type: type,
        size: size,
        onPressed: () => _handleButtonPress(text, type, ref),
      ),
    );
  }
  
  void _handleButtonPress(String text, ModernButtonType type, WidgetRef ref) {
    // Add haptic feedback based on button type
    switch (type) {
      case ModernButtonType.equals:
        HapticFeedback.mediumImpact(); // Stronger feedback for equals
        break;
      case ModernButtonType.clear:
        HapticFeedback.lightImpact(); // Light feedback for clear
        break;
      default:
        HapticFeedback.selectionClick(); // Standard feedback for other buttons
        break;
    }
    
    final notifier = ref.read(calculatorProvider.notifier);
    
    switch (text) {
      case 'AC':
        notifier.clear();
        break;
      case '⌫':
        notifier.clearEntry();
        break;
      case '=':
        notifier.calculate();
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'log':
      case 'ln':
        notifier.addInput('$text(');
        break;
      case '√':
        notifier.addInput('sqrt(');
        break;
      case '^':
        notifier.addInput('^');
        break;
      default:
        notifier.addInput(text);
        break;
    }
  }
}

// Helper function to calculate minimum
double min(double a, double b) {
  return a < b ? a : b;
}
