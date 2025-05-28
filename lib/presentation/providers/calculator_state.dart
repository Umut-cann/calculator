import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:hive/hive.dart';
import '../../data/models/calculation_model.dart';

// Define the calculator state
class CalculatorState {
  final String expression;
  final String result;
  final bool isRadianMode;
  final List<String> history;
  final bool hasError;

  CalculatorState({
    this.expression = '',
    this.result = '0',
    this.isRadianMode = true,
    this.history = const [],
    this.hasError = false,
  });

  CalculatorState copyWith({
    String? expression,
    String? result,
    bool? isRadianMode,
    List<String>? history,
    bool? hasError,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      isRadianMode: isRadianMode ?? this.isRadianMode,
      history: history ?? this.history,
      hasError: hasError ?? this.hasError,
    );
  }
}

// Calculator Notifier (Presenter)
class CalculatorNotifier extends Notifier<CalculatorState> {
  // Pre-compile regex patterns for better performance
  static final RegExp _sinRegex = RegExp(r'sin\(([^)]+)\)');
  static final RegExp _cosRegex = RegExp(r'cos\(([^)]+)\)');
  static final RegExp _tanRegex = RegExp(r'tan\(([^)]+)\)');
  static final RegExp _logRegex = RegExp(r'log\(([^)]+)\)');
  static final RegExp _lnRegex = RegExp(r'ln\(([^)]+)\)');
  static final RegExp _sqrtRegex = RegExp(r'sqrt\(([^)]+)\)');
  
  // Constants
  static const double _pi = 3.1415926535897932;
  static const double _e = 2.718281828459045;
  static const double _degToRad = 0.01745329251994329577; // π/180
  @override
  CalculatorState build() => CalculatorState();

  // Add input to the expression
  void addInput(String input) {
    String newExpression = state.expression;
    
    // Handle special cases
    if (input == 'π') {
      newExpression += 'π';
    } else if (input == 'e') {
      newExpression += 'e';
    } else {
      newExpression += input;
    }
    
    // Reset error state when new input is added
    state = state.copyWith(expression: newExpression, hasError: false);
    _evaluateExpression();
  }

  // Clear the calculator
  void clear() {
    // Reset to initial state (hasError is already false in the constructor)
    state = CalculatorState();
  }

  // Clear just the last entry
  void clearEntry() {
    if (state.expression.isNotEmpty) {
      state = state.copyWith(
        expression: state.expression.substring(0, state.expression.length - 1),
        hasError: false, // Reset error state when modifying the expression
      );
      _evaluateExpression();
    }
  }
  
  // Toggle between radians and degrees
  void toggleAngleMode() {
    state = state.copyWith(isRadianMode: !state.isRadianMode);
    _evaluateExpression();
  }

  // Calculate the expression
  void calculate() {
    try {
      final result = _evaluateExpression(isFinal: true);
      
      // Save to history
      if (state.expression.isNotEmpty) {
        final calculationBox = Hive.box<CalculationModel>('calculations');
        calculationBox.add(
          CalculationModel(
            expression: state.expression,
            result: result,
            createdAt: DateTime.now(),
          ),
        );
        
        // Update history list
        List<String> updatedHistory = List.from(state.history);
        updatedHistory.add('${state.expression} = $result');
        
        // Update state with result and ensure hasError is false
        state = state.copyWith(
          result: result,
          history: updatedHistory,
          hasError: false
        );
      }
    } catch (e) {
      // Set both error result and error flag
      state = state.copyWith(result: 'Error', hasError: true);
    }
  }
  
  // Evaluate the expression - optimized version
  String _evaluateExpression({bool isFinal = false}) {
    if (state.expression.isEmpty) {
      return '0';
    }
    
    try {
      // Replace scientific notation and constants
      String expr = state.expression;
      // Use cached constants for better performance
      expr = expr.replaceAll('×', '*');
      expr = expr.replaceAll('÷', '/');
      expr = expr.replaceAll('π', '$_pi');
      expr = expr.replaceAll('e', '$_e');
      
      // Handle trigonometric functions
      expr = _handleTrigFunctions(expr);
      
      // Parse and evaluate - cache parser for complex expressions
      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      // Format result
      String result;
      if (eval == eval.roundToDouble()) {
        result = eval.toInt().toString();
      } else {
        result = eval.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      
      // Only update state if not a final calculation
      if (!isFinal) {
        state = state.copyWith(result: result, hasError: false);
      }
      
      return result;
    } catch (e) {
      if (!isFinal) {
        // Just return placeholder during typing without showing error
        return ''; 
      } else {
        // Only set error state when equals button is pressed (isFinal=true)
        // We don't update state here, as the calculate method will handle it
        return 'Error';
      }
    }
  }
  
  // Handle trigonometric functions with degree/radian conversion - optimized version
  String _handleTrigFunctions(String expr) {
    // Replace ln with natural logarithm (log base e)
    expr = _lnRegex.allMatches(expr).fold(expr, (prev, match) {
      final value = match.group(1)!;
      return prev.replaceFirst(_lnRegex, 'log($value)/log($_e)');
    });
    
    // Replace log with logarithm base 10
    expr = _logRegex.allMatches(expr).fold(expr, (prev, match) {
      final value = match.group(1)!;
      return prev.replaceFirst(_logRegex, 'log($value)/log(10)');
    });
    
    // Replace sqrt with power 0.5
    expr = _sqrtRegex.allMatches(expr).fold(expr, (prev, match) {
      final value = match.group(1)!;
      return prev.replaceFirst(_sqrtRegex, '($value)^(0.5)');
    });
    
    // Convert angles if in degree mode - only apply conversions if needed
    if (!state.isRadianMode) {
      // Process all trig functions in a single pass if possible
      // Handle sine function
      expr = _sinRegex.allMatches(expr).fold(expr, (prev, match) {
        final angle = match.group(1)!;
        return prev.replaceFirst(_sinRegex, 'sin(($angle) * $_degToRad)');
      });
      
      // Handle cosine function
      expr = _cosRegex.allMatches(expr).fold(expr, (prev, match) {
        final angle = match.group(1)!;
        return prev.replaceFirst(_cosRegex, 'cos(($angle) * $_degToRad)');
      });
      
      // Handle tangent function
      expr = _tanRegex.allMatches(expr).fold(expr, (prev, match) {
        final angle = match.group(1)!;
        return prev.replaceFirst(_tanRegex, 'tan(($angle) * $_degToRad)');
      });
    }
    
    return expr;
  }
  
  // Use a previous result from history
  void useHistoryItem(String expression, String result) {
    state = state.copyWith(expression: expression, result: result);
  }
}

// Calculator Provider
final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorState>(
  () => CalculatorNotifier(),
);
