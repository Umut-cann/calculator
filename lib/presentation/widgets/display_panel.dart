import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Using system fonts instead of Google Fonts
import '../providers/calculator_state.dart';

class DisplayPanel extends ConsumerWidget {
  const DisplayPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculatorState = ref.watch(calculatorProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Use const for unchanging widget parts and add RepaintBoundary for better performance
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF9FFF9), // Slight green tint for light mode
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          // Simplified box shadow for better performance
          boxShadow: [
            BoxShadow(
              color: isDarkMode 
                  ? Colors.black.withOpacity(0.2) 
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: isDarkMode 
                ? Colors.black54 
                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Expression
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                calculatorState.expression.isEmpty ? '0' : calculatorState.expression,
                style: TextStyle(
                  fontSize: 28,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Result
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                // Only show error message when hasError flag is true
                calculatorState.hasError ? 'Error' : calculatorState.result,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: calculatorState.hasError 
                      ? Colors.red.shade700 // Red color for errors
                      : Theme.of(context).colorScheme.primary,
                  shadows: [
                    Shadow(
                      color: calculatorState.hasError
                          ? Colors.red.withOpacity(0.3)
                          : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            // Angle mode indicator
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  calculatorState.isRadianMode ? 'RAD' : 'DEG',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
