import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String category;

  @HiveField(5)
  bool isIncome;

  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  });
}

enum TransactionCategory {
  food('Ăn uống'),
  shopping('Mua sắm'),
  transport('Đi lại'),
  entertainment('Giải trí'),
  health('Sức khỏe'),
  education('Giáo dục'),
  salary('Lương'),
  other('Khác');

  final String displayName;
  const TransactionCategory(this.displayName);
}
