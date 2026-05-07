/// Embedded admin UI served by the core router.
const embeddedAdminUi = '''<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>awesome-dart-auth Admin</title>
    <style>
      body { font-family: Arial, sans-serif; margin: 2rem; background: #0f172a; color: #e2e8f0; }
      .card { background: #1e293b; border-radius: 12px; padding: 1.5rem; max-width: 56rem; }
      code { color: #93c5fd; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>awesome-dart-auth Admin</h1>
      <p>Embedded admin UI placeholder served directly by the auth backend.</p>
      <p>Mount this package at <code>/auth/admin</code> and replace the shell with your preferred SPA assets over time.</p>
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
    <script defer src="/auth/ui/auth.js"></script>
  </head>
  <body>
    <main>
      <h1>awesome-dart-auth</h1>
      <p>Sign in from your Dart backend using the bundled browser SDK.</p>
      <button id="issue-token">Fetch demo token</button>
      <pre id="result"></pre>
    </main>
  </body>
</html>
''';

/// Embedded browser SDK served by the core router.
const embeddedAuthJs = '''window.AwesomeDartAuth = {
  async issueDemoToken() {
    const response = await fetch('/auth/token', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ userId: 'demo-user', email: 'demo@example.com' })
    });
    return response.json();
  }
};

document.addEventListener('DOMContentLoaded', () => {
  const button = document.getElementById('issue-token');
  const result = document.getElementById('result');
  if (!button || !result) {
    return;
  }
  button.addEventListener('click', async () => {
    result.textContent = JSON.stringify(await window.AwesomeDartAuth.issueDemoToken(), null, 2);
  });
});
''';
