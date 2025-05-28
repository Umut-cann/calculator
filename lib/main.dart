import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants.dart';
import 'data/models/calculation_model.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/calculator_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive - using a separate isolate would be better but requires more setup
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(CalculationModelAdapter());
  
  // Only open essential boxes immediately
  await Hive.openBox('app_settings');
  
  // Run the app
  runApp(const ProviderScope(child: CalculatorApp()));
  
  // Defer opening history box until after UI is rendered
  Future.delayed(const Duration(milliseconds: 300), () async {
    await Hive.openBox<CalculationModel>('calculations');
  });
}

class CalculatorApp extends ConsumerWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current theme from the provider
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'Scientific Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppConstants.lightTheme,
      darkTheme: AppConstants.darkTheme,
      home: const CalculatorScreen(),
    );
  }
}
