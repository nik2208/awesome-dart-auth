import '../config/auth_config.dart';

/// Builds a minimal OIDC discovery document.
Map<String, Object?> openIdDiscoveryDocument(AuthConfig config) => {
  'issuer': config.issuer,
  'authorization_endpoint': '${config.issuer}${config.authorizationPath}',
  'token_endpoint': '${config.issuer}${config.tokenPath}',
  'userinfo_endpoint': '${config.issuer}${config.userInfoPath}',
  'jwks_uri': '${config.issuer}${config.jwksPath}',
  'response_types_supported': const ['code', 'token'],
  'subject_types_supported': const ['public'],
  'id_token_signing_alg_values_supported': const ['HS256'],
  'scopes_supported': const ['openid', 'profile', 'email', 'offline_access'],
  'token_endpoint_auth_methods_supported': const ['client_secret_post'],
};

/// Builds a placeholder JWKS document for symmetric signing deployments.
Map<String, Object?> jsonWebKeySet() => const <String, Object?>{
  'keys': <Object>[],
};
