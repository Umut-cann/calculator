import '../../data/datasources/calculation_datasource.dart';
import '../entities/calculation.dart';

class GetHistoryUseCase {
  final CalculationDataSource _dataSource;

  GetHistoryUseCase(this._dataSource);

  List<Calculation> execute() {
    final calculationModels = _dataSource.getAllCalculations();
    
    return calculationModels.map((model) => Calculation(
      expression: model.expression,
      result: model.result,
      createdAt: model.createdAt,
    )).toList();
  }
}
