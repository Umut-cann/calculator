import 'package:hive/hive.dart';

part 'calculation_model.g.dart';

@HiveType(typeId: 0)
class CalculationModel extends HiveObject {
  @HiveField(0)
  final String expression;
  
  @HiveField(1)
  final String result;
  
  @HiveField(2)
  final DateTime createdAt;

  CalculationModel({
    required this.expression,
    required this.result,
    required this.createdAt,
  });
}
