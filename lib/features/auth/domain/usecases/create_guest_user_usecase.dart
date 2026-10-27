import 'package:find_the_words/core/di/env.dart';
import 'package:find_the_words/core/services/auth_service.dart';
import 'package:find_the_words/core/utils/token_utils.dart';
import 'package:find_the_words/features/auth/domain/entities/user_entity.dart';
import 'package:find_the_words/features/auth/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
@Environment(Env.minimal)
class CreateGuestUserUsecase {
  final UserRepository _userRepo;

  CreateGuestUserUsecase(this._userRepo);

  Future<UserEntity> call() async {
    final newToken = TokenUtils.generateGuestToken();
    await AuthService.instance.saveToken(newToken);
    return _userRepo.createUser(newToken);
  }
}
