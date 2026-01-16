import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/services/store_discount_service.dart';
import 'package:find_the_words/features/freeze/freeze_cubit/freeze_cubit.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/store/data/models/reward_type.dart';

abstract class RewardAdUseCase {
  Future<void> execute();
}

class EarnPointsUseCase implements RewardAdUseCase {
  final int points;

  EarnPointsUseCase({required this.points});

  @override
  Future<void> execute() async {
    final pointsCubit = getIt<PointsCubit>();

    await pointsCubit.addPoints(
      points,
      reason: 'Watched rewarded ad - Earn points',
    );
  }
}

class StoreDiscountUseCase implements RewardAdUseCase {
  final int discountPercentage;

  StoreDiscountUseCase({required this.discountPercentage});

  @override
  Future<void> execute() async {
    final discountService = getIt<StoreDiscountService>();

    await discountService.activateDiscount(
      percentage: discountPercentage,
    );
  }
}

class FreezeRewardUseCase implements RewardAdUseCase {
  final int freezeCount;

  FreezeRewardUseCase({required this.freezeCount});

  @override
  Future<void> execute() async {
    final freezeCubit = getIt<FreezeCubit>();
    freezeCubit.incrementTotalFreezes(freezeCount);
    freezeCubit.recordFreeAdWatched();
  }
}

class RewardUseCaseFactory {
  static RewardAdUseCase create({required RewardConfig config}) {
    switch (config.type) {
      case RewardType.earnPoints:
        return EarnPointsUseCase(points: config.amount);

      case RewardType.storeDiscount:
        return StoreDiscountUseCase(discountPercentage: config.amount);

      case RewardType.freeze:
        return FreezeRewardUseCase(freezeCount: config.amount);
    }
  }
}
