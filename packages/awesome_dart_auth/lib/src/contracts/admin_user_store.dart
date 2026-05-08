import 'package:awesome_dart_auth/src/contracts/user_store.dart';
import 'package:awesome_dart_auth/src/models/auth_user.dart';

/// Result of a paginated user listing operation.
typedef UserListResult = ({List<AuthUser> users, int total});

/// Extended [UserStore] with admin-only list capability.
///
/// Implement this interface (in addition to [UserStore]) to enable the
/// Users tab in the embedded admin panel.
abstract interface class AdminUserStore implements UserStore {
  /// Returns a paginated, optionally filtered list of users.
  ///
  /// [filter] is applied as a case-insensitive substring match against email
  /// and id. Pass `null` to return all users.
  Future<UserListResult> listUsers({
    int limit = 20,
    int offset = 0,
    String? filter,
  });
}
