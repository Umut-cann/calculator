import 'package:flutter/material.dart';

enum NeumorphicShape {
  flat,
  concave,
  convex,
  pressed,
}

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double depth;
  final double borderRadius;
  final NeumorphicShape shape;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.depth = 4.0,
    this.borderRadius = 12.0,
    this.shape = NeumorphicShape.flat,
    this.padding = const EdgeInsets.all(12.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Adjust colors based on light/dark mode
    final baseColor = isDarkMode ? const Color(0xFF2D2D2D) : color;
    final shadowDarkColor = isDarkMode 
        ? Colors.black 
        : Colors.black.withOpacity(0.3);
    final shadowLightColor = isDarkMode 
        ? Colors.grey.shade800 
        : Colors.white.withOpacity(0.8);
    
    // Define offset and blur based on shape
    Offset darkShadowOffset;
    Offset lightShadowOffset;
    double blurRadius;
    
    switch (shape) {
      case NeumorphicShape.concave:
        darkShadowOffset = Offset(-depth / 2, -depth / 2);
        lightShadowOffset = Offset(depth / 2, depth / 2);
        blurRadius = depth;
        break;
      case NeumorphicShape.convex:
        darkShadowOffset = Offset(depth / 2, depth / 2);
        lightShadowOffset = Offset(-depth / 2, -depth / 2);
        blurRadius = depth;
        break;
      case NeumorphicShape.pressed:
        darkShadowOffset = Offset(depth / 3, depth / 3);
        lightShadowOffset = Offset(-depth / 3, -depth / 3);
        blurRadius = depth / 2;
        break;
      case NeumorphicShape.flat:
      default:
        darkShadowOffset = Offset(depth / 2, depth / 2);
        lightShadowOffset = Offset(-depth / 2, -depth / 2);
        blurRadius = depth;
        break;
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            // Dark shadow
            BoxShadow(
              color: shadowDarkColor,
              offset: darkShadowOffset,
              blurRadius: blurRadius,
            ),
            // Light shadow
            BoxShadow(
              color: shadowLightColor,
              offset: lightShadowOffset,
              blurRadius: blurRadius,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
