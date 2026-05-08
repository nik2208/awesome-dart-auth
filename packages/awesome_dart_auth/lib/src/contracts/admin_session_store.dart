import 'package:awesome_dart_auth/src/contracts/session_store.dart';
import 'package:awesome_dart_auth/src/models/auth_session.dart';

/// Result of a paginated session listing operation.
typedef SessionListResult = ({List<AuthSession> sessions, int total});

/// Extended [SessionStore] with admin-only list and revoke-by-handle capability.
///
/// Implement this interface (in addition to [SessionStore]) to enable the
/// Sessions tab in the embedded admin panel.
abstract interface class AdminSessionStore implements SessionStore {
  /// Returns a paginated, optionally filtered list of all sessions.
  ///
  /// [filter] is applied as a case-insensitive substring match against userId,
  /// handle, and userAgent.
  Future<SessionListResult> listAllSessions({
    int limit = 20,
    int offset = 0,
    String? filter,
  });

  /// Revokes the session identified by [handle] (the human-readable device
  /// handle, not the internal session id).
  Future<void> revokeByHandle(String handle);
}
