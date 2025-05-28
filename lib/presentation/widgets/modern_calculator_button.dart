import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Using system fonts instead of Google Fonts
import 'dart:ui';
import 'dart:math' show max;

enum ModernButtonType {
  number,
  operator,
  function,
  constant,
  clear,
  equals,
}

class ModernCalculatorButton extends StatefulWidget {
  final String text;
  final ModernButtonType type;
  final VoidCallback onPressed;
  final double size;

  const ModernCalculatorButton({
    super.key,
    required this.text,
    required this.type,
    required this.onPressed,
    this.size = 65.0,
  });

  @override
  State<ModernCalculatorButton> createState() => _ModernCalculatorButtonState();
}

class _ModernCalculatorButtonState extends State<ModernCalculatorButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Define colors based on button type and theme
    Color buttonColor;
    Color textColor;
    Color shadowColor;
    Color highlightColor;
    
    switch (widget.type) {
      case ModernButtonType.number:
        // Glossy white/dark buttons for numbers
        buttonColor = isDarkMode ? const Color(0xFF2A2D37) : Colors.white;
        textColor = isDarkMode ? Colors.white : const Color(0xFF424242);
        shadowColor = isDarkMode ? Colors.black45 : Colors.black12;
        highlightColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
        break;
      case ModernButtonType.operator:
        // Subtle gradient for operators
        buttonColor = isDarkMode 
            ? const Color(0xFF22252D) 
            : const Color(0xFFF8F8F8);
        textColor = Theme.of(context).colorScheme.primary;
        shadowColor = isDarkMode ? Colors.black45 : Colors.black.withOpacity(0.05);
        highlightColor = Theme.of(context).colorScheme.primary.withOpacity(0.15);
        break;
      case ModernButtonType.function:
        // Function buttons
        buttonColor = isDarkMode 
            ? const Color(0xFF22252D) 
            : Theme.of(context).colorScheme.primary.withOpacity(0.08);
        textColor = Theme.of(context).colorScheme.secondary;
        shadowColor = isDarkMode ? Colors.black45 : Colors.black.withOpacity(0.05);
        highlightColor = Theme.of(context).colorScheme.secondary.withOpacity(0.2);
        break;
      case ModernButtonType.constant:
        // Special constants (π, e)
        buttonColor = isDarkMode 
            ? const Color(0xFF22252D) 
            : Theme.of(context).colorScheme.tertiary.withOpacity(0.1);
        textColor = Theme.of(context).colorScheme.tertiary;
        shadowColor = isDarkMode ? Colors.black45 : Colors.black.withOpacity(0.05);
        highlightColor = Theme.of(context).colorScheme.tertiary.withOpacity(0.2);
        break;
      case ModernButtonType.clear:
        // Clear buttons
        buttonColor = isDarkMode 
            ? const Color(0xFF22252D) 
            : Colors.redAccent.withOpacity(0.07);
        textColor = Colors.redAccent;
        shadowColor = isDarkMode ? Colors.black45 : Colors.black.withOpacity(0.05);
        highlightColor = Colors.redAccent.withOpacity(0.2);
        break;
      case ModernButtonType.equals:
        // Green gradient button for equals
        buttonColor = Theme.of(context).colorScheme.primary;
        textColor = Colors.white;
        shadowColor = Theme.of(context).colorScheme.primary.withOpacity(0.4);
        highlightColor = Colors.white.withOpacity(0.3);
        break;
    }
    
    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _animationController.forward();
          HapticFeedback.selectionClick();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _animationController.reverse();
          widget.onPressed();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _animationController.reverse();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(widget.type == ModernButtonType.equals ? 24 : 18),
            boxShadow: [
              // Bottom shadow
              BoxShadow(
                color: shadowColor,
                blurRadius: _isPressed ? 3 : 8,
                spreadRadius: _isPressed ? 0 : 1,
                offset: _isPressed 
                    ? const Offset(0, 0)
                    : const Offset(0, 3),
              ),
              // Top highlight (if not equals button)
              if (widget.type != ModernButtonType.equals)
                BoxShadow(
                  color: Colors.white.withOpacity(isDarkMode ? 0.05 : 0.8),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, -2),
                ),
            ],
            gradient: widget.type == ModernButtonType.equals
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  )
                : null,
            border: Border.all(
              color: _isPressed
                  ? highlightColor
                  : isDarkMode
                      ? Colors.black12
                      : Colors.white,
              width: isDarkMode ? 0.5 : 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.type == ModernButtonType.equals ? 24 : 18),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: _isPressed 
                      ? highlightColor 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(widget.type == ModernButtonType.equals ? 24 : 18),
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(),
                      fontWeight: getButtonFontWeight(),
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
  
  double getButtonFontSize() {
    // Adjust font size based on button type
    switch (widget.type) {
      case ModernButtonType.function:
        return 20.0;
      case ModernButtonType.operator:
        return 24.0;
      case ModernButtonType.equals:
        return 28.0;
      case ModernButtonType.clear:
        return widget.text == 'AC' ? 18.0 : 24.0;
      default:
        return 22.0;
    }
  }
  
  // Responsive font size that scales with the button size
  double _getResponsiveFontSize() {
    // Base font size adjusted by button size ratio
    final baseSize = getButtonFontSize();
    final sizeRatio = widget.size / 65.0; // 65.0 is the default button size
    
    // Ensure text isn't too small on smaller screens
    return max(baseSize * sizeRatio, 14.0);
  }
  
  FontWeight getButtonFontWeight() {
    // Adjust font weight based on button type
    switch (widget.type) {
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
}
