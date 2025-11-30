import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants.dart';
import 'data/models/calculation_model.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/calculator_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapter
  await Hive.initFlutter();
  Hive.registerAdapter(CalculationModelAdapter());

  // Open essential settings box
  await Hive.openBox('app_settings');

  // Run the app first
  runApp(const ProviderScope(child: CalculatorApp()));

  // Open history box after first frame (safest and performant)
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _openCalculationBox();
  });
}

// Separate method for deferred box opening
Future<void> _openCalculationBox() async {
  try {
    if (!Hive.isBoxOpen('calculations')) {
      await Hive.openBox<CalculationModel>('calculations');
    }
  } catch (e) {
    debugPrint('❌ Error opening calculations box: $e');
  }
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
