import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calculator_state.dart';
import 'modern_calculator_button.dart';

/// A calculator keypad with modern design
/// Optimized for performance with button caching and efficient layout
class ModernKeypad extends ConsumerStatefulWidget {
  const ModernKeypad({super.key});

  @override
  ConsumerState<ModernKeypad> createState() => _ModernKeypadState();
}

class _ModernKeypadState extends ConsumerState<ModernKeypad> {
  // Cache buttons to prevent rebuilding them on every state change
  final Map<String, Widget> _buttonCache = {};

  // Cache row layouts for better performance
  final Map<String, Widget> _rowCache = {};

  // Memoize button press handlers
  final Map<String, VoidCallback> _buttonHandlers = {};

  @override
  void dispose() {
    _buttonCache.clear();
    _rowCache.clear();
    _buttonHandlers.clear();
    super.dispose();
  }

  // Get a cached button or create and cache a new one
  Widget _getCachedButton(String text,
      {required ModernButtonType type, required double size}) {
    final key = '$text-$type-$size';
    return _buttonCache.putIfAbsent(
        key, () => _buildButton(text, type: type, size: size));
  }

  // Get a cached handler for button presses
  VoidCallback _getCachedHandler(String text, ModernButtonType type) {
    final key = '$text-$type';
    return _buttonHandlers.putIfAbsent(
        key, () => () => _handleButtonPress(text, type));
  }

  // Create a cached row of buttons
  Widget _buildCachedRow(List<ButtonConfig> buttons, double size, {Key? key}) {
    final rowKey =
        '${buttons.map((b) => '${b.text}-${b.type.name}').join('-')}-$size';

    return _rowCache.putIfAbsent(rowKey, () {
      return Row(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: buttons
            .map((config) => Flexible(
                  fit: FlexFit.loose,
                  child: _getCachedButton(config.text,
                      type: config.type, size: size),
                ))
            .toList(growable: false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery.of() only once
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final isLandscape = screenSize.width > screenSize.height;

    // Use adaptive padding based on screen size
    final padding = mediaQuery.padding.copyWith(
        top: mediaQuery.padding.top + 8, bottom: mediaQuery.padding.bottom + 8);

    return isLandscape
        ? _buildLandscapeKeypad(screenSize, padding)
        : _buildPortraitKeypad(screenSize, padding);
  }

  Widget _buildPortraitKeypad(Size screenSize, EdgeInsets padding) {
    // Calculate button size once with optimized formula - use more conservative sizing
    final availableWidth = screenSize.width - padding.horizontal - 36;
    final buttonSize = availableWidth / 4.5; // Smaller size to prevent overflow

    // Define button configurations for each row
    const rows = [
      // Scientific functions row
      [
        ButtonConfig('sin', ModernButtonType.function),
        ButtonConfig('cos', ModernButtonType.function),
        ButtonConfig('tan', ModernButtonType.function),
        ButtonConfig('π', ModernButtonType.constant)
      ],

      // Additional functions
      [
        ButtonConfig('log', ModernButtonType.function),
        ButtonConfig('ln', ModernButtonType.function),
        ButtonConfig('√', ModernButtonType.function),
        ButtonConfig('e', ModernButtonType.constant)
      ],

      // First row of numbers/operations
      [
        ButtonConfig('(', ModernButtonType.operator),
        ButtonConfig(')', ModernButtonType.operator),
        ButtonConfig('%', ModernButtonType.operator),
        ButtonConfig('AC', ModernButtonType.clear)
      ],

      // Second row
      [
        ButtonConfig('7', ModernButtonType.number),
        ButtonConfig('8', ModernButtonType.number),
        ButtonConfig('9', ModernButtonType.number),
        ButtonConfig('÷', ModernButtonType.operator)
      ],

      // Third row
      [
        ButtonConfig('4', ModernButtonType.number),
        ButtonConfig('5', ModernButtonType.number),
        ButtonConfig('6', ModernButtonType.number),
        ButtonConfig('×', ModernButtonType.operator)
      ],

      // Fourth row
      [
        ButtonConfig('1', ModernButtonType.number),
        ButtonConfig('2', ModernButtonType.number),
        ButtonConfig('3', ModernButtonType.number),
        ButtonConfig('-', ModernButtonType.operator)
      ],

      // Fifth row
      [
        ButtonConfig('0', ModernButtonType.number),
        ButtonConfig('.', ModernButtonType.number),
        ButtonConfig('=', ModernButtonType.equals),
        ButtonConfig('+', ModernButtonType.operator)
      ],
    ];

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            for (int i = 0; i < rows.length; i++)
              Expanded(
                key: ValueKey('portrait-row-$i'),
                child: _buildCachedRow(rows[i], buttonSize,
                    key: ValueKey('row-$i')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeKeypad(Size screenSize, EdgeInsets padding) {
    // Optimized button sizing calculation with more conservative values
    final availableWidth =
        screenSize.width - padding.horizontal - 80; // More padding allowance
    final availableHeight = screenSize.height - padding.vertical - 60;

    final buttonSize = _calculateOptimalButtonSize(
        availableWidth / 8.5, // Reduce button size ratio
        availableHeight / 4.5);

    // Left section button configurations
    const leftRows = [
      [
        ButtonConfig('sin', ModernButtonType.function),
        ButtonConfig('cos', ModernButtonType.function),
        ButtonConfig('tan', ModernButtonType.function)
      ],
      [
        ButtonConfig('log', ModernButtonType.function),
        ButtonConfig('ln', ModernButtonType.function),
        ButtonConfig('√', ModernButtonType.function)
      ],
      [
        ButtonConfig('π', ModernButtonType.constant),
        ButtonConfig('e', ModernButtonType.constant),
        ButtonConfig('^', ModernButtonType.operator)
      ],
      [
        ButtonConfig('(', ModernButtonType.operator),
        ButtonConfig(')', ModernButtonType.operator),
        ButtonConfig('%', ModernButtonType.operator)
      ],
    ];

    // Right section button configurations
    const rightRows = [
      [
        ButtonConfig('AC', ModernButtonType.clear),
        ButtonConfig('⌫', ModernButtonType.clear),
        ButtonConfig('÷', ModernButtonType.operator),
        ButtonConfig('×', ModernButtonType.operator)
      ],
      [
        ButtonConfig('7', ModernButtonType.number),
        ButtonConfig('8', ModernButtonType.number),
        ButtonConfig('9', ModernButtonType.number),
        ButtonConfig('-', ModernButtonType.operator)
      ],
      [
        ButtonConfig('4', ModernButtonType.number),
        ButtonConfig('5', ModernButtonType.number),
        ButtonConfig('6', ModernButtonType.number),
        ButtonConfig('+', ModernButtonType.operator)
      ],
      [
        ButtonConfig('1', ModernButtonType.number),
        ButtonConfig('2', ModernButtonType.number),
        ButtonConfig('3', ModernButtonType.number),
        ButtonConfig('=', ModernButtonType.equals)
      ],
    ];

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left section - Scientific functions
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < leftRows.length; i++)
                    Expanded(
                      key: ValueKey('landscape-left-$i'),
                      child: _buildCachedRow(leftRows[i], buttonSize,
                          key: ValueKey('left-row-$i')),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8), // Spacing between sections

            // Right section - Numbers and basic operators
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < rightRows.length; i++)
                    Expanded(
                      key: ValueKey('landscape-right-$i'),
                      child: _buildCachedRow(rightRows[i], buttonSize,
                          key: ValueKey('right-row-$i')),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Optimized button builder with minimal padding
  Widget _buildButton(String text,
      {required ModernButtonType type, required double size}) {
    return Padding(
      padding: const EdgeInsets.all(2.0), // Reduced padding
      child: ModernCalculatorButton(
        key: ValueKey('btn-$text-${type.name}'),
        text: text,
        type: type,
        size: size,
        onPressed: _getCachedHandler(text, type),
      ),
    );
  }

  // Calculate optimal button size based on available space
  double _calculateOptimalButtonSize(double widthBased, double heightBased) {
    // Add safety margin and use the smaller dimension
    return (widthBased < heightBased ? widthBased : heightBased) *
        0.9; // Reduce to 90% for safety
  }

  // Handle button press with appropriate feedback and action
  void _handleButtonPress(String text, ModernButtonType type) {
    // Provide appropriate haptic feedback based on button type
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

    // Process button action
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

// Button configuration data class for easier management
class ButtonConfig {
  final String text;
  final ModernButtonType type;

  const ButtonConfig(this.text, this.type);
}
