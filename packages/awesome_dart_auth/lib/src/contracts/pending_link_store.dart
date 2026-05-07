import '../models/pending_link_record.dart';

/// Persistence contract for account-linking handshakes.
abstract interface class PendingLinkStore {
  /// Persists a pending identity-provider link request.
  Future<void> save(PendingLinkRecord pendingLink);

  /// Fetches a pending identity-provider link request.
  Future<PendingLinkRecord?> findById(String id);

  /// Removes a pending identity-provider link request.
  Future<void> delete(String id);
}
