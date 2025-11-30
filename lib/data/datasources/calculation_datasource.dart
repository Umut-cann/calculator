import 'package:hive/hive.dart';
import '../models/calculation_model.dart';

class CalculationDataSource {
  final String boxName = 'calculations';
  
  // Initialize Hive
  Future<void> init() async {
    // Register the adapter for CalculationModel
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CalculationModelAdapter());
    }
    
    // Open the box
    await Hive.openBox<CalculationModel>(boxName);
  }
  
  // Get all calculations
  List<CalculationModel> getAllCalculations() {
    final box = Hive.box<CalculationModel>(boxName);
    return box.values.toList();
  }
  
  // Add a calculation
  Future<void> addCalculation(CalculationModel calculation) async {
    final box = Hive.box<CalculationModel>(boxName);
    await box.add(calculation);
  }
  
  // Clear history
  Future<void> clearHistory() async {
    final box = Hive.box<CalculationModel>(boxName);
    await box.clear();
  }
}
