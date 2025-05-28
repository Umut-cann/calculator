import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_state.dart';
import 'calculator_button.dart';

class Keypad extends ConsumerWidget {
  const Keypad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    
    return isLandscape 
      ? _buildLandscapeKeypad(context, ref)
      : _buildPortraitKeypad(context, ref);
  }
  
  Widget _buildPortraitKeypad(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Scientific functions row
          Expanded(
            child: Row(
              children: [
                _buildButton(context, ref, 'sin', type: ButtonType.function),
                _buildButton(context, ref, 'cos', type: ButtonType.function),
                _buildButton(context, ref, 'tan', type: ButtonType.function),
                _buildButton(context, ref, 'π', type: ButtonType.constant),
                _buildButton(context, ref, 'e', type: ButtonType.constant),
              ],
            ),
          ),
          // Additional functions
          Expanded(
            child: Row(
              children: [
                _buildButton(context, ref, 'log', type: ButtonType.function),
                _buildButton(context, ref, 'ln', type: ButtonType.function),
                _buildButton(context, ref, '√', type: ButtonType.function),
                _buildButton(context, ref, '^', type: ButtonType.operator),
                _buildButton(context, ref, '!', type: ButtonType.operator),
              ],
            ),
          ),
          // First row of numbers/operations
          Expanded(
            child: Row(
              children: [
                _buildButton(context, ref, '(', type: ButtonType.operator),
                _buildButton(context, ref, ')', type: ButtonType.operator),
                _buildButton(context, ref, '%', type: ButtonType.operator),
                _buildButton(context, ref, 'AC', type: ButtonType.clear),
                _buildButton(context, ref, '⌫', type: ButtonType.clear),
              ],
            ),
          ),
          // Second row
          Expanded(
            child: Row(
              children: [
                _buildButton(context, ref, '7', type: ButtonType.number),
                _buildButton(context, ref, '8', type: ButtonType.number),
                _buildButton(context, ref, '9', type: ButtonType.number),
                _buildButton(context, ref, '÷', type: ButtonType.operator),
              ],
            ),
          ),
          // Third row
          Expanded(
            child: Row(
              children: [
                _buildButton(context, ref, '4', type: ButtonType.number),
                _buildButton(context, ref, '5', type: ButtonType.number),
                _buildButton(context, ref, '6', type: ButtonType.number),
                _buildButton(context, ref, '×', type: ButtonType.operator),
              ],
            ),
          ),
          // Fourth row
          Expanded(
            child: Row(
              children: [
                _buildButton(context, ref, '1', type: ButtonType.number),
                _buildButton(context, ref, '2', type: ButtonType.number),
                _buildButton(context, ref, '3', type: ButtonType.number),
                _buildButton(context, ref, '-', type: ButtonType.operator),
              ],
            ),
          ),
          // Fifth row
          Expanded(
            child: Row(
              children: [
                _buildButton(context, ref, '0', type: ButtonType.number),
                _buildButton(context, ref, '.', type: ButtonType.number),
                _buildButton(context, ref, '=', type: ButtonType.equals),
                _buildButton(context, ref, '+', type: ButtonType.operator),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLandscapeKeypad(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Left section - Scientific functions
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, 'sin', type: ButtonType.function),
                      _buildButton(context, ref, 'cos', type: ButtonType.function),
                      _buildButton(context, ref, 'tan', type: ButtonType.function),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, 'log', type: ButtonType.function),
                      _buildButton(context, ref, 'ln', type: ButtonType.function),
                      _buildButton(context, ref, '√', type: ButtonType.function),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, 'π', type: ButtonType.constant),
                      _buildButton(context, ref, 'e', type: ButtonType.constant),
                      _buildButton(context, ref, '!', type: ButtonType.operator),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, '(', type: ButtonType.operator),
                      _buildButton(context, ref, ')', type: ButtonType.operator),
                      _buildButton(context, ref, '^', type: ButtonType.operator),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right section - Numbers and basic operators
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, 'AC', type: ButtonType.clear),
                      _buildButton(context, ref, '⌫', type: ButtonType.clear),
                      _buildButton(context, ref, '%', type: ButtonType.operator),
                      _buildButton(context, ref, '÷', type: ButtonType.operator),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, '7', type: ButtonType.number),
                      _buildButton(context, ref, '8', type: ButtonType.number),
                      _buildButton(context, ref, '9', type: ButtonType.number),
                      _buildButton(context, ref, '×', type: ButtonType.operator),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, '4', type: ButtonType.number),
                      _buildButton(context, ref, '5', type: ButtonType.number),
                      _buildButton(context, ref, '6', type: ButtonType.number),
                      _buildButton(context, ref, '-', type: ButtonType.operator),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, '1', type: ButtonType.number),
                      _buildButton(context, ref, '2', type: ButtonType.number),
                      _buildButton(context, ref, '3', type: ButtonType.number),
                      _buildButton(context, ref, '+', type: ButtonType.operator),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(context, ref, '0', type: ButtonType.number, flex: 2),
                      _buildButton(context, ref, '.', type: ButtonType.number),
                      _buildButton(context, ref, '=', type: ButtonType.equals),
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
  
  Widget _buildButton(
    BuildContext context, 
    WidgetRef ref, 
    String text, 
    {required ButtonType type, int flex = 1}
  ) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CalculatorButton(
          text: text,
          type: type,
          onPressed: () => _handleButtonPress(text, type, ref),
        ),
      ),
    );
  }
  
  void _handleButtonPress(String text, ButtonType type, WidgetRef ref) {
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
      default:
        notifier.addInput(text);
        break;
    }
  }
}
