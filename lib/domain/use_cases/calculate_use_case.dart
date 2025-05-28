import 'package:math_expressions/math_expressions.dart';

class CalculateUseCase {
  String execute(String expression, bool isRadianMode) {
    if (expression.isEmpty) {
      return '0';
    }
    
    try {
      // Replace scientific notation and constants
      String expr = expression;
      expr = expr.replaceAll('×', '*');
      expr = expr.replaceAll('÷', '/');
      expr = expr.replaceAll('π', '3.1415926535897932');
      expr = expr.replaceAll('e', '2.718281828459045');
      
      // Handle trigonometric functions
      expr = _handleTrigFunctions(expr, isRadianMode);
      
      // Parse and evaluate
      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      // Format result
      if (eval == eval.roundToDouble()) {
        return eval.toInt().toString();
      } else {
        return eval.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      return 'Error';
    }
  }
  
  // Handle trigonometric functions with degree/radian conversion
  String _handleTrigFunctions(String expr, bool isRadianMode) {
    // Regular expressions for trigonometric functions
    final sinRegex = RegExp(r'sin\(([^)]+)\)');
    final cosRegex = RegExp(r'cos\(([^)]+)\)');
    final tanRegex = RegExp(r'tan\(([^)]+)\)');
    
    // Convert angles if in degree mode
    if (!isRadianMode) {
      expr = sinRegex.allMatches(expr).fold(expr, (prev, match) {
        final angle = match.group(1)!;
        return prev.replaceFirst(
          sinRegex, 
          'sin(($angle) * 0.01745329251994329577)' // π/180
        );
      });
      
      expr = cosRegex.allMatches(expr).fold(expr, (prev, match) {
        final angle = match.group(1)!;
        return prev.replaceFirst(
          cosRegex, 
          'cos(($angle) * 0.01745329251994329577)'
        );
      });
      
      expr = tanRegex.allMatches(expr).fold(expr, (prev, match) {
        final angle = match.group(1)!;
        return prev.replaceFirst(
          tanRegex, 
          'tan(($angle) * 0.01745329251994329577)'
        );
      });
    }
    
    return expr;
  }
}
