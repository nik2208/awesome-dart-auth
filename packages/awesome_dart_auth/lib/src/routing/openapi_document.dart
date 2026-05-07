import '../config/auth_config.dart';

/// Generates an OpenAPI document for the built-in auth routes.
Map<String, Object?> buildOpenApiDocument(AuthConfig config) => {
  'openapi': '3.1.0',
  'info': {
    'title': 'awesome-dart-auth',
    'version': '0.1.0',
  },
  'paths': {
    config.adminUiPath: {
      'get': {'summary': 'Serve the embedded admin UI'},
    },
    config.authUiPath: {
      'get': {'summary': 'Serve the embedded auth UI'},
    },
    config.authJsPath: {
      'get': {'summary': 'Serve the embedded browser SDK'},
    },
    config.discoveryPath: {
      'get': {'summary': 'Serve the OIDC discovery document'},
    },
    config.jwksPath: {
      'get': {'summary': 'Serve the JSON Web Key Set'},
    },
    config.tokenPath: {
      'post': {'summary': 'Issue a demo access + refresh token pair'},
    },
    config.userInfoPath: {
      'get': {'summary': 'Return demo user info based on the bearer token'},
    },
  },
};
