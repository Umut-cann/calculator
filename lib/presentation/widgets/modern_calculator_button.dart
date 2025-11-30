// Using system fonts instead of Google Fonts
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ModernButtonType {
  number,
  operator,
  function,
  constant,
  clear,
  equals,
}

// Button press state provider (directly in this file for simplicity)
final buttonPressStateProvider =
    StateProvider.family<bool, String>((ref, id) => false);

/// Optimized calculator button with modern design
class ModernCalculatorButton extends ConsumerWidget {
  final String text;
  final ModernButtonType type;
  final VoidCallback onPressed;
  final double size;

  // Using a const constructor for improved performance
  const ModernCalculatorButton({
    super.key,
    required this.text,
    required this.type,
    required this.onPressed,
    this.size = 65.0,
  });

  // Caching the border radius calculations
  BorderRadius _getBorderRadius() =>
      BorderRadius.circular(type == ModernButtonType.equals ? 24 : 18);

  // Get the font size based on button type (memoizable)
  double getButtonFontSize() {
    switch (type) {
      case ModernButtonType.function:
        return 20.0;
      case ModernButtonType.operator:
        return 24.0;
      case ModernButtonType.equals:
        return 28.0;
      case ModernButtonType.clear:
        return text == 'AC' ? 18.0 : 24.0;
      default:
        return 22.0;
    }
  }

  // Responsive font size that scales with the button size
  double getResponsiveFontSize() {
    final baseSize = getButtonFontSize();
    final sizeRatio = size / 65.0; // 65.0 is the default button size
    return max(baseSize * sizeRatio, 14.0);
  }

  // Get font weight based on button type (memoizable)
  FontWeight getButtonFontWeight() {
    switch (type) {
      case ModernButtonType.function:
      case ModernButtonType.clear:
        return FontWeight.w500;
      case ModernButtonType.operator:
        return FontWeight.w600;
      case ModernButtonType.number:
      case ModernButtonType.constant:
        return FontWeight.w500;
      case ModernButtonType.equals:
        return FontWeight.w700;
    }
  }

  // Cache TextStyle objects to avoid recreating them
  static final Map<String, TextStyle> _textStyleCache = {};

  // Get cached text style
  TextStyle _getCachedTextStyle(
      Color textColor, double fontSize, FontWeight fontWeight) {
    final key = '${textColor.value}-$fontSize-${fontWeight.index}';
    return _textStyleCache.putIfAbsent(
        key,
        () => TextStyle(
            fontSize: fontSize, fontWeight: fontWeight, color: textColor));
  }

  // Build button content without backdrop filter for better performance
  Widget _buildSimpleContent(bool isPressed, Color highlightColor,
      BorderRadius borderRadius, TextStyle textStyle) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isPressed ? highlightColor : Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Generate a unique ID for this button based on text and type
    final String buttonId = '${type.name}_$text';
    // Watch button press state
    final isPressed = ref.watch(buttonPressStateProvider(buttonId));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    // Define colors based on button type and theme (moved to local variables for optimization)
    late final Color buttonColor;
    late final Color textColor;
    late final Color shadowColor;
    late final Color highlightColor;

    // Optimized color computation using switch
    switch (type) {
      case ModernButtonType.number:
        buttonColor = isDarkMode ? const Color(0xFF2A2D37) : Colors.white;
        textColor = isDarkMode ? Colors.white : const Color(0xFF424242);
        shadowColor = isDarkMode ? Colors.black45 : Colors.black12;
        highlightColor = Color.fromRGBO(
            theme.colorScheme.primary.red,
            theme.colorScheme.primary.green,
            theme.colorScheme.primary.blue,
            0.1);
        break;
      case ModernButtonType.operator:
        buttonColor =
            isDarkMode ? const Color(0xFF22252D) : const Color(0xFFF8F8F8);
        textColor = theme.colorScheme.primary;
        shadowColor = isDarkMode
            ? Colors.black45
            : const Color(0x0D000000); // 0.05 opacity
        highlightColor = Color.fromRGBO(
            theme.colorScheme.primary.red,
            theme.colorScheme.primary.green,
            theme.colorScheme.primary.blue,
            0.15);
        break;
      case ModernButtonType.function:
        buttonColor = isDarkMode
            ? const Color(0xFF22252D)
            : Color.fromRGBO(
                theme.colorScheme.primary.red,
                theme.colorScheme.primary.green,
                theme.colorScheme.primary.blue,
                0.08);
        textColor = theme.colorScheme.secondary;
        shadowColor = isDarkMode ? Colors.black45 : const Color(0x0D000000);
        highlightColor = Color.fromRGBO(
            theme.colorScheme.secondary.red,
            theme.colorScheme.secondary.green,
            theme.colorScheme.secondary.blue,
            0.2);
        break;
      case ModernButtonType.constant:
        buttonColor = isDarkMode
            ? const Color(0xFF22252D)
            : Color.fromRGBO(
                theme.colorScheme.tertiary.red,
                theme.colorScheme.tertiary.green,
                theme.colorScheme.tertiary.blue,
                0.1);
        textColor = theme.colorScheme.tertiary;
        shadowColor = isDarkMode ? Colors.black45 : const Color(0x0D000000);
        highlightColor = Color.fromRGBO(
            theme.colorScheme.tertiary.red,
            theme.colorScheme.tertiary.green,
            theme.colorScheme.tertiary.blue,
            0.2);
        break;
      case ModernButtonType.clear:
        buttonColor = isDarkMode
            ? const Color(0xFF22252D)
            : const Color(0x12FF5252); // RedAccent with 0.07 opacity
        textColor = Colors.redAccent;
        shadowColor = isDarkMode ? Colors.black45 : const Color(0x0D000000);
        highlightColor = const Color(0x33FF5252); // RedAccent with 0.2 opacity
        break;
      case ModernButtonType.equals:
        buttonColor = theme.colorScheme.primary;
        textColor = Colors.white;
        shadowColor = Color.fromRGBO(
            theme.colorScheme.primary.red,
            theme.colorScheme.primary.green,
            theme.colorScheme.primary.blue,
            0.4);
        highlightColor = const Color(0x4DFFFFFF); // White with 0.3 opacity
        break;
    }

    // Cache border radius calculation
    final borderRadius = _getBorderRadius();

    // Optimize shadow list creation - create only when needed
    final List<BoxShadow> boxShadows;

    if (type != ModernButtonType.equals) {
      boxShadows = [
        // Bottom shadow
        BoxShadow(
          color: shadowColor,
          blurRadius: isPressed ? 3 : 8,
          spreadRadius: isPressed ? 0 : 1,
          offset: isPressed ? const Offset(0, 0) : const Offset(0, 3),
        ),
        // Top highlight
        BoxShadow(
          color: Colors.white.withOpacity(isDarkMode ? 0.05 : 0.8),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, -2),
        ),
      ];
    } else {
      boxShadows = [
        // Bottom shadow only for equals button
        BoxShadow(
          color: shadowColor,
          blurRadius: isPressed ? 3 : 8,
          spreadRadius: isPressed ? 0 : 1,
          offset: isPressed ? const Offset(0, 0) : const Offset(0, 3),
        ),
      ];
    }

    // Get cached text style
    final textStyle = _getCachedTextStyle(
        textColor, getResponsiveFontSize(), getButtonFontWeight());

    // Using RepaintBoundary for better performance
    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: (_) {
          ref.read(buttonPressStateProvider(buttonId).notifier).state = true;
          HapticFeedback.selectionClick();
        },
        onTapUp: (_) {
          ref.read(buttonPressStateProvider(buttonId).notifier).state = false;
          onPressed();
        },
        onTapCancel: () {
          ref.read(buttonPressStateProvider(buttonId).notifier).state = false;
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: borderRadius,
            boxShadow: boxShadows,
            gradient: type == ModernButtonType.equals
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                  )
                : null,
            border: Border.all(
              color: isPressed
                  ? highlightColor
                  : isDarkMode
                      ? Colors.black12
                      : Colors.white,
              width: isDarkMode ? 0.5 : 1.5,
            ),
          ),
          child: SizedBox(
            width: size,
            height: size,
            // BackdropFilter kaldırıldı - çok pahalı bir işlem, her buton için gereksiz
            child: _buildSimpleContent(
                isPressed, highlightColor, borderRadius, textStyle),
          ),
        ),
      ),
    );
  }
}
