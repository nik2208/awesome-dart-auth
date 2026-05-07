import 'package:awesome_dart_auth/src/models/auth_user.dart';
import 'package:awesome_dart_auth/src/models/oauth_profile.dart';

/// Callback type invoked after a new user successfully registers.
typedef OnRegisterCallback =
    Future<AuthUser> Function(AuthUser user);

/// Callback type invoked to send a password-reset email.
///
/// Implementations should dispatch an email containing [token] to
/// [user.email].
typedef OnForgotPasswordCallback =
    Future<void> Function(AuthUser user, String token);

/// Callback type invoked to send an email-verification message.
typedef OnSendVerificationEmailCallback =
    Future<void> Function(AuthUser user, String token);

/// Callback type invoked to send a magic-link email.
typedef OnMagicLinkSendCallback =
    Future<void> Function(AuthUser user, String token);

/// Callback type invoked to verify a magic-link token.
///
/// Return the owner's user-id on success, or `null` on failure.
typedef OnMagicLinkVerifyCallback =
    Future<String?> Function(String token, String mode);

/// Callback type invoked to dispatch an SMS OTP.
typedef OnSmsSendCallback =
    Future<void> Function(AuthUser user, String otp);

/// Callback type invoked to verify an SMS OTP code.
///
/// Return `true` when the code is correct.
typedef OnSmsVerifyCallback =
    Future<bool> Function(AuthUser user, String code);

/// Callback type invoked to initiate a provider OAuth flow.
///
/// Return the provider's authorization URL to redirect the browser to.
typedef OnOAuthStartCallback =
    Future<String> Function(String provider, String redirectUri);

/// Callback type invoked when the provider redirects back after OAuth.
///
/// Implementations must exchange [code] for tokens and return the
/// normalised [OAuthProfile].
typedef OnOAuthCallbackCallback =
    Future<OAuthProfile> Function(
      String provider,
      String code,
      String redirectUri,
    );

/// Callback type invoked to initiate account linking.
///
/// Return a unique token identifying the pending request.
typedef OnLinkRequestCallback =
    Future<String> Function(
      AuthUser user,
      String provider,
      Map<String, Object?> data,
    );

/// Callback type invoked to verify an account-link token.
///
/// Return `true` when the token is valid and the accounts were linked.
typedef OnLinkVerifyCallback =
    Future<bool> Function(AuthUser user, String token, String provider);

/// Holds all optional side-effect callbacks for the auth routes.
///
/// Supply any combination of these callbacks to [AuthConfig] to enable
/// the corresponding auth flows.  Any callback that is left as `null`
/// will cause the associated route to return **501 Not Implemented**.
class AuthCallbacks {
  /// Creates a callbacks container.
  const AuthCallbacks({
    this.onRegister,
    this.onForgotPassword,
    this.onSendVerificationEmail,
    this.onMagicLinkSend,
    this.onMagicLinkVerify,
    this.onSmsSend,
    this.onSmsVerify,
    this.onOAuthStart,
    this.onOAuthCallback,
    this.onLinkRequest,
    this.onLinkVerify,
  });

  /// Called after successful registration.
  final OnRegisterCallback? onRegister;

  /// Called to send a password-reset email.
  final OnForgotPasswordCallback? onForgotPassword;

  /// Called to send an email-verification message.
  final OnSendVerificationEmailCallback? onSendVerificationEmail;

  /// Called to send a magic-link email.
  final OnMagicLinkSendCallback? onMagicLinkSend;

  /// Called to verify a magic-link token.
  final OnMagicLinkVerifyCallback? onMagicLinkVerify;

  /// Called to dispatch an SMS OTP.
  final OnSmsSendCallback? onSmsSend;

  /// Called to verify an SMS OTP code.
  final OnSmsVerifyCallback? onSmsVerify;

  /// Called to initiate a provider OAuth flow.
  final OnOAuthStartCallback? onOAuthStart;

  /// Called when the provider redirects back after OAuth.
  final OnOAuthCallbackCallback? onOAuthCallback;

  /// Called to initiate account linking.
  final OnLinkRequestCallback? onLinkRequest;

  /// Called to verify an account-link token.
  final OnLinkVerifyCallback? onLinkVerify;
}
