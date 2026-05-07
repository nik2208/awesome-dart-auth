# awesome-dart-auth

Idiomatic Dart authentication for **server-side** backends built with Shelf and Dart Frog.

> **Important:** `awesome-dart-auth` is a server-side package. Flutter client support continues through the existing `awesome-node-auth-flutter` client package.

## Monorepo layout

- `packages/awesome_dart_auth` — framework-agnostic core
- `packages/awesome_dart_auth_shelf` — Shelf adapter
- `packages/awesome_dart_auth_dart_frog` — Dart Frog adapter
- `examples/shelf_mongodb` — Shelf integration example
- `examples/dart_frog_postgres` — Dart Frog integration example

## Feature coverage

The core package currently ships the primitives required to model the awesome-node-auth architecture:

- `AuthConfig` with validation, named constructors, and `copyWith`
- database-agnostic store contracts with dartdoc comments
- JWT access/refresh token issuing via `dart_jsonwebtoken`
- password hashing via `bcrypt`
- TOTP generation via `otp`
- HMAC webhook signing via `crypto`
- embedded Admin UI, Auth UI, and `auth.js`
- Mustache mail templating with built-in `en` and `it` locales
- event bus and telemetry hooks
- inbound webhook action registry sandboxed with `Isolate.run`
- OIDC discovery + JWKS + token/userinfo route scaffolding
- auto-generated OpenAPI document for the built-in routes

## Compatibility note

This repository mirrors the **route shape and token conventions** expected by the existing Angular and Flutter clients where implemented.

### Explicit deviations

The initial Dart implementation in this repository provides the shared configuration, service, routing, UI, templating, and adapter infrastructure, but does **not** yet provide a production-complete implementation of every awesome-node-auth endpoint (for example full OAuth provider flows, SMS delivery, refresh-token revocation persistence, or a complete admin SPA).

Those remaining pieces are intentionally exposed behind abstract stores and integration points so they can be completed without changing the public package layout introduced here.

## Getting started

```bash
/tmp/dart-sdk/bin/dart pub get
/tmp/dart-sdk/bin/dart run melos bootstrap
/tmp/dart-sdk/bin/dart run melos analyze
/tmp/dart-sdk/bin/dart run melos test
```

## Package highlights

### Core router

```dart
final config = AuthConfig.development(jwtSecret: 'change-me');
final service = AuthService(
  config: config,
  userStore: myUserStore,
  sessionStore: mySessionStore,
);
final router = AuthRouter(config: config, authService: service);
```

Built-in endpoints include:

- `GET /auth/admin`
- `GET /auth/ui`
- `GET /auth/ui/auth.js`
- `GET /auth/openapi.json`
- `GET /auth/.well-known/openid-configuration`
- `GET /auth/jwks`
- `GET /auth/userinfo`
- `POST /auth/token`

### Templates

Built-in mail templates live under:

- `packages/awesome_dart_auth/lib/templates/en/`
- `packages/awesome_dart_auth/lib/templates/it/`

### Examples

See the example projects for end-to-end wiring with Shelf and Dart Frog adapters.
