/// Embedded admin UI served by the core router.
const embeddedAdminUi = '''<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>awesome-dart-auth Admin</title>
    <style>
      body { font-family: Inter, Arial, sans-serif; margin: 0; background: #0f172a; color: #e2e8f0; }
      .wrap { max-width: 980px; margin: 0 auto; padding: 2rem; }
      .card { background: #1e293b; border-radius: 12px; padding: 1.25rem; margin-bottom: 1rem; }
      code { color: #93c5fd; }
      a { color: #93c5fd; }
    </style>
  </head>
  <body>
    <div class="wrap">
      <h1>awesome-dart-auth Admin</h1>
      <div class="card">
        <p>Admin API is available on <code>/auth/*</code>.</p>
        <p>This embedded panel now ships as a lightweight shell while backend auth/admin endpoints are served by <code>AuthRouter</code>.</p>
      </div>
      <div class="card">
        <strong>Useful links</strong>
        <ul>
          <li><a href="/auth/openapi.json">OpenAPI</a></li>
          <li><a href="/auth/ui">Auth UI</a></li>
          <li><a href="/auth/ui/config">UI config</a></li>
        </ul>
      </div>
    </div>
  </body>
</html>
''';

/// Embedded auth UI served by the core router.
const embeddedAuthUi = '''<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>awesome-dart-auth UI</title>
    <style>
      body { font-family: Inter, Arial, sans-serif; margin: 0; background: #f8fafc; color: #0f172a; }
      .container { max-width: 900px; margin: 0 auto; padding: 1.5rem; }
      .card { background: #fff; border-radius: 12px; border: 1px solid #e2e8f0; padding: 1rem; margin: 0 0 1rem; }
      h1 { margin-top: 0; }
      .grid { display: grid; gap: 1rem; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); }
      label { display: block; font-size: 0.9rem; margin-bottom: 0.25rem; }
      input { width: 100%; box-sizing: border-box; padding: 0.55rem 0.65rem; border: 1px solid #cbd5e1; border-radius: 8px; }
      button { margin-top: 0.6rem; padding: 0.55rem 0.8rem; border: none; border-radius: 8px; background: #2563eb; color: #fff; cursor: pointer; }
      pre { background: #0f172a; color: #e2e8f0; padding: 0.8rem; border-radius: 8px; overflow: auto; max-height: 280px; }
    </style>
    <script defer src="/auth/ui/auth.js"></script>
  </head>
  <body>
    <main class="container">
      <h1>awesome-dart-auth</h1>
      <p>Embedded login/runtime UI for register, login, session check, reset-password and magic-link.</p>

      <section class="grid">
        <form id="register-form" class="card">
          <h3>Register</h3>
          <label>Email</label>
          <input name="email" type="email" required />
          <label>Password</label>
          <input name="password" type="password" required />
          <button type="submit">Create account</button>
        </form>

        <form id="login-form" class="card">
          <h3>Login</h3>
          <label>Email</label>
          <input name="email" type="email" required />
          <label>Password</label>
          <input name="password" type="password" required />
          <button type="submit">Login</button>
        </form>

        <form id="forgot-form" class="card">
          <h3>Forgot password</h3>
          <label>Email</label>
          <input name="email" type="email" required />
          <button type="submit">Send reset flow</button>
        </form>

        <form id="magic-form" class="card">
          <h3>Magic link</h3>
          <label>Email</label>
          <input name="email" type="email" required />
          <button type="submit">Send magic link</button>
        </form>
      </section>

      <section class="card">
        <button id="me-button">GET /me</button>
        <button id="refresh-button">POST /refresh</button>
        <pre id="result">Ready.</pre>
      </section>
    </main>
  </body>
</html>
''';

/// Embedded browser SDK served by the core router.
const embeddedAuthJs = '''(function () {
  function guessApiPrefix() {
    var fromConfig = window.__AUTH_CONFIG__ && window.__AUTH_CONFIG__.apiPrefix;
    if (fromConfig && typeof fromConfig === 'string') return fromConfig;

    var script = document.currentScript;
    if (!script) {
      var scripts = document.getElementsByTagName('script');
      script = scripts[scripts.length - 1];
    }
    var src = script && script.src ? script.src : '/auth/ui/auth.js';
    var idx = src.indexOf('/ui/auth.js');
    if (idx >= 0) return src.substring(0, idx);
    return '/auth';
  }

  function readCookie(name) {
    var parts = document.cookie ? document.cookie.split(';') : [];
    for (var i = 0; i < parts.length; i++) {
      var p = parts[i].trim();
      var prefix = name + '=';
      if (p.indexOf(prefix) === 0) return decodeURIComponent(p.substring(prefix.length));
    }
    return null;
  }

  function request(path, options) {
    var opts = options || {};
    var headers = opts.headers || {};
    headers['content-type'] = headers['content-type'] || 'application/json';

    var csrf = readCookie('csrf-token');
    var method = (opts.method || 'GET').toUpperCase();
    if (csrf && method !== 'GET' && method !== 'HEAD' && method !== 'OPTIONS') {
      headers['x-csrf-token'] = csrf;
    }

    return fetch(apiPrefix + path, {
      method: method,
      credentials: 'include',
      headers: headers,
      body: opts.body
    }).then(function (res) {
      return res.text().then(function (t) {
        var parsed;
        try { parsed = t ? JSON.parse(t) : {}; } catch (_) { parsed = { raw: t }; }
        if (!res.ok) {
          var err = new Error(parsed.error || ('Request failed: ' + res.status));
          err.status = res.status;
          err.body = parsed;
          throw err;
        }
        return parsed;
      });
    });
  }

  var apiPrefix = guessApiPrefix();
  var tokens = { accessToken: null, refreshToken: null };

  var sdk = {
    config: { apiPrefix: apiPrefix },
    setTokens: function (pair) {
      tokens.accessToken = pair && pair.accessToken ? pair.accessToken : tokens.accessToken;
      tokens.refreshToken = pair && pair.refreshToken ? pair.refreshToken : tokens.refreshToken;
    },
    clearTokens: function () {
      tokens.accessToken = null;
      tokens.refreshToken = null;
    },
    register: function (payload) {
      return request('/register', { method: 'POST', body: JSON.stringify(payload || {}) }).then(function (data) {
        sdk.setTokens(data);
        return data;
      });
    },
    login: function (payload) {
      return request('/login', { method: 'POST', body: JSON.stringify(payload || {}) }).then(function (data) {
        sdk.setTokens(data);
        return data;
      });
    },
    logout: function () {
      return request('/logout', { method: 'POST', headers: tokens.accessToken ? { authorization: 'Bearer ' + tokens.accessToken } : {} }).then(function (data) {
        sdk.clearTokens();
        return data;
      });
    },
    me: function () {
      if (!tokens.accessToken) throw new Error('No access token in runtime');
      return request('/me', { method: 'GET', headers: { authorization: 'Bearer ' + tokens.accessToken } });
    },
    refresh: function () {
      if (!tokens.refreshToken) throw new Error('No refresh token in runtime');
      return request('/refresh', { method: 'POST', body: JSON.stringify({ refreshToken: tokens.refreshToken }) }).then(function (data) {
        sdk.setTokens(data);
        return data;
      });
    },
    forgotPassword: function (email) {
      return request('/forgot-password', { method: 'POST', body: JSON.stringify({ email: email }) });
    },
    resetPassword: function (token, newPassword) {
      return request('/reset-password', { method: 'POST', body: JSON.stringify({ token: token, newPassword: newPassword }) });
    },
    sendMagicLink: function (email) {
      return request('/magic-link/send', { method: 'POST', body: JSON.stringify({ email: email }) });
    },
    verifyMagicLink: function (token, mode) {
      return request('/magic-link/verify', { method: 'POST', body: JSON.stringify({ token: token, mode: mode || 'login' }) });
    }
  };

  window.AwesomeDartAuth = sdk;

  function output(value) {
    var el = document.getElementById('result');
    if (!el) return;
    el.textContent = JSON.stringify(value, null, 2);
  }

  function wireForm(id, callback) {
    var form = document.getElementById(id);
    if (!form) return;
    form.addEventListener('submit', function (event) {
      event.preventDefault();
      var data = {};
      var fd = new FormData(form);
      fd.forEach(function (v, k) { data[k] = String(v); });
      Promise.resolve(callback(data)).then(output).catch(function (e) {
        output({ error: e.message, status: e.status, body: e.body || null });
      });
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    wireForm('register-form', function (data) { return sdk.register(data); });
    wireForm('login-form', function (data) { return sdk.login(data); });
    wireForm('forgot-form', function (data) { return sdk.forgotPassword(data.email); });
    wireForm('magic-form', function (data) { return sdk.sendMagicLink(data.email); });

    var meButton = document.getElementById('me-button');
    if (meButton) {
      meButton.addEventListener('click', function () {
        sdk.me().then(output).catch(function (e) { output({ error: e.message, status: e.status, body: e.body || null }); });
      });
    }

    var refreshButton = document.getElementById('refresh-button');
    if (refreshButton) {
      refreshButton.addEventListener('click', function () {
        sdk.refresh().then(output).catch(function (e) { output({ error: e.message, status: e.status, body: e.body || null }); });
      });
    }
  });
})();
''';
