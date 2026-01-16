import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_words/features/auth/domain/entities/account_boost_entity.dart';
import 'package:hive/hive.dart';

part 'account_boost_model.g.dart';

@HiveType(typeId: 7)
enum AccountBoostType {
  @HiveField(0)
  minutes,
  @HiveField(1)
  stages;

  // Helper to convert to string for Firestore
  String toJson() => name;

  // Helper to create from string
  static AccountBoostType fromJson(String value) {
    return AccountBoostType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => AccountBoostType.stages,
    );
  }
}

@HiveType(typeId: 8)
class AccountBoostModel extends AccountBoostEntity {
  @HiveField(0)
  @override
  final String activeKey;

  @HiveField(1)
  @override
  final AccountBoostType type;

  @HiveField(2)
  @override
  final int multiplier;

  @HiveField(3)
  @override
  final int totalAmount;

  @HiveField(4)
  @override
  final int remainingAmount;

  @HiveField(5)
  @override
  final DateTime activatedAt;

  AccountBoostModel({
    required this.activeKey,
    required this.type,
    required this.multiplier,
    required this.totalAmount,
    required this.remainingAmount,
    required this.activatedAt,
  }) : super(
         activeKey: activeKey,
         type: type,
         multiplier: multiplier,
         totalAmount: totalAmount,
         remainingAmount: remainingAmount,
         activatedAt: activatedAt,
       );

  // Convert from entity to model
  factory AccountBoostModel.fromEntity(AccountBoostEntity entity) {
    return AccountBoostModel(
      activeKey: entity.activeKey,
      type: entity.type,
      multiplier: entity.multiplier,
      totalAmount: entity.totalAmount,
      remainingAmount: entity.remainingAmount,
      activatedAt: entity.activatedAt,
    );
  }

  // Factory to create a new boost
  factory AccountBoostModel.activate({
    required String activekey,
    required AccountBoostType type,
    required int multiplier,
    required int amount,
  }) {
    return AccountBoostModel(
      activeKey: activekey,
      type: type,
      multiplier: multiplier,
      totalAmount: amount,
      remainingAmount: amount,
      activatedAt: DateTime.now(),
    );
  }

  // ✅ Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'activeKey': activeKey,
      'type': type.toJson(), // Store as string: "minutes" or "stages"
      'multiplier': multiplier,
      'totalAmount': totalAmount,
      'remainingAmount': remainingAmount,
      'activatedAt': Timestamp.fromDate(activatedAt), // Firestore timestamp
    };
  }

  // ✅ Create from Map (Firestore)
  factory AccountBoostModel.fromMap(Map<String, dynamic> map) {
    return AccountBoostModel(
      activeKey: map['activeKey'] as String,
      type: AccountBoostType.fromJson(map['type'] as String),
      multiplier: map['multiplier'] as int? ?? 2,
      totalAmount: map['totalAmount'] as int? ?? 0,
      remainingAmount: map['remainingAmount'] as int? ?? 0,
      activatedAt:
          (map['activatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  AccountBoostModel decrementStage() {
    if (type != AccountBoostType.stages) return this;
    return AccountBoostModel(
      activeKey: activeKey,
      type: type,
      multiplier: multiplier,
      totalAmount: totalAmount,
      remainingAmount: (remainingAmount - 1).clamp(0, totalAmount),
      activatedAt: activatedAt,
    );
  }
}
