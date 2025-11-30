import '../../data/datasources/calculation_datasource.dart';
import '../../data/models/calculation_model.dart';
import '../entities/calculation.dart';

class SaveHistoryUseCase {
  final CalculationDataSource _dataSource;

  SaveHistoryUseCase(this._dataSource);

  Future<void> execute(Calculation calculation) async {
    final calculationModel = CalculationModel(
      expression: calculation.expression,
      result: calculation.result,
      createdAt: calculation.createdAt,
    );
    
    await _dataSource.addCalculation(calculationModel);
  }
}
