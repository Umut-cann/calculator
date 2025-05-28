import 'package:flutter/material.dart';
import 'neumorphic_container.dart';

enum ButtonType {
  number,
  operator,
  function,
  constant,
  clear,
  equals,
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final ButtonType type;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Define colors based on button type and theme
    Color buttonColor;
    Color textColor;
    
    switch (type) {
      case ButtonType.number:
        // White buttons with dark text for numbers
        buttonColor = isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
        textColor = isDarkMode ? Colors.white : const Color(0xFF424242);
        break;
      case ButtonType.operator:
        // Light gray buttons with green text for operators
        buttonColor = isDarkMode ? const Color(0xFF22252D) : const Color(0xFFF8F8F8);
        textColor = Theme.of(context).colorScheme.primary;
        break;
      case ButtonType.function:
        // Light gray buttons with medium green text for functions
        buttonColor = isDarkMode ? const Color(0xFF22252D) : const Color(0xFFF5F5F5);
        textColor = Theme.of(context).colorScheme.secondary;
        break;
      case ButtonType.constant:
        // Light gray buttons with light green text for constants
        buttonColor = isDarkMode ? const Color(0xFF22252D) : const Color(0xFFF5F5F5);
        textColor = Theme.of(context).colorScheme.tertiary;
        break;
      case ButtonType.clear:
        // Light gray buttons with red text for clear buttons
        buttonColor = isDarkMode ? const Color(0xFF22252D) : const Color(0xFFF5F5F5);
        textColor = Colors.redAccent;
        break;
      case ButtonType.equals:
        // Green button with white text for equals
        buttonColor = Theme.of(context).colorScheme.primary;
        textColor = Colors.white;
        break;
    }
    
    // Choose shape based on button type
    final shape = type == ButtonType.equals || type == ButtonType.clear
        ? NeumorphicShape.flat
        : NeumorphicShape.concave;
    
    return NeumorphicContainer(
      color: buttonColor,
      depth: 4,
      borderRadius: 12,
      shape: shape,
      padding: const EdgeInsets.all(0),
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: type == ButtonType.function ? 16 : 22,
            fontWeight: FontWeight.w600,
            color: textColor,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}
