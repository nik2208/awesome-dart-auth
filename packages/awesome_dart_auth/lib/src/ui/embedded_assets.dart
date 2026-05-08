/// Embedded assets ported from awesome-node-auth.
const embeddedAuthUi = r"""<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Awesome Node Auth</title>
    <link rel="stylesheet" href="base.css">
</head>

<body>
    <div class="auth-container">
        <img src="" alt="Logo" class="logo hidden">
        <h1 class="site-name" data-i18n="site_name">Awesome Node Auth</h1>
        <h2 data-i18n="login_title">Login</h2>

        <div id="alert" class="alert alert-error hidden"></div>

        <form id="login-form">
            <div class="form-group">
                <label for="email" data-i18n="email_label">Email</label>
                <input type="email" id="email" name="email" required data-i18n="email_placeholder">
            </div>
            <div class="form-group">
                <label for="password" data-i18n="password_label">Password</label>
                <input type="password" id="password" name="password" required data-i18n="password_placeholder">
            </div>
            <button type="submit" id="submit-btn" data-i18n="login_button">Login</button>
        </form>

        <div id="social-section" class="hidden">
            <div class="divider">
                <span data-i18n="social_divider">Or continue with</span>
            </div>
            <div class="social-buttons">
                <a href="../oauth/google" class="btn-social hidden" data-feature="google">
                    <svg class="icon" viewBox="0 0 24 24">
                        <path
                            d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                            fill="#4285F4" />
                        <path
                            d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                            fill="#34A853" />
                        <path
                            d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                            fill="#FBBC05" />
                        <path
                            d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                            fill="#EA4335" />
                    </svg>
                    Google
                </a>
                <a href="../oauth/github" class="btn-social hidden" data-feature="github">
                    <svg class="icon" fill="currentColor" viewBox="0 0 24 24">
                        <path fill-rule="evenodd"
                            d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                            clip-rule="evenodd"></path>
                    </svg>
                    GitHub
                </a>
            </div>

        </div>

        <div class="footer-links">
            <p data-feature="forgot-password" class="hidden"><a href="forgot-password" data-i18n="forgot_password_link">Forgot password?</a></p>
            <p data-feature="register" class="hidden"><span data-i18n="no_account_text">Don't have an account?</span> <a href="register" data-i18n="signup_link">Sign up</a></p>
        </div>

        <script src="auth.js?v=2"></script>
        <script>
            document.addEventListener('DOMContentLoaded', async () => {
                await AuthService.init();

                // Redirect if already authenticated
                if (AuthService.user) {
                    window.location.href = '/';
                    return;
                }

                // Show social section if at least one provider is enabled
                if (AuthService.config.features.google || AuthService.config.features.github) {
                    document.getElementById('social-section').classList.remove('hidden');
                    if (AuthService.config.features.google) document.querySelector('[data-feature="google"]').classList.remove('hidden');
                    if (AuthService.config.features.github) document.querySelector('[data-feature="github"]').classList.remove('hidden');
                }

                if (AuthService.config.features.register) {
                    document.querySelector('[data-feature="register"]')?.classList.remove('hidden');
                }

                if (AuthService.config.features.forgotPassword) {
                    document.querySelector('[data-feature="forgot-password"]')?.classList.remove('hidden');
                }

                const form = document.getElementById('login-form');
                const alert = document.getElementById('alert');
                const submitBtn = document.getElementById('submit-btn');

                form.addEventListener('submit', async (e) => {
                    e.preventDefault();
                    alert.classList.add('hidden');
                    submitBtn.disabled = true;
                    submitBtn.textContent = 'Logging in...';

                    const email = form.email.value;
                    const password = form.password.value;

                    try {
                        const result = await AuthService.apiCall('/login', 'POST', { email, password });

                        if (result.success || result.requiresTwoFactor) {
                            if (result.requiresTwoFactor) {
                                // Redirect to 2FA page or show setup
                                window.location.href = `2fa?token=${result.tempToken}`;
                            } else {
                                window.location.href = '/';
                            }
                        } else {
                            alert.textContent = result.error || 'Login failed';
                            alert.classList.remove('hidden');
                        }
                    } catch (err) {
                        alert.textContent = 'An unexpected error occurred';
                        alert.classList.remove('hidden');
                    } finally {
                        submitBtn.disabled = false;
                        submitBtn.textContent = 'Login';
                    }
                });
            });
        </script>
</body>

</html>""";

const embeddedAuthJs = r"""/**
 * Universal Authentication Service & Utility Wrapper for Vanilla JS UI
 * Combines global fetch interception with the internal AuthService API used by the UI.
 * Extensible for single-page applications via AwesomeNodeAuth.init(options).
 */
(function () {
    // --- STATE ---
    let refreshInProgress = null;
    let isAuthenticated = false;
    let isInitialized = false;
    let currentUser = null;

    // --- DEFAULT CONFIG ---
    // apiPrefix derivato automaticamente dal pathname se incluso nelle pagine UI
    let defaultPrefix = window.location.pathname.includes('/ui/')
        ? window.location.pathname.split('/ui/')[0]
        : '/auth';

    let UI_CONFIG = {
        apiPrefix: defaultPrefix,
        loginUrl: defaultPrefix + '/ui/login',
        homeUrl: '/',
        siteName: 'Awesome Node Auth',
        features: {}
    };

    // --- OVERRIDES ---
    // Metodi overridabili tramite AwesomeNodeAuth.init()
    let _overrides = {
        login: null,
        logout: null,
        register: null,
        forgotPassword: null,
        resetPassword: null,
        changePassword: null,
        setPassword: null,
        sendMagicLink: null,
        verifyMagicLink: null,
        setup2fa: null,
        verify2faSetup: null,
        validate2fa: null,
        sendSmsLogin: null,
        verifySmsLogin: null,
        validateSms: null,
        resendVerificationEmail: null,
        verifyEmail: null,
        requestEmailChange: null,
        confirmEmailChange: null,
        requestLinkingEmail: null,
        verifyLinkingToken: null,
        verifyConflictLinkingToken: null,
        getLinkedAccounts: null,
        unlinkAccount: null,
        deleteAccount: null,
        // hooks lifecycle
        onLogout: null,
        onSessionExpired: null,
        onRefreshSuccess: null,
        onRefreshFail: null,
    };

    // --- CSRF ---
    function getCookie(name) {
        const match = document.cookie.match(new RegExp('(^|;\\s*)' + name + '=([^;]*)'));
        return match ? decodeURIComponent(match[2]) : null;
    }

    function addCsrfHeader(headers = {}) {
        const token = getCookie('__Host-csrf-token') || getCookie('__Secure-csrf-token') || getCookie('csrf-token');
        if (token) headers['X-CSRF-Token'] = token;
        return headers;
    }

    // --- UTIL ---
    function isAuthEndpoint(url) {
        if (typeof url !== 'string') return false;
        return [
            `${UI_CONFIG.apiPrefix}/login`,
            `${UI_CONFIG.apiPrefix}/logout`,
            `${UI_CONFIG.apiPrefix}/refresh`,
            `${UI_CONFIG.apiPrefix}/me`
        ].some(e => url.includes(e));
    }

    function getLoginUrl() {
        return UI_CONFIG.loginUrl || `${UI_CONFIG.apiPrefix}/ui/login`;
    }

    // --- REFRESH ---
    function refreshToken() {
        if (refreshInProgress) return refreshInProgress;
        refreshInProgress = originalFetch(`${UI_CONFIG.apiPrefix}/refresh`, {
            method: 'POST',
            credentials: 'include',
            headers: addCsrfHeader({ 'Content-Type': 'application/json' })
        })
            .then(r => r.json())
            .finally(() => { refreshInProgress = null; });
        return refreshInProgress;
    }

    // --- FETCH INTERCEPTOR ---
    const originalFetch = window.fetch;
    window.fetch = async function (input, init = {}) {
        const url = typeof input === 'string' ? input : input.url;

        // Derive the auth backend origin so that every request to the same
        // domain as the auth server gets credentials/CSRF headers — not just
        // requests whose path starts with apiPrefix.  This covers routes like
        // /mcp on the same host as /auth (cross-domain headless deployments).
        //
        // We use window.location.href as the base for resolving relative URLs.
        // Try/catch guards against malformed URLs; on failure both origins stay
        // null and only the isAuthEndpoint() path-based fallback is used.
        let backendOrigin = null;
        let requestOrigin = null;
        try {
            const pageBase = window.location?.href || '';
            backendOrigin = UI_CONFIG.apiPrefix.startsWith('http')
                ? new URL(UI_CONFIG.apiPrefix).origin
                : new URL(pageBase).origin;
            requestOrigin = new URL(url, pageBase).origin;
        } catch (_) { /* malformed URL — isAuthEndpoint() below handles known endpoints */ }

        const isBackendRequest = backendOrigin !== null && backendOrigin === requestOrigin;
        const isAuthRequest = isBackendRequest || isAuthEndpoint(url);

        if (isAuthRequest) {
            if (!init.headers) init.headers = {};
            if (init.headers instanceof Headers) {
                const token = getCookie('__Host-csrf-token') || getCookie('__Secure-csrf-token') || getCookie('csrf-token');
                if (token) init.headers.set('X-CSRF-Token', token);
            } else {
                init.headers = addCsrfHeader(init.headers);
            }
            init.credentials = init.credentials || 'include';
        }

        let response = await originalFetch(input, init);

        if ((response.status === 401 || response.status === 403) && !isAuthEndpoint(url)) {
            // Peek at the response body to detect a permanent SESSION_REVOKED error.
            // We must clone() before reading so the original response stays consumable.
            let errBody = null;
            try { errBody = await response.clone().json(); } catch (_) {}

            // If the server already told us the session is permanently revoked,
            // skip the refresh entirely — retrying would only loop forever.
            const isRevoked = errBody && errBody.code === 'SESSION_REVOKED';

            if (!isRevoked) {
                try {
                    const refreshResult = await refreshToken();
                    // Guard against SESSION_REVOKED coming back from the refresh
                    // endpoint (e.g. when checkOn:'refresh') — it has no `success`
                    // field, so the old `!== false` check would incorrectly treat
                    // it as a success and re-issue the original request, looping.
                    const refreshRevoked = refreshResult && refreshResult.code === 'SESSION_REVOKED';
                    if (!refreshRevoked && refreshResult && refreshResult.success !== false) {
                        if (_overrides.onRefreshSuccess) _overrides.onRefreshSuccess(refreshResult);
                        if (!(init.headers instanceof Headers)) {
                            init.headers = addCsrfHeader(init.headers);
                        }
                        return originalFetch(input, init);
                    }
                } catch (e) {
                    console.error('[AwesomeNodeAuth] Auto-refresh failed', e);
                }
            }

            // Refresh fallito
            if (_overrides.onRefreshFail) {
                _overrides.onRefreshFail();
            } else {
                try {
                    await originalFetch(`${UI_CONFIG.apiPrefix}/logout`, {
                        method: 'POST',
                        credentials: 'include'
                    });
                } catch (e) { }
            }

            isAuthenticated = false;
            currentUser = null;
            if (window.AuthService) window.AuthService.user = null;

            if (_overrides.onSessionExpired) {
                _overrides.onSessionExpired();
            } else if (!window.location.pathname.includes('/login')) {
                window.location.href = getLoginUrl();
            }
        }

        return response;
    };

    // --- HEADLESS MODE HELPER ---
    /**
     * Auto-installs no-op lifecycle handlers when the server is running in
     * headless UI mode (authConfig.ui.headless === true).
     *
     * In headless mode the backend does not serve login/register HTML pages — a
     * remote SPA (e.g. a Docusaurus wiki) loads auth.js via a <script> tag and
     * handles authentication in its own UI.  Without this guard, auth.js would
     * redirect window.location to its own (missing) login page whenever the session
     * expires or a refresh fails, breaking the SPA navigation entirely.
     *
     * The function is idempotent: if the caller has already registered a custom
     * handler it is left untouched (explicit beats implicit).
     */
    function _applyHeadlessIfNeeded() {
        if (!UI_CONFIG.headless) return;
        if (!_overrides.onSessionExpired) _overrides.onSessionExpired = function () { };
        if (!_overrides.onRefreshFail)    _overrides.onRefreshFail    = function () { };
        if (!_overrides.onLogout)         _overrides.onLogout         = function () { };
    }

    // --- INTERNAL AUTH SERVICE (pagine statiche della libreria) ---
    window.AuthService = {
        config: UI_CONFIG,
        user: null,

        async init() {
            try {
                // SERVER-SIDE RENDERING (SSR) Fast-Path
                // If __AUTH_CONFIG__ was injected into the HTML (e.g. via ui.router.ts),
                // skip fetching so the UI initialization is purely synchronous and FOUC-free.
                if (window.__AUTH_CONFIG__) {
                    UI_CONFIG = { ...UI_CONFIG, ...window.__AUTH_CONFIG__ };
                } else {
                    const res = await fetch(`${UI_CONFIG.apiPrefix}/ui/config`);
                    if (res.ok) {
                        const dynamicConfig = await res.json();
                        UI_CONFIG = { ...UI_CONFIG, ...dynamicConfig };
                    }
                }

                this.config = UI_CONFIG;
                window.AwesomeNodeAuth.config = UI_CONFIG;

                // Headless mode: the server reported that HTML pages are not served
                // (a remote SPA is hosting the login UI).  Auto-install no-op lifecycle
                // handlers so auth.js never redirects window.location away from the SPA.
                _applyHeadlessIfNeeded();
            } catch (e) { console.warn('[AwesomeNodeAuth] Failed to load UI config', e); }

            // Theme is mostly handled via SSR HTML injection now, but we keep this 
            // as an absolute fallback or if manual API loading occurred.
            if (UI_CONFIG.ui && !window.__AUTH_CONFIG__) {
                const root = document.documentElement;
                if (UI_CONFIG.ui.primaryColor) {
                    root.style.setProperty('--primary-color', UI_CONFIG.ui.primaryColor);
                    root.style.setProperty('--input-focus', UI_CONFIG.ui.primaryColor);
                }
                if (UI_CONFIG.ui.secondaryColor) root.style.setProperty('--secondary-color', UI_CONFIG.ui.secondaryColor);
                if (UI_CONFIG.ui.bgColor) root.style.setProperty('--bg-color', UI_CONFIG.ui.bgColor);
                if (UI_CONFIG.ui.cardBg) root.style.setProperty('--card-bg', UI_CONFIG.ui.cardBg);
                if (UI_CONFIG.ui.bgImage) {
                    const safeUrl = UI_CONFIG.ui.bgImage.replace(/['"\\]/g, m => encodeURIComponent(m));
                    root.style.setProperty('--bg-image', 'url("' + safeUrl + '")');
                }
                if (UI_CONFIG.ui.logoUrl) {
                    document.querySelectorAll('.logo').forEach(el => {
                        el.src = UI_CONFIG.ui.logoUrl;
                        el.classList.remove('hidden');
                    });
                }
                if (UI_CONFIG.ui.siteName) {
                    document.title = UI_CONFIG.ui.siteName;
                    document.querySelectorAll('.site-name').forEach(el => {
                        el.textContent = UI_CONFIG.ui.siteName;
                    });
                }
                if (UI_CONFIG.ui.customCss) {
                    const style = document.createElement('style');
                    style.textContent = UI_CONFIG.ui.customCss;
                    document.head.appendChild(style);
                }
            }

            await window.AwesomeNodeAuth.checkSession();
            this.user = currentUser;
            this.applyTranslations();
        },

        applyTranslations() {
            const translations = this.config.translations || {};
            if (Object.keys(translations).length === 0) return;

            document.querySelectorAll('[data-i18n]').forEach(el => {
                const key = el.getAttribute('data-i18n');
                if (key && translations[key]) {
                    // If it's an input/textarea placeholder
                    if (el instanceof HTMLInputElement || el instanceof HTMLTextAreaElement) {
                        el.placeholder = translations[key];
                    } else {
                        el.textContent = translations[key];
                    }
                }
            });
        },

        async apiCall(endpoint, method = 'POST', body = null) {
            const options = {
                method,
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }
            };
            if (body && ['POST', 'PUT', 'PATCH'].includes(method.toUpperCase())) {
                options.body = JSON.stringify(body);
            }
            const res = await fetch(`${UI_CONFIG.apiPrefix}${endpoint}`, options);
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                data.success = false;
                if (!data.error) data.error = 'Request failed (' + res.status + ')';
            }
            return data;
        }
    };

    // --- HELPERS INTERNI ---
    async function _checkSessionInternal() {
        try {
            const res = await originalFetch(`${UI_CONFIG.apiPrefix}/me`, {
                credentials: 'include',
                headers: { 'Accept': 'application/json' }
            });
            isAuthenticated = res.ok;
            currentUser = res.ok ? await res.json() : null;
        } catch (e) {
            isAuthenticated = false;
            currentUser = null;
        }
        if (window.AuthService) window.AuthService.user = currentUser;
        isInitialized = true;
        return isAuthenticated;
    }

    async function _logoutInternal() {
        await window.AuthService.apiCall('/logout', 'POST');
        isAuthenticated = false;
        currentUser = null;
        if (window.AuthService) window.AuthService.user = null;
        if (_overrides.onLogout) {
            _overrides.onLogout();
        } else {
            window.location.href = getLoginUrl();
        }
    }

    // --- PUBLIC API ---
    window.AwesomeNodeAuth = {
        config: UI_CONFIG,

        /**
         * Configurazione opzionale. Se non chiamato, funziona con i default.
         * 
         * @param {object} options
         * @param {string} [options.apiPrefix]        - Base path del backend. Default: derivato dal pathname
         * @param {string} [options.loginUrl]         - URL pagina login. Default: {apiPrefix}/ui/login
         * @param {string} [options.homeUrl]          - URL home dopo login. Default: '/'
         * @param {boolean} [options.headless]        - Headless mode: installs no-op onSessionExpired /
         *                                              onLogout / onRefreshFail handlers immediately so
         *                                              auth.js never redirects window.location. Useful
         *                                              when loading auth.js from a remote SPA (e.g.
         *                                              Docusaurus) that manages its own navigation.
         * @param {Function} [options.login]          - Override metodo login
         * @param {Function} [options.logout]         - Override metodo logout
         * @param {Function} [options.register]       - Override metodo register
         * @param {Function} [options.onLogout]       - Callback post-logout (sostituisce redirect automatico)
         * @param {Function} [options.onSessionExpired] - Callback sessione scaduta (sostituisce redirect automatico)
         * @param {Function} [options.onRefreshSuccess] - Callback refresh riuscito
         * @param {Function} [options.onRefreshFail]  - Callback refresh fallito
         * 
         * @example
         * // Zero config
         * // <script src="/auth/ui/assets/auth.js"></script>
         *
         * // Con config base
         * AwesomeNodeAuth.init({ apiPrefix: '/api/auth', loginUrl: '/login' });
         *
         * // Con override metodo
         * AwesomeNodeAuth.init({
         *   apiPrefix: '/api/auth',
         *   login: async (email, password) => {
         *     console.log('custom login');
         *     return window.AuthService.apiCall('/login', 'POST', { email, password });
         *   },
         *   onSessionExpired: () => myRouter.navigate('/login')
         * });
         */
        init(options = {}) {
            const {
                apiPrefix, loginUrl, homeUrl, siteName, headless,
                onLogout, onSessionExpired, onRefreshSuccess, onRefreshFail,
                ...methodOverrides
            } = options;

            // Aggiorna config
            if (apiPrefix) UI_CONFIG.apiPrefix = apiPrefix;
            if (loginUrl) UI_CONFIG.loginUrl = loginUrl;
            if (homeUrl) UI_CONFIG.homeUrl = homeUrl;
            if (siteName) UI_CONFIG.siteName = siteName;
            // headless: true → mark config immediately so _applyHeadlessIfNeeded() fires
            if (headless) UI_CONFIG.headless = true;
            this.config = UI_CONFIG;
            if (window.AuthService) window.AuthService.config = UI_CONFIG;

            // Registra hooks lifecycle
            if (onLogout) _overrides.onLogout = onLogout;
            if (onSessionExpired) _overrides.onSessionExpired = onSessionExpired;
            if (onRefreshSuccess) _overrides.onRefreshSuccess = onRefreshSuccess;
            if (onRefreshFail) _overrides.onRefreshFail = onRefreshFail;

            // Registra override metodi
            const overridableMetods = [
                'login', 'logout', 'register', 'forgotPassword', 'resetPassword',
                'changePassword', 'setPassword', 'sendMagicLink', 'verifyMagicLink',
                'setup2fa', 'verify2faSetup', 'validate2fa', 'sendSmsLogin',
                'verifySmsLogin', 'validateSms', 'resendVerificationEmail',
                'verifyEmail', 'requestEmailChange', 'confirmEmailChange',
                'requestLinkingEmail', 'verifyLinkingToken', 'verifyConflictLinkingToken',
                'getLinkedAccounts', 'unlinkAccount', 'deleteAccount'
            ];
            overridableMetods.forEach(method => {
                if (typeof methodOverrides[method] === 'function') {
                    _overrides[method] = methodOverrides[method];
                }
            });

            // Apply headless no-op handlers if the config reports headless mode.
            // This covers the case where init() is called from a Docusaurus <head>
            // before AuthService.init() has had a chance to fetch /ui/config.
            _applyHeadlessIfNeeded();
        },

        // --- STATE ---
        isAuthenticated: () => isAuthenticated,
        isInitialized: () => isInitialized,
        getUser: () => currentUser,

        // --- REFRESH ---

        /**
         * Trigger a token refresh using the shared in-flight singleton.
         * Safe to call concurrently — multiple callers receive the same Promise.
         * Exposed so that external scripts (e.g. Docusaurus wiki components) can
         * delegate their own refresh calls here instead of duplicating the logic,
         * ensuring a single HTTP request is made even across module boundaries.
         *
         * @returns {Promise<boolean>} true if the refresh succeeded, false otherwise
         */
        async refresh() {
            const result = await refreshToken().catch(() => null);
            // SESSION_REVOKED is a permanent failure — never treat it as success
            if (result && result.code === 'SESSION_REVOKED') return false;
            // Succeeds if result.success is explicitly true OR if result is simply an object (e.g. {accessToken: "..."})
            return !!(result && (result.success !== false));
        },

        // --- SESSION ---

        async checkSession() {
            return _checkSessionInternal();
        },

        /**
         * Fetch all active sessions for the currently authenticated user.
         * Requires ISessionStore on the server with getSessionsForUser implemented.
         * @returns {Promise<{sessions: Array, error?: string}>}
         */
        async getActiveSessions() {
            const data = await window.AuthService.apiCall('/sessions', 'GET');
            return { sessions: data.sessions || [], error: data.error };
        },

        /**
         * Revoke a specific session by its handle.
         * @param {string} sessionHandle
         * @returns {Promise<{success: boolean, error?: string}>}
         */
        async revokeSession(sessionHandle) {
            const data = await window.AuthService.apiCall('/sessions/' + encodeURIComponent(sessionHandle), 'DELETE');
            return { success: !!data.success, error: data.error };
        },

        async guardPage(customLoginUrl) {
            const ok = await _checkSessionInternal();
            if (!ok && !window.location.pathname.includes('/login')) {
                window.location.href = customLoginUrl || getLoginUrl();
            }
        },

        async guardRole(role, customLoginUrl) {
            const ok = await _checkSessionInternal();
            const hasRole = currentUser && (
                currentUser.role === role ||
                (Array.isArray(currentUser.roles) && currentUser.roles.includes(role))
            );
            if (!ok || !hasRole) {
                window.location.href = customLoginUrl || getLoginUrl();
            }
        },

        // --- AUTH ---

        async login(email, password) {
            if (_overrides.login) return _overrides.login(email, password);
            const data = await window.AuthService.apiCall('/login', 'POST', { email, password });
            if (data.requiresTwoFactor) {
                return {
                    success: true,
                    requires2fa: true,
                    tempToken: data.tempToken,
                    availableMethods: data.available2faMethods || []
                };
            }
            if (data.requires2FASetup) {
                return {
                    success: false,
                    requires2FASetup: true,
                    tempToken: data.tempToken,
                    error: data.error || '2FA setup required'
                };
            }
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        async logout() {
            if (_overrides.logout) return _overrides.logout();
            return _logoutInternal();
        },

        async register(email, password, firstName, lastName) {
            if (_overrides.register) return _overrides.register(email, password, firstName, lastName);
            const data = await window.AuthService.apiCall('/register', 'POST', {
                email, password, firstName, lastName
            });
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        // --- PASSWORD ---

        async forgotPassword(email) {
            if (_overrides.forgotPassword) return _overrides.forgotPassword(email);
            return window.AuthService.apiCall('/forgot-password', 'POST', { email });
        },

        async resetPassword(token, password) {
            if (_overrides.resetPassword) return _overrides.resetPassword(token, password);
            return window.AuthService.apiCall('/reset-password', 'POST', { token, password });
        },

        async changePassword(currentPassword, newPassword) {
            if (_overrides.changePassword) return _overrides.changePassword(currentPassword, newPassword);
            return window.AuthService.apiCall('/change-password', 'POST', {
                currentPassword, newPassword
            });
        },

        /**
         * Imposta la password per la prima volta su un account OAuth senza password.
         * Equivale a changePassword con currentPassword vuota — gestito lato backend.
         */
        async setPassword(newPassword) {
            if (_overrides.setPassword) return _overrides.setPassword(newPassword);
            return this.changePassword('', newPassword);
        },

        // --- MAGIC LINK ---

        async sendMagicLink(email) {
            if (_overrides.sendMagicLink) return _overrides.sendMagicLink(email);
            return window.AuthService.apiCall('/magic-link/send', 'POST', {
                email, mode: 'login'
            });
        },

        async verifyMagicLink(token) {
            if (_overrides.verifyMagicLink) return _overrides.verifyMagicLink(token);
            const data = await window.AuthService.apiCall('/magic-link/verify', 'POST', {
                token, mode: 'login'
            });
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        // --- 2FA ---

        async setup2fa() {
            if (_overrides.setup2fa) return _overrides.setup2fa();
            return window.AuthService.apiCall('/2fa/setup', 'POST');
        },

        async verify2faSetup(code, secret) {
            if (_overrides.verify2faSetup) return _overrides.verify2faSetup(code, secret);
            return window.AuthService.apiCall('/2fa/verify-setup', 'POST', {
                token: code, secret
            });
        },

        async validate2fa(tempToken, code) {
            if (_overrides.validate2fa) return _overrides.validate2fa(tempToken, code);
            const data = await window.AuthService.apiCall('/2fa/verify', 'POST', {
                tempToken, totpCode: code
            });
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        // --- SMS ---

        async sendSmsLogin(email) {
            if (_overrides.sendSmsLogin) return _overrides.sendSmsLogin(email);
            return window.AuthService.apiCall('/sms/send', 'POST', {
                email, mode: 'login'
            });
        },

        async verifySmsLogin(userId, code) {
            if (_overrides.verifySmsLogin) return _overrides.verifySmsLogin(userId, code);
            const data = await window.AuthService.apiCall('/sms/verify', 'POST', {
                userId, code, mode: 'login'
            });
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        async validateSms(tempToken, code) {
            if (_overrides.validateSms) return _overrides.validateSms(tempToken, code);
            const data = await window.AuthService.apiCall('/sms/verify', 'POST', {
                tempToken, code, mode: '2fa'
            });
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        // --- EMAIL VERIFICATION ---

        async resendVerificationEmail() {
            if (_overrides.resendVerificationEmail) return _overrides.resendVerificationEmail();
            return window.AuthService.apiCall('/send-verification-email', 'POST');
        },

        async verifyEmail(token) {
            if (_overrides.verifyEmail) return _overrides.verifyEmail(token);
            const data = await window.AuthService.apiCall(
                `/verify-email?token=${token}`, 'GET'
            );
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        // --- EMAIL CHANGE ---

        async requestEmailChange(newEmail) {
            if (_overrides.requestEmailChange) return _overrides.requestEmailChange(newEmail);
            return window.AuthService.apiCall('/change-email/request', 'POST', { newEmail });
        },

        async confirmEmailChange(token) {
            if (_overrides.confirmEmailChange) return _overrides.confirmEmailChange(token);
            const data = await window.AuthService.apiCall('/change-email/confirm', 'POST', { token });
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        // --- ACCOUNT LINKING ---

        async requestLinkingEmail(email, provider) {
            if (_overrides.requestLinkingEmail) return _overrides.requestLinkingEmail(email, provider);
            return window.AuthService.apiCall('/link-request', 'POST', { email, provider });
        },

        async verifyLinkingToken(token, provider) {
            if (_overrides.verifyLinkingToken) return _overrides.verifyLinkingToken(token, provider);
            const data = await window.AuthService.apiCall('/link-verify', 'POST', { token, provider });
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        async verifyConflictLinkingToken(token) {
            if (_overrides.verifyConflictLinkingToken) return _overrides.verifyConflictLinkingToken(token);
            const data = await window.AuthService.apiCall('/link-verify', 'POST', {
                token, loginAfterLinking: true
            });
            if (data.success) await _checkSessionInternal();
            return { success: !!data.success, error: data.error };
        },

        async getLinkedAccounts() {
            if (_overrides.getLinkedAccounts) return _overrides.getLinkedAccounts();
            const data = await window.AuthService.apiCall('/linked-accounts', 'GET');
            return data.linkedAccounts || [];
        },

        async unlinkAccount(provider, providerAccountId) {
            if (_overrides.unlinkAccount) return _overrides.unlinkAccount(provider, providerAccountId);
            return window.AuthService.apiCall(
                `/linked-accounts/${provider}/${providerAccountId}`, 'DELETE'
            );
        },

        // --- ACCOUNT ---

        async deleteAccount() {
            if (_overrides.deleteAccount) return _overrides.deleteAccount();
            const data = await window.AuthService.apiCall('/account', 'DELETE');
            if (data.success) {
                isAuthenticated = false;
                currentUser = null;
                if (window.AuthService) window.AuthService.user = null;
                if (_overrides.onLogout) {
                    _overrides.onLogout();
                } else {
                    window.location.href = getLoginUrl();
                }
            }
            return { success: !!data.success, error: data.error };
        },
    };

})();
""";

const embeddedAuthBaseCss = r"""@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

:root {
    --primary-color: #4a90d9;
    --primary-color-hover: #357abd;
    --secondary-color: #6c757d;
    --secondary-color-hover: #5a6268;
    --bg-color: #f8fafc;
    --bg-image: none;
    --card-bg: #ffffff;
    --text-color: #1e293b;
    --text-muted: #64748b;
    --error-color: #ef4444;
    --success-color: #22c55e;
    --border-color: #e2e8f0;
    --input-focus: #4a90d9;
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    background-color: var(--bg-color);
    background-image: var(--bg-image);
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    color: var(--text-color);
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
}

.auth-container {
    width: 100%;
    max-width: 400px;
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: 12px;
    padding: 32px;
    box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
}

.logo {
    display: block;
    height: 48px;
    width: auto;
    margin: 0 auto 16px;
}

h1 {
    font-size: 24px;
    font-weight: 700;
    text-align: center;
    color: var(--primary-color);
    margin-bottom: 4px;
}

h2 {
    font-size: 18px;
    font-weight: 400;
    text-align: center;
    color: var(--text-muted);
    margin-bottom: 24px;
}

.alert {
    padding: 12px;
    border-radius: 6px;
    font-size: 14px;
    margin-bottom: 16px;
    border: 1px solid transparent;
}

.alert-error {
    background-color: #fef2f2;
    color: var(--error-color);
    border-color: #fee2e2;
}

.alert-success {
    background-color: #f0fdf4;
    color: var(--success-color);
    border-color: #dcfce7;
}

form {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

label {
    font-size: 14px;
    font-weight: 600;
    color: #374151;
}

input {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.2s;
}

input:focus {
    outline: none;
    border-color: var(--input-focus);
    box-shadow: 0 0 0 3px rgba(74, 144, 217, 0.1);
}

button {
    width: 100%;
    padding: 12px;
    border: none;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.2s, opacity 0.2s;
}

button[type="submit"] {
    background-color: var(--primary-color);
    color: white;
}

button[type="submit"]:hover {
    background-color: var(--primary-color-hover);
}

button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.divider {
    position: relative;
    margin: 24px 0;
    border-top: 1px solid var(--border-color);
}

.divider span {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: var(--card-bg);
    padding: 0 8px;
    font-size: 10px;
    color: #9ca3af;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.social-buttons {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.btn-social {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    background-color: white;
    border: 1px solid var(--secondary-color);
    color: var(--secondary-color);
    text-decoration: none;
    padding: 10px;
}

.btn-social:hover {
    background-color: #f9fafb;
    border-color: var(--secondary-color-hover);
    color: var(--secondary-color-hover);
}

.icon {
    width: 16px;
    height: 16px;
}

.footer-links {
    margin-top: 24px;
    text-align: center;
    font-size: 14px;
    color: var(--text-muted);
}

.footer-links a {
    color: var(--primary-color);
    text-decoration: none;
    font-weight: 600;
}

.footer-links a:hover {
    text-decoration: underline;
}

.hidden {
    display: none !important;
}
""";

const embeddedAdminJs = r"""/* awesome-node-auth admin panel — loaded via buildAdminHtml as a static asset */
/* jshint esversion: 8 */
(function () {
  'use strict';

  var cfg = window.__ADMIN_CONFIG__ || {};
  var BASE = cfg.base || '';
  var FEAT_ROLES = !!cfg.featRoles;
  var FEAT_METADATA = !!cfg.featMetadata;
  var FEAT_TENANTS = !!cfg.featTenants;
  var FEAT_2FA_POLICY = !!cfg.feat2faPolicy;
  var FEAT_CONTROL = !!cfg.featControl;
  var FEAT_LINKED_ACCOUNTS = !!cfg.featLinkedAccounts;
  var FEAT_API_KEYS = !!cfg.featApiKeys;
  var FEAT_WEBHOOKS = !!cfg.featWebhooks;
  var FEAT_TEMPLATES = !!cfg.featTemplates;
  var FEAT_UPLOAD = !!cfg.featUpload;
  var UPLOAD_BASE_URL = cfg.uploadBaseUrl || '';

  var _token = '';
  var _state = {
    tab: 'users',
    users: { page: 0, openId: null, rolesCache: {}, linkedAccountsCache: {}, filter: '', selected: new Set() },
    sessions: { page: 0, filter: '' },
    roles: { filter: '' },
    tenants: { openId: null, filter: '' },
    apiKeys: { page: 0, filter: '', newRaw: null },
    webhooks: { page: 0 },
    templates: { type: 'mail', selectedId: null, mailTemplates: [], uiTranslations: [] }
  };
  var PAGE_SIZE = 20;

  // ---- Nav tabs built from config ----------------------------------------
  function buildNav() {
    var nav = document.getElementById('nav');
    if (!nav) return;
    var tabs = [{ id: 'users', label: '\uD83D\uDC64 Users' }];
    if (cfg.featSessions) tabs.push({ id: 'sessions', label: '\uD83D\uDCCB Sessions' });
    if (FEAT_ROLES) tabs.push({ id: 'roles', label: '\uD83D\uDEE1\uFE0F Roles & Permissions' });
    if (FEAT_TENANTS) tabs.push({ id: 'tenants', label: '\uD83C\uDFE2 Tenants' });
    if (FEAT_API_KEYS) tabs.push({ id: 'apiKeys', label: '\uD83D\uDD11 API Keys' });
    if (FEAT_WEBHOOKS) tabs.push({ id: 'webhooks', label: '\uD83D\uDD17 Webhooks' });
    if (FEAT_CONTROL) tabs.push({ id: 'control', label: '\u2699\uFE0F Control' });
    if (FEAT_TEMPLATES) tabs.push({ id: 'templates', label: '\uD83D\uDCE7 Email & UI' });
    tabs.forEach(function (t) {
      var btn = document.createElement('button');
      btn.id = 'tab-' + t.id;
      btn.textContent = t.label;
      btn.onclick = function () { showTab(t.id); };
      nav.insertBefore(btn, nav.querySelector('.logout-btn'));
    });
  }

  // ---- Auth ----------------------------------------------------------------
  async function doLogin() {
    var secret = document.getElementById('secret-input').value.trim();
    if (!secret) return;

    document.getElementById('login-error').style.display = 'none';

    if (cfg.sessionBased) {
      // Session-based login (Email + Password)
      var emailEl = document.getElementById('email-input');
      var email = emailEl ? emailEl.value.trim() : '';

      try {
        // Point to the local /login handler within the admin router
        var loginUrl = cfg.base + '/login';
        var res = await fetch(loginUrl, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          credentials: 'include',
          body: JSON.stringify({ email: email, password: secret })
        });

        if (!res.ok) {
          var err = await res.json().catch(function () { return { error: res.statusText }; });
          throw new Error(err.error || 'Invalid credentials');
        }

        // Login successful (cookie set by server). Reload to let server-side guard pass.
        location.reload();
      } catch (e) {
        document.getElementById('login-error').textContent = e.message;
        document.getElementById('login-error').style.display = 'block';
      }
    } else {
      // Legacy Admin Secret login
      sessionStorage.setItem('admin_token', secret);
      _token = secret;
      api('GET', '/api/ping').then(function () {
        document.getElementById('login').style.display = 'none';
        document.getElementById('app').style.display = 'flex';
        document.getElementById('app').style.flexDirection = 'column';
        showTab('users');
      }).catch(function () {
        sessionStorage.removeItem('admin_token');
        _token = '';
        document.getElementById('login-error').textContent = 'Invalid admin secret';
        document.getElementById('login-error').style.display = 'block';
      });
    }
  }

  async function doLogout() {
    if (cfg.sessionBased) {
      // Session-based: call the local admin logout endpoint to clear the HTTP-only cookie.
      try {
        // Use the local /logout handler within the admin router
        await fetch(cfg.base + '/logout', { method: 'POST', credentials: 'include' });
      } catch { /* ignore network errors — still reload */ }
      location.reload();
    } else {
      sessionStorage.removeItem('admin_token');
      location.reload();
    }
  }

  var secretInput = document.getElementById('secret-input');
  if (secretInput) {
    secretInput.addEventListener('keydown', function (e) {
      if (e.key === 'Enter') doLogin();
    });
  }

  // Auto-login if token stored (legacy)
  var stored = sessionStorage.getItem('admin_token');
  if (stored) {
    _token = stored;
    api('GET', '/api/ping').then(function () {
      document.getElementById('login').style.display = 'none';
      document.getElementById('app').style.display = 'flex';
      document.getElementById('app').style.flexDirection = 'column';
      showTab('users');
    }).catch(function () { sessionStorage.removeItem('admin_token'); _token = ''; });
  } else if (cfg.sessionBased && !document.getElementById('login')) {
    // Session-based (cookie): if the server didn't render the login form, we are already authenticated.
    document.getElementById('app').style.display = 'flex';
    document.getElementById('app').style.flexDirection = 'column';
    showTab('users');
  }

  // ---- API helper ----------------------------------------------------------
  async function api(method, path, body) {
    var headers = { 'Content-Type': 'application/json' };
    // In token-based (legacy adminSecret) mode, attach the Bearer token.
    // In session-based (cookie) mode, never send an empty Authorization header —
    // an empty "Bearer " string can confuse global fetch interceptors (e.g. auth.js)
    // and cause them to treat any 401 from admin API endpoints as a session expiry
    // event, triggering a redirect to /auth/ui/login.
    if (_token) {
      headers['Authorization'] = 'Bearer ' + _token;
    }
    var res = await fetch(BASE + path, {
      method: method,
      headers: headers,
      // Always include cookies so the admin session cookie is sent even in
      // scenarios where the admin router is mounted on a different sub-path
      // or when a service worker intercepts the request.
      credentials: 'include',
      body: body ? JSON.stringify(body) : undefined
    });
    if (!res.ok) {
      var err = await res.json().catch(function () { return { error: res.statusText }; });
      throw new Error(err.error || res.statusText);
    }
    return res.json();
  }

  // ---- Flash ---------------------------------------------------------------
  function flash(msg, type) {
    var el = document.createElement('div');
    el.className = 'alert alert-' + (type === 'error' ? 'error' : 'success');
    el.textContent = msg;
    el.style.cssText = 'padding:.75rem 1rem;border-radius:6px;font-size:.8125rem;margin-bottom:.5rem;box-shadow:0 2px 8px rgba(0,0,0,.1)';
    document.getElementById('flash').appendChild(el);
    setTimeout(function () { el.remove(); }, 3500);
  }

  // ---- Tab routing ---------------------------------------------------------
  function showTab(tab) {
    _state.tab = tab;
    document.querySelectorAll('nav button').forEach(function (b) { b.classList.remove('active'); });
    var btn = document.getElementById('tab-' + tab);
    if (btn) btn.classList.add('active');
    if (tab === 'users') renderUsers();
    else if (tab === 'sessions') renderSessions();
    else if (tab === 'roles') renderRoles();
    else if (tab === 'tenants') renderTenants();
    else if (tab === 'apiKeys') renderApiKeys();
    else if (tab === 'webhooks') renderWebhooks();
    else if (tab === 'control') renderControl();
    else if (tab === 'templates') renderTemplates();
  }

  // ---- Helpers -------------------------------------------------------------
  function badge(text, cls) {
    return '<span class="badge badge-' + cls + '">' + esc(String(text)) + '</span>';
  }

  function esc(s) {
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&apos;');
  }

  function ts(d) {
    if (!d) return '\u2014';
    try { return new Date(d).toLocaleString(); } catch (e) { return String(d); }
  }

  function pagerHtml(page, hasMore, prev, next) {
    return '<div class="pager"><button ' + (page === 0 ? 'disabled' : '') + ' onclick="' + prev + '">\u2190 Prev</button>'
      + '<span>Page ' + (page + 1) + '</span>'
      + '<button ' + (!hasMore ? 'disabled' : '') + ' onclick="' + next + '">Next \u2192</button></div>';
  }

  // ---- Users ---------------------------------------------------------------
  async function renderUsers() {
    var main = document.getElementById('main');
    main.innerHTML = '<div class="card"><div class="card-header"><h2>Users</h2><span class="meta"><span class="spinner"></span></span></div></div>';
    try {
      var filterParam = _state.users.filter ? '&filter=' + encodeURIComponent(_state.users.filter) : '';
      var res = await api('GET', '/api/users?limit=' + PAGE_SIZE + '&offset=' + (_state.users.page * PAGE_SIZE) + filterParam);
      var users = res.users;
      var total = res.total;
      var hasMore = (_state.users.page + 1) * PAGE_SIZE < total;
      var showManage = FEAT_ROLES || FEAT_METADATA || FEAT_TENANTS || FEAT_LINKED_ACCOUNTS;
      if (FEAT_ROLES && users.length > 0) {
        await Promise.allSettled(users.map(function (u) {
          return api('GET', '/api/users/' + encodeURIComponent(u.id) + '/roles')
            .then(function (d) { _state.users.rolesCache[u.id] = d.roles || []; })
            .catch(function () { });
        }));
      }
      if (FEAT_LINKED_ACCOUNTS && users.length > 0) {
        await Promise.allSettled(users.map(function (u) {
          return api('GET', '/api/users/' + encodeURIComponent(u.id) + '/linked-accounts')
            .then(function (d) { _state.users.linkedAccountsCache[u.id] = d.linkedAccounts || []; })
            .catch(function () { });
        }));
      }
      var colCount = 8 + (FEAT_ROLES ? 1 : 0) + (FEAT_LINKED_ACCOUNTS ? 1 : 0);
      var rows = '';
      if (users.length === 0) {
        rows = '<tr><td colspan="' + colCount + '"><div class="empty">No users found</div></td></tr>';
      } else {
        for (var i = 0; i < users.length; i++) {
          var u = users[i];
          var isOpen = _state.users.openId === u.id;
          var isChecked = _state.users.selected.has(u.id);
          var rbacRoles = FEAT_ROLES ? (_state.users.rolesCache[u.id] || []) : [];
          var rbacCol = FEAT_ROLES
            ? '<td>' + (rbacRoles.length === 0 ? '<span style="color:#9ca3af">\u2014</span>' : rbacRoles.map(function (r) { return badge(r, 'indigo'); }).join(' ')) + '</td>'
            : '';
          var linkedAccounts = FEAT_LINKED_ACCOUNTS ? (_state.users.linkedAccountsCache[u.id] || []) : [];
          var linkedCol = FEAT_LINKED_ACCOUNTS
            ? '<td>' + (linkedAccounts.length === 0
              ? '<span style="color:#9ca3af">\u2014</span>'
              : badge(linkedAccounts[0].provider, 'purple') + (linkedAccounts.length > 1 ? ' <span style="color:#6b7280;font-size:.75rem">+' + (linkedAccounts.length - 1) + '</span>' : ''))
            + '</td>'
            : '';
          rows += '<tr' + (isOpen ? ' class="tr-open"' : '') + '>'
            + '<td class="cb-col"><input type="checkbox" ' + (isChecked ? 'checked' : '') + ' onchange="toggleSelectUser(' + esc(JSON.stringify(u.id)) + ')"></td>'
            + '<td style="font-family:monospace;font-size:.75rem">' + esc(u.id) + '</td>'
            + '<td>' + esc(u.email) + '</td>'
            + '<td>' + (u.role ? badge(u.role, 'blue') : badge('\u2014', 'gray')) + '</td>'
            + rbacCol
            + linkedCol
            + '<td>' + (u.isEmailVerified ? badge('\u2713 verified', 'green') : badge('unverified', 'gray')) + '</td>'
            + '<td>' + (u.isTotpEnabled ? badge('on', 'green') : badge('off', 'gray')) + '</td>'
            + '<td>' + ts(u.createdAt) + '</td>'
            + '<td style="display:flex;gap:.25rem">'
            + (showManage ? '<button class="btn btn-sm" style="background:' + (isOpen ? '#1a1a2e' : '#e0e7ff') + ';color:' + (isOpen ? 'white' : '#3730a3') + '" onclick="toggleUserPanel(' + esc(JSON.stringify(u.id)) + ')"> ' + (isOpen ? 'Close' : 'Manage') + '</button>' : '')
            + '<button class="btn btn-danger" onclick="deleteUser(' + esc(JSON.stringify(u.id)) + ', ' + esc(JSON.stringify(u.email)) + ')">Delete</button>'
            + '</td>'
            + '</tr>';
        }
      }
      var openUser = _state.users.openId ? users.find(function (u) { return u.id === _state.users.openId; }) : null;
      var panelHtml = openUser
        ? '<div class="card" style="border-top:3px solid #1a1a2e">'
        + '<div class="card-header" style="background:#f0f4ff"><h2 style="font-size:.9375rem">\u2699\uFE0F\u00A0Managing: <span style="color:#3730a3;font-weight:700">' + esc(openUser.email) + '</span></h2></div>'
        + '<div id="user-panel-' + esc(openUser.id) + '" style="padding:1.25rem 1.5rem"><span class="spinner"></span></div>'
        + '</div>'
        : '';
      var selCount = _state.users.selected.size;
      var batchBar = '<div class="batch-bar' + (selCount > 0 ? ' visible' : '') + '" id="batch-bar">'
        + '<span>' + selCount + ' user(s) selected</span>'
        + '<button class="btn btn-danger btn-sm" onclick="deleteSelected()">Delete selected</button>'
        + '<button class="btn btn-sm" style="background:#f3f4f6;border:1px solid #e5e7eb" onclick="clearSelection()">Clear</button>'
        + '</div>';
      var allChecked = users.length > 0 && users.every(function (u) { return _state.users.selected.has(u.id); });
      var thead = '<thead><tr><th class="cb-col"><input type="checkbox" ' + (allChecked ? 'checked' : '') + ' onchange="toggleSelectAll(this, ' + esc(JSON.stringify(users.map(function (u) { return u.id; }))) + ')"></th><th>ID</th><th>Email</th><th>Base Role</th>'
        + (FEAT_ROLES ? '<th>Assigned Roles</th>' : '')
        + (FEAT_LINKED_ACCOUNTS ? '<th>Linked Accounts</th>' : '')
        + '<th>Verified</th><th>2FA</th><th>Created</th><th></th></tr></thead>';
      var policyCard = FEAT_2FA_POLICY
        ? '<div class="card" style="border-left:4px solid #f59e0b">'
        + '<div class="card-header" style="background:#fffbeb"><h2 style="font-size:.9375rem">\uD83D\uDD10 2FA Enforcement Policy</h2><span class="meta">Batch operation</span></div>'
        + '<div style="padding:1rem 1.5rem;display:flex;align-items:center;gap:1.25rem;flex-wrap:wrap">'
        + '<p style="font-size:.875rem;color:#6b7280;flex:1;min-width:180px">Force all users to activate Two-Factor Authentication. Users without 2FA configured will be blocked at login and prompted to set it up.</p>'
        + '<div style="display:flex;gap:.5rem;flex-shrink:0">'
        + '<button class="btn btn-primary" onclick="setBulk2FA(true)">Require 2FA for all</button>'
        + '<button class="btn" style="background:#f3f4f6;border:1px solid #e5e7eb" onclick="setBulk2FA(false)">Remove requirement</button>'
        + '</div>'
        + '</div></div>'
        : '';
      var filterBar = '<div class="filter-bar">'
        + '<input type="text" placeholder="Filter by email or ID\u2026" value="' + esc(_state.users.filter) + '" oninput="_state.users.filter=this.value;_state.users.page=0;_state.users.selected=new Set();renderUsers()" style="max-width:300px">'
        + '<span style="font-size:.8125rem;color:#9ca3af">' + total + ' total</span>'
        + '</div>';
      main.innerHTML =
        policyCard
        + '<div class="card">'
        + '<div class="card-header"><h2>Users</h2></div>'
        + filterBar
        + batchBar
        + '<div class="table-wrap"><table>' + thead + '<tbody>' + rows + '</tbody></table></div>'
        + pagerHtml(_state.users.page, hasMore, '_state.users.page--;renderUsers()', '_state.users.page++;renderUsers()')
        + '</div>'
        + panelHtml;
      if (_state.users.openId) loadUserPanel(_state.users.openId);
    } catch (e) {
      main.innerHTML = '<div class="alert alert-error">' + esc(e.message) + '</div>';
    }
  }

  function toggleSelectUser(id) {
    if (_state.users.selected.has(id)) _state.users.selected.delete(id);
    else _state.users.selected.add(id);
    var bar = document.getElementById('batch-bar');
    if (bar) {
      var n = _state.users.selected.size;
      bar.className = 'batch-bar' + (n > 0 ? ' visible' : '');
      bar.querySelector('span').textContent = n + ' user(s) selected';
    }
  }

  function toggleSelectAll(cb, ids) {
    if (cb.checked) ids.forEach(function (id) { _state.users.selected.add(id); });
    else ids.forEach(function (id) { _state.users.selected.delete(id); });
    renderUsers();
  }

  function clearSelection() {
    _state.users.selected = new Set();
    renderUsers();
  }

  async function deleteSelected() {
    var ids = [..._state.users.selected];
    if (ids.length === 0) return;
    if (!confirm('Delete ' + ids.length + ' user(s)? This cannot be undone.')) return;
    try {
      await Promise.all(ids.map(function (id) { return api('DELETE', '/api/users/' + encodeURIComponent(id)); }));
      flash(ids.length + ' user(s) deleted');
      _state.users.selected = new Set();
      renderUsers();
    } catch (e) { flash(e.message, 'error'); }
  }

  function toggleUserPanel(id) {
    _state.users.openId = _state.users.openId === id ? null : id;
    renderUsers();
  }

  async function loadUserPanel(userId) {
    var el = document.getElementById('user-panel-' + userId);
    if (!el) return;
    try {
      var sections = '';
      if (FEAT_ROLES) {
        var roleResults = await Promise.all([
          api('GET', '/api/roles').catch(function () { return { roles: [] }; }),
          api('GET', '/api/users/' + encodeURIComponent(userId) + '/roles').catch(function () { return { roles: [] }; })
        ]);
        var allRoles = roleResults[0].roles || [];
        var userRoles = roleResults[1].roles || [];
        _state.users.rolesCache[userId] = userRoles;
        var unassigned = allRoles.filter(function (r) { return !userRoles.includes(r.name); });
        var chipList = userRoles.length === 0
          ? '<span style="color:#9ca3af;font-size:.8125rem">No roles assigned</span>'
          : userRoles.map(function (r) { return '<span class="badge badge-blue role-chip" title="Click to remove" onclick="removeUserRole(' + esc(JSON.stringify(userId)) + ', ' + esc(JSON.stringify(r)) + ')">' + esc(r) + ' \u2715</span>'; }).join(' ');
        var assignRow = unassigned.length > 0
          ? '<div class="form-row" style="margin-top:.625rem">'
          + '<select id="role-sel-' + esc(userId) + '" class="form-select">'
          + unassigned.map(function (r) { return '<option value="' + esc(r.name) + '">' + esc(r.name) + '</option>'; }).join('')
          + '</select>'
          + '<button class="btn btn-primary btn-sm" onclick="addUserRole(' + esc(JSON.stringify(userId)) + ')">Assign</button>'
          + '</div>'
          : '<p style="font-size:.75rem;color:#6b7280;margin-top:.5rem">'
          + (allRoles.length === 0 ? 'No roles defined yet. Create roles in the Roles & Permissions tab.' : 'All available roles are already assigned.')
          + '</p>';
        sections += '<div class="manage-section">'
          + '<div class="manage-section-title">\uD83D\uDEE1\uFE0F Roles</div>'
          + '<div class="roles-list">' + chipList + '</div>'
          + assignRow
          + '</div>';
      }
      if (FEAT_TENANTS) {
        var tenantResults = await Promise.all([
          api('GET', '/api/tenants').catch(function () { return { tenants: [] }; }),
          api('GET', '/api/users/' + encodeURIComponent(userId) + '/tenants').catch(function () { return { tenantIds: [] }; })
        ]);
        var allTenants = tenantResults[0].tenants || [];
        var assignedIds = new Set(tenantResults[1].tenantIds || []);
        var tenantChipList = allTenants.filter(function (t) { return assignedIds.has(t.id); }).length === 0
          ? '<span style="color:#9ca3af;font-size:.8125rem">No tenants assigned</span>'
          : allTenants.filter(function (t) { return assignedIds.has(t.id); }).map(function (t) {
            return '<span class="badge badge-green role-chip" title="Click to remove" onclick="removeUserTenant(' + esc(JSON.stringify(userId)) + ',' + esc(JSON.stringify(t.id)) + ')">' + esc(t.name) + ' \u2715</span>';
          }).join(' ');
        var unassignedTenants = allTenants.filter(function (t) { return !assignedIds.has(t.id); });
        var tenantAssignRow = unassignedTenants.length > 0
          ? '<div class="form-row" style="margin-top:.625rem">'
          + '<select id="tenant-sel-' + esc(userId) + '" class="form-select">'
          + unassignedTenants.map(function (t) { return '<option value="' + esc(t.id) + '">' + esc(t.name) + '</option>'; }).join('')
          + '</select>'
          + '<button class="btn btn-primary btn-sm" onclick="addUserTenant(' + esc(JSON.stringify(userId)) + ')">Assign</button>'
          + '</div>'
          : '<p style="font-size:.75rem;color:#6b7280;margin-top:.5rem">All available tenants are already assigned.</p>';
        sections += '<div class="manage-section">'
          + '<div class="manage-section-title">\uD83C\uDFE2 Tenants</div>'
          + '<div class="roles-list">' + tenantChipList + '</div>'
          + tenantAssignRow
          + '</div>';
      }
      if (FEAT_METADATA) {
        var meta = await api('GET', '/api/users/' + encodeURIComponent(userId) + '/metadata').catch(function () { return {}; });
        sections += '<div class="manage-section">'
          + '<div class="manage-section-title">\uD83D\uDDC2\uFE0F Metadata</div>'
          + '<textarea id="meta-' + esc(userId) + '" class="meta-editor">' + esc(JSON.stringify(meta, null, 2)) + '</textarea>'
          + '<div style="margin-top:.5rem"><button class="btn btn-primary btn-sm" onclick="saveUserMeta(' + esc(JSON.stringify(userId)) + ')">Save</button></div>'
          + '</div>';
      }
      if (FEAT_LINKED_ACCOUNTS) {
        var laRes = await api('GET', '/api/users/' + encodeURIComponent(userId) + '/linked-accounts').catch(function () { return { linkedAccounts: [] }; });
        var accts = laRes.linkedAccounts;
        var items = (accts || []).map(function (a) {
          return '<li style="display:flex;align-items:center;gap:.5rem;padding:.375rem 0;border-bottom:1px solid #f3f4f6">'
            + badge(esc(a.provider), 'purple')
            + '<span style="font-size:.8125rem;color:#374151;flex:1">' + esc(a.name || a.email || a.providerAccountId) + '</span>'
            + (a.email ? '<span style="font-size:.75rem;color:#9ca3af">' + esc(a.email) + '</span>' : '')
            + (a.linkedAt ? '<span style="font-size:.75rem;color:#9ca3af">' + ts(a.linkedAt) + '</span>' : '')
            + '</li>';
        }).join('');
        sections += '<div class="manage-section">'
          + '<div class="manage-section-title">\uD83D\uDD17 Linked Accounts</div>'
          + (accts && accts.length > 0
            ? '<ul style="list-style:none;padding:0;margin:0">' + items + '</ul>'
            : '<span style="color:#9ca3af;font-size:.8125rem">No linked accounts</span>')
          + '</div>';
      }
      el.innerHTML = sections
        ? '<div class="manage-grid">' + sections + '</div>'
        : '<span style="color:#9ca3af;font-size:.8125rem">No management features available.</span>';
    } catch (e) {
      el.innerHTML = '<span style="color:#991b1b;font-size:.8125rem">' + esc(e.message) + '</span>';
    }
  }

  async function addUserTenant(userId) {
    var sel = document.getElementById('tenant-sel-' + userId);
    if (!sel || !sel.value) return;
    try {
      await api('POST', '/api/tenants/' + encodeURIComponent(sel.value) + '/users', { userId: userId });
      flash('Tenant assigned');
      loadUserPanel(userId);
    } catch (e) { flash(e.message, 'error'); }
  }

  async function removeUserTenant(userId, tenantId) {
    try {
      await api('DELETE', '/api/tenants/' + encodeURIComponent(tenantId) + '/users/' + encodeURIComponent(userId));
      flash('Tenant removed');
      loadUserPanel(userId);
    } catch (e) { flash(e.message, 'error'); }
  }

  async function addUserRole(userId) {
    var sel = document.getElementById('role-sel-' + userId);
    if (!sel || !sel.value) return;
    try {
      await api('POST', '/api/users/' + encodeURIComponent(userId) + '/roles', { role: sel.value });
      flash('Role assigned');
      renderUsers();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function removeUserRole(userId, role) {
    try {
      await api('DELETE', '/api/users/' + encodeURIComponent(userId) + '/roles/' + encodeURIComponent(role));
      flash('Role removed');
      renderUsers();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function saveUserMeta(userId) {
    var ta = document.getElementById('meta-' + userId);
    if (!ta) return;
    var parsed;
    try { parsed = JSON.parse(ta.value); } catch (e) { flash('Invalid JSON', 'error'); return; }
    try {
      await api('PUT', '/api/users/' + encodeURIComponent(userId) + '/metadata', parsed);
      flash('Metadata saved');
    } catch (e) { flash(e.message, 'error'); }
  }

  async function deleteUser(id, email) {
    if (!confirm('Delete user ' + JSON.stringify(email) + '? This cannot be undone.')) return;
    try {
      await api('DELETE', '/api/users/' + encodeURIComponent(id));
      flash('User deleted');
      renderUsers();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function setBulk2FA(required) {
    var action = required ? 'require 2FA for ALL users' : 'remove the 2FA requirement from ALL users';
    if (!confirm('Are you sure you want to ' + action + '?')) return;
    try {
      var res = await api('POST', '/api/2fa-policy', { required: required });
      flash(res.updated + ' user(s) updated \u2014 2FA ' + (required ? 'now required' : 'requirement removed'));
      renderUsers();
    } catch (e) { flash(e.message, 'error'); }
  }

  // ---- Sessions ------------------------------------------------------------
  async function renderSessions() {
    var main = document.getElementById('main');
    main.innerHTML = '<div class="card"><div class="card-header"><h2>Sessions</h2><span class="meta"><span class="spinner"></span></span></div></div>';
    try {
      var filterParam = _state.sessions.filter ? '&filter=' + encodeURIComponent(_state.sessions.filter) : '';
      var res = await api('GET', '/api/sessions?limit=' + PAGE_SIZE + '&offset=' + (_state.sessions.page * PAGE_SIZE) + filterParam);
      var sessions = res.sessions;
      var total = res.total;
      var hasMore = (_state.sessions.page + 1) * PAGE_SIZE < total;
      var rows = sessions.length === 0
        ? '<tr><td colspan="8"><div class="empty">No sessions</div></td></tr>'
        : sessions.map(function (s) {
          return '<tr>'
            + '<td style="font-family:monospace;font-size:.75rem">' + esc(s.sessionHandle.slice(0, 12)) + '\u2026</td>'
            + '<td style="font-family:monospace;font-size:.75rem">' + esc(s.userId) + '</td>'
            + '<td>' + esc(s.ipAddress || '\u2014') + '</td>'
            + '<td title="' + esc(s.userAgent || '') + '" style="max-width:160px">' + esc((s.userAgent || '\u2014').slice(0, 40)) + '</td>'
            + '<td>' + ts(s.createdAt) + '</td>'
            + '<td>' + ts(s.lastActiveAt) + '</td>'
            + '<td>' + ts(s.expiresAt) + '</td>'
            + '<td><button class="btn btn-danger" onclick="revokeSession(' + esc(JSON.stringify(s.sessionHandle)) + ')">Revoke</button></td>'
            + '</tr>';
        }).join('');
      main.innerHTML = '<div class="card">'
        + '<div class="card-header"><h2>Active Sessions</h2></div>'
        + '<div class="filter-bar"><input type="text" placeholder="Filter by User ID or IP\u2026" value="' + esc(_state.sessions.filter) + '" oninput="_state.sessions.filter=this.value;_state.sessions.page=0;renderSessions()" style="max-width:300px"><span style="font-size:.8125rem;color:#9ca3af">' + total + ' total</span></div>'
        + '<div class="table-wrap"><table>'
        + '<thead><tr><th>Handle</th><th>User ID</th><th>IP</th><th>User Agent</th><th>Created</th><th>Last Active</th><th>Expires</th><th></th></tr></thead>'
        + '<tbody>' + rows + '</tbody></table></div>'
        + pagerHtml(_state.sessions.page, hasMore, '_state.sessions.page--;renderSessions()', '_state.sessions.page++;renderSessions()')
        + '</div>';
    } catch (e) {
      main.innerHTML = '<div class="alert alert-error">' + esc(e.message) + '</div>';
    }
  }

  async function revokeSession(handle) {
    try {
      await api('DELETE', '/api/sessions/' + encodeURIComponent(handle));
      flash('Session revoked');
      renderSessions();
    } catch (e) { flash(e.message, 'error'); }
  }

  // ---- Roles ---------------------------------------------------------------
  async function renderRoles() {
    var main = document.getElementById('main');
    main.innerHTML = '<div class="card"><div class="card-header"><h2>Roles</h2><span class="meta"><span class="spinner"></span></span></div></div>';
    try {
      var res = await api('GET', '/api/roles');
      var allRoles = res.roles;
      var roles = _state.roles.filter
        ? allRoles.filter(function (r) { return r.name.toLowerCase().includes(_state.roles.filter.toLowerCase()); })
        : allRoles;
      var html = '<div class="card"><div class="card-header"><h2>Roles & Permissions</h2></div>'
        + '<div class="filter-bar"><input type="text" placeholder="Filter by role name\u2026" value="' + esc(_state.roles.filter) + '" oninput="_state.roles.filter=this.value;renderRoles()" style="max-width:300px"><span style="font-size:.8125rem;color:#9ca3af">' + allRoles.length + ' total</span></div>';
      if (roles.length === 0) {
        html += '<div class="empty">No roles found</div>';
      } else {
        html += '<div class="table-wrap"><table><thead><tr><th>Role</th><th>Permissions</th><th></th></tr></thead><tbody>';
        for (var i = 0; i < roles.length; i++) {
          var r = roles[i];
          html += '<tr>'
            + '<td><strong>' + esc(r.name) + '</strong></td>'
            + '<td>' + (r.permissions.length === 0 ? '<span style="color:#9ca3af">none</span>' : r.permissions.map(function (p) { return badge(p, 'blue'); }).join(' ')) + '</td>'
            + '<td><button class="btn btn-danger" onclick="deleteRole(' + esc(JSON.stringify(r.name)) + ')">Delete</button></td>'
            + '</tr>';
        }
        html += '</tbody></table></div>';
      }
      html += '<div style="padding:1rem 1.5rem;border-top:1px solid #f3f4f6">'
        + '<div class="form-row">'
        + '<input type="text" id="new-role-name" placeholder="Role name" style="width:180px">'
        + '<input type="text" id="new-role-perms" placeholder="Permissions (comma-separated)">'
        + '<button class="btn btn-primary btn-sm" onclick="createRole()">Add Role</button>'
        + '</div></div></div>';
      main.innerHTML = html;
    } catch (e) {
      main.innerHTML = '<div class="alert alert-error">' + esc(e.message) + '</div>';
    }
  }

  async function createRole() {
    var name = document.getElementById('new-role-name').value.trim();
    var perms = document.getElementById('new-role-perms').value.split(',').map(function (s) { return s.trim(); }).filter(Boolean);
    if (!name) return;
    try {
      await api('POST', '/api/roles', { name: name, permissions: perms });
      flash('Role created');
      renderRoles();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function deleteRole(name) {
    if (!confirm('Delete role "' + name + '"?')) return;
    try {
      await api('DELETE', '/api/roles/' + encodeURIComponent(name));
      flash('Role deleted');
      renderRoles();
    } catch (e) { flash(e.message, 'error'); }
  }

  // ---- Tenants -------------------------------------------------------------
  async function renderTenants() {
    var main = document.getElementById('main');
    main.innerHTML = '<div class="card"><div class="card-header"><h2>Tenants</h2><span class="meta"><span class="spinner"></span></span></div></div>';
    try {
      var res = await api('GET', '/api/tenants');
      var allTenants = res.tenants;
      var tenants = _state.tenants.filter
        ? allTenants.filter(function (t) { return t.name.toLowerCase().includes(_state.tenants.filter.toLowerCase()) || t.id.toLowerCase().includes(_state.tenants.filter.toLowerCase()); })
        : allTenants;
      var html = '<div class="card"><div class="card-header"><h2>Tenants</h2></div>'
        + '<div class="filter-bar"><input type="text" placeholder="Filter by name or ID\u2026" value="' + esc(_state.tenants.filter) + '" oninput="_state.tenants.filter=this.value;renderTenants()" style="max-width:300px"><span style="font-size:.8125rem;color:#9ca3af">' + allTenants.length + ' total</span></div>';
      html += '<div class="table-wrap"><table><thead><tr><th>ID</th><th>Name</th><th>Status</th><th>Created</th><th></th></tr></thead><tbody>';
      if (tenants.length === 0) {
        html += '<tr><td colspan="5"><div class="empty">No tenants found</div></td></tr>';
      } else {
        for (var i = 0; i < tenants.length; i++) {
          var t = tenants[i];
          html += '<tr>'
            + '<td style="font-family:monospace;font-size:.75rem">' + esc(t.id) + '</td>'
            + '<td><strong>' + esc(t.name) + '</strong></td>'
            + '<td>' + (t.isActive !== false ? badge('active', 'green') : badge('inactive', 'red')) + '</td>'
            + '<td>' + ts(t.createdAt) + '</td>'
            + '<td style="display:flex;gap:.25rem">'
            + '<button class="btn btn-sm" style="background:#d1fae5;color:#065f46" onclick="toggleTenantPanel(' + esc(JSON.stringify(t.id)) + ')">Members</button>'
            + '<button class="btn btn-danger" onclick="deleteTenant(' + esc(JSON.stringify(t.id)) + ')">Delete</button>'
            + '</td>'
            + '</tr>'
            + (_state.tenants.openId === t.id ? '<tr><td colspan="5" style="padding:0"><div id="tenant-panel-' + esc(t.id) + '" style="padding:1rem 1.5rem;background:#f0fdf4;border-top:1px solid #e5e7eb"></div></td></tr>' : '');
        }
      }
      html += '</tbody></table></div>';
      html += '<div style="padding:1rem 1.5rem;border-top:1px solid #f3f4f6">'
        + '<div class="form-row">'
        + '<input type="text" id="new-tenant-name" placeholder="Tenant name" style="width:240px">'
        + '<button class="btn btn-primary btn-sm" onclick="createTenant()">Add Tenant</button>'
        + '</div></div></div>';
      main.innerHTML = html;
      if (_state.tenants.openId) loadTenantPanel(_state.tenants.openId);
    } catch (e) {
      main.innerHTML = '<div class="alert alert-error">' + esc(e.message) + '</div>';
    }
  }

  function toggleTenantPanel(id) {
    _state.tenants.openId = _state.tenants.openId === id ? null : id;
    renderTenants();
  }

  async function loadTenantPanel(tenantId) {
    var el = document.getElementById('tenant-panel-' + tenantId);
    if (!el) return;
    el.innerHTML = '<span class="spinner"></span>';
    try {
      var res = await api('GET', '/api/tenants/' + encodeURIComponent(tenantId) + '/users').catch(function () { return { userIds: [] }; });
      var userIds = res.userIds;
      var html = '<strong style="font-size:.8125rem">Members (' + userIds.length + ')</strong>';
      html += '<div style="display:flex;flex-wrap:wrap;gap:.25rem;margin:.5rem 0">'
        + (userIds.length === 0
          ? '<span style="color:#9ca3af;font-size:.8125rem">No members</span>'
          : userIds.map(function (uid) { return '<span class="badge badge-green" style="cursor:pointer" title="Click to remove" onclick="removeTenantUser(' + esc(JSON.stringify(tenantId)) + ', ' + esc(JSON.stringify(uid)) + ')">' + esc(uid) + ' \u2715</span>'; }).join(' '))
        + '</div>';
      html += '<div class="form-row" style="margin-top:.5rem">'
        + '<input type="text" id="tenant-uid-' + esc(tenantId) + '" placeholder="User ID" style="width:220px">'
        + '<button class="btn btn-primary btn-sm" onclick="addTenantUser(' + esc(JSON.stringify(tenantId)) + ')">Add Member</button>'
        + '</div>';
      el.innerHTML = html;
    } catch (e) {
      el.innerHTML = '<span style="color:#991b1b;font-size:.8125rem">' + esc(e.message) + '</span>';
    }
  }

  async function addTenantUser(tenantId) {
    var inp = document.getElementById('tenant-uid-' + tenantId);
    var userId = inp ? inp.value.trim() : '';
    if (!userId) return;
    try {
      await api('POST', '/api/tenants/' + encodeURIComponent(tenantId) + '/users', { userId: userId });
      flash('User added to tenant');
      loadTenantPanel(tenantId);
    } catch (e) { flash(e.message, 'error'); }
  }

  async function removeTenantUser(tenantId, userId) {
    try {
      await api('DELETE', '/api/tenants/' + encodeURIComponent(tenantId) + '/users/' + encodeURIComponent(userId));
      flash('User removed from tenant');
      loadTenantPanel(tenantId);
    } catch (e) { flash(e.message, 'error'); }
  }

  async function createTenant() {
    var name = document.getElementById('new-tenant-name').value.trim();
    if (!name) return;
    try {
      await api('POST', '/api/tenants', { name: name, isActive: true });
      flash('Tenant created');
      renderTenants();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function deleteTenant(id) {
    if (!confirm('Delete tenant ' + id + '?')) return;
    try {
      await api('DELETE', '/api/tenants/' + encodeURIComponent(id));
      flash('Tenant deleted');
      renderTenants();
    } catch (e) { flash(e.message, 'error'); }
  }

  // ---- Control -------------------------------------------------------------
  async function renderControl() {
    if (!FEAT_CONTROL) {
      document.getElementById('main').innerHTML = '<div class="alert alert-error">Control store not configured.</div>';
      return;
    }
    var main = document.getElementById('main');
    main.innerHTML = '<div class="card"><div class="card-header"><h2>\u2699\uFE0F Control</h2><span class="meta"><span class="spinner"></span></span></div></div>';
    try {
      var results = await Promise.all([
        api('GET', '/api/settings'),
        api('GET', '/api/actions').catch(function () { return { actions: [] }; })
      ]);
      var settings = results[0];
      var registeredActions = results[1].actions || [];

      function toggleHtml(id, label, desc, checked) {
        return '<div class="toggle-row">'
          + '<div class="toggle-label">' + label + '<small>' + desc + '</small></div>'
          + '<label class="toggle"><input type="checkbox" id="ctrl-' + id + '" ' + (checked ? 'checked' : '') + ' onchange="updateSetting(' + esc(JSON.stringify(id)) + ', this.checked)"><span class="toggle-slider"></span></label>'
          + '</div>';
      }

      var evMode = settings.emailVerificationMode || (settings.requireEmailVerification ? 'strict' : 'none');
      var graceDays = settings.lazyEmailVerificationGracePeriodDays != null ? settings.lazyEmailVerificationGracePeriodDays : 7;
      var evModeHtml = '<div class="toggle-row" style="flex-direction:column;align-items:flex-start;gap:.5rem">'
        + '<div class="toggle-label">Email Verification Policy<small>Controls when users must verify their email address before logging in.</small></div>'
        + '<div style="display:flex;gap:.75rem;flex-wrap:wrap;margin-top:.25rem">'
        + ['none', 'lazy', 'strict'].map(function (m) {
          return '<label style="display:flex;align-items:center;gap:.35rem;font-size:.875rem;cursor:pointer">'
            + '<input type="radio" name="evMode" value="' + m + '"' + (evMode === m ? ' checked' : '') + ' onchange="updateEmailVerificationMode(this.value)">'
            + (m === 'none' ? 'None \u2014 not required' : m === 'lazy' ? 'Lazy \u2014 required after grace period' : 'Strict \u2014 required immediately')
            + '</label>';
        }).join('')
        + '</div>'
        + '<div id="ev-grace-row" style="display:' + (evMode === 'lazy' ? 'flex' : 'none') + ';align-items:center;gap:.5rem;margin-top:.25rem">'
        + '<label style="font-size:.8125rem">Grace period (days):</label>'
        + '<input type="number" id="ev-grace-days" min="1" max="365" value="' + graceDays + '" style="width:80px;padding:.25rem .5rem;border:1px solid #d1d5db;border-radius:6px;font-size:.875rem">'
        + '<button class="btn btn-primary" style="padding:.25rem .75rem;font-size:.8125rem" onclick="saveGracePeriod()">Save</button>'
        + '</div>'
        + '</div>';

      var enabledActions = settings.enabledWebhookActions || [];
      var actionsHtml = registeredActions.length === 0 ? '' :
        '<div class="card" style="margin-top:1.5rem">'
        + '<div class="card-header"><h2>\uD83E\uDDE9 Webhook Actions</h2><span class="meta">Globally enable or disable injectable actions for inbound webhook scripts</span></div>'
        + '<div style="padding:.75rem 1.5rem;max-width:640px">'
        + (function () {
          var groups = {};
          for (var i = 0; i < registeredActions.length; i++) {
            var a = registeredActions[i];
            if (!groups[a.category]) groups[a.category] = [];
            groups[a.category].push(a);
          }
          var html = '';
          var cats = Object.keys(groups);
          for (var ci = 0; ci < cats.length; ci++) {
            var cat = cats[ci];
            var acts = groups[cat];
            html += '<div style="margin-bottom:1rem"><h3 style="font-size:.8125rem;text-transform:uppercase;letter-spacing:.05em;color:#9ca3af;margin-bottom:.5rem">' + esc(cat) + '</h3>';
            for (var ai = 0; ai < acts.length; ai++) {
              var a2 = acts[ai];
              var checked = enabledActions.includes(a2.id);
              var depsUnmet = (a2.dependsOn || []).some(function (dep) { return !enabledActions.includes(dep); });
              html += '<div class="toggle-row" style="' + (depsUnmet ? 'opacity:.5;' : '') + '">'
                + '<div class="toggle-label">' + esc(a2.label)
                + (a2.dependsOn && a2.dependsOn.length ? '<small style="color:#f59e0b">Requires: ' + a2.dependsOn.map(function (d) { return esc(d); }).join(', ') + '</small>' : '')
                + '<small>' + esc(a2.description) + '</small>'
                + '<code style="font-size:.7rem;color:#6b7280">' + esc(a2.id) + '</code></div>'
                + '<label class="toggle"><input type="checkbox" ' + (checked ? 'checked' : '') + ' ' + (depsUnmet ? 'disabled' : '') + ' onchange="toggleWebhookAction(' + esc(JSON.stringify(a2.id)) + ',this.checked)"><span class="toggle-slider"></span></label>'
                + '</div>';
            }
            html += '</div>';
          }
          return html;
        })()
        + '</div></div>';

      var ui = settings.ui || {};
      var uiHtml = '<div class="card" style="margin-top:1.5rem">'
        + '<div class="card-header"><h2>\uD83C\uDFA8 UI Customization</h2><span class="meta">Configure colors, logo, and site name for the Auth UI</span></div>'
        + '<div style="padding:1rem 1.5rem;display:flex;gap:2rem;flex-wrap:wrap">'
        + '<div style="flex:1;min-width:280px;max-width:420px">'
        + '<div class="form-row" style="margin-bottom:1rem"><div style="flex:1"><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Site Name</label>'
        + '<input type="text" id="ui-site-name" value="' + esc(ui.siteName || '') + '" placeholder="Awesome Node Auth" oninput="uiPreview()"></div></div>'
        + '<div class="form-row" style="margin-bottom:1rem;gap:1.5rem">'
        + '<div><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Primary Color <small style="color:#9ca3af">(buttons, links, headings)</small></label>'
        + '<input type="color" id="ui-primary-color" value="' + esc(ui.primaryColor || '#4a90d9') + '" style="cursor:pointer;width:60px;height:36px;padding:2px;border:1px solid #d1d5db;border-radius:4px" oninput="uiPreview()"></div>'
        + '<div><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Secondary Color <small style="color:#9ca3af">(social buttons, borders)</small></label>'
        + '<input type="color" id="ui-secondary-color" value="' + esc(ui.secondaryColor || '#6c757d') + '" style="cursor:pointer;width:60px;height:36px;padding:2px;border:1px solid #d1d5db;border-radius:4px" oninput="uiPreview()"></div>'
        + '</div>'
        + '<div class="form-row" style="margin-bottom:1rem"><div style="flex:1"><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Logo URL <small style="color:#9ca3af">(or upload below)</small></label>'
        + '<input type="text" id="ui-logo-url" value="' + esc(ui.logoUrl || '') + '" placeholder="https://example.com/logo.png" oninput="uiPreview()"></div></div>'
        + (FEAT_UPLOAD ? '<div class="form-row" style="margin-bottom:1rem"><div style="flex:1"><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Upload Logo <small style="color:#9ca3af">(.png, .jpg, .svg \u2014 saved to uploadDir)</small></label><div style="display:flex;gap:.5rem"><input type="file" id="ui-logo-file" accept="image/*" style="flex:1;font-size:.8125rem" onchange="uploadAsset(this,\'logo\')"><button class="btn btn-sm" onclick="listUploads()">Manage files</button></div></div></div>' : '')
        + '<div style="border-top:1px solid #f3f4f6;margin:1rem 0;padding-top:1rem">'
        + '<div style="font-size:.75rem;font-weight:600;color:#374151;margin-bottom:.75rem;text-transform:uppercase;letter-spacing:.05em">Page Background</div>'
        + '<div class="form-row" style="margin-bottom:1rem;gap:1.5rem"><div style="flex:1"><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Background Color <small style="color:#9ca3af">(entire page)</small></label>'
        + '<div style="display:flex;align-items:center;gap:.5rem"><input type="color" id="ui-bg-color" value="' + esc(ui.bgColor || '#f8fafc') + '" style="cursor:pointer;width:60px;height:36px;padding:2px;border:1px solid #d1d5db;border-radius:4px" oninput="syncBgColor(this)">'
        + '<input type="text" id="ui-bg-color-text" value="' + esc(ui.bgColor || '') + '" placeholder="#f8fafc (default)" style="flex:1" oninput="syncBgColorText(this)"></div></div></div>'
        + '<div class="form-row" style="margin-bottom:1rem"><div style="flex:1"><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Background Image URL <small style="color:#9ca3af">(cover, centered, fixed)</small></label>'
        + '<input type="text" id="ui-bg-image" value="' + esc(ui.bgImage || '') + '" placeholder="https://example.com/bg.jpg" oninput="uiPreview()"></div></div>'
        + (FEAT_UPLOAD ? '<div class="form-row" style="margin-bottom:1rem"><div style="flex:1"><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Upload Background Image <small style="color:#9ca3af">(.jpg, .png, .webp)</small></label><input type="file" id="ui-bg-file" accept="image/*" style="font-size:.8125rem;width:100%" onchange="uploadAsset(this,\'bg-image\')"></div></div>' : '')
        + '</div>'
        + '<div style="border-top:1px solid #f3f4f6;margin:1rem 0;padding-top:1rem">'
        + '<div style="font-size:.75rem;font-weight:600;color:#374151;margin-bottom:.75rem;text-transform:uppercase;letter-spacing:.05em">Card / Form Background</div>'
        + '<div class="form-row" style="margin-bottom:1rem;gap:1.5rem"><div style="flex:1"><label style="display:block;font-size:.8125rem;color:#374151;margin-bottom:.25rem">Card Background Color <small style="color:#9ca3af">(form card, default #ffffff)</small></label>'
        + '<div style="display:flex;align-items:center;gap:.5rem"><input type="color" id="ui-card-bg" value="' + esc(ui.cardBg || '#ffffff') + '" style="cursor:pointer;width:60px;height:36px;padding:2px;border:1px solid #d1d5db;border-radius:4px" oninput="syncCardBg(this)">'
        + '<input type="text" id="ui-card-bg-text" value="' + esc(ui.cardBg || '') + '" placeholder="#ffffff (default)" style="flex:1" oninput="syncCardBgText(this)"></div></div></div>'
        + '</div>'
        + '<button class="btn btn-primary" onclick="saveUiSettings()">Save UI Settings</button>'
        + '</div>'
        + '<div id="ui-preview-wrap" style="flex:0 0 220px;min-width:180px">'
        + '<div style="font-size:.75rem;font-weight:600;color:#374151;margin-bottom:.5rem;text-transform:uppercase;letter-spacing:.05em">Live Preview</div>'
        + '<div id="ui-preview" style="border-radius:8px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,.12);width:220px;height:320px;display:flex;flex-direction:column;align-items:center;justify-content:center;background:#f8fafc;padding:16px;font-family:system-ui,-apple-system,sans-serif;transition:background .2s">'
        + '<div id="prv-card" style="width:100%;background:#fff;border-radius:8px;padding:14px;display:flex;flex-direction:column;align-items:center;box-shadow:0 1px 6px rgba(0,0,0,.08);transition:background .2s">'
        + '<div id="prv-logo" style="display:none;margin-bottom:8px"><img id="prv-logo-img" src="" style="height:28px;width:auto;display:block"></div>'
        + '<div id="prv-title" style="font-size:13px;font-weight:700;color:#4a90d9;text-align:center;margin-bottom:2px">Awesome Node Auth</div>'
        + '<div style="font-size:10px;color:#64748b;text-align:center;margin-bottom:10px">Login</div>'
        + '<div style="width:100%;background:#f9fafb;border:1px solid #e2e8f0;border-radius:4px;padding:6px 8px;font-size:10px;color:#374151;margin-bottom:5px">Email</div>'
        + '<div style="width:100%;background:#f9fafb;border:1px solid #e2e8f0;border-radius:4px;padding:6px 8px;font-size:10px;color:#374151;margin-bottom:8px">Password</div>'
        + '<div id="prv-btn" style="width:100%;background:#4a90d9;color:#fff;border-radius:4px;padding:6px;font-size:10px;font-weight:700;text-align:center;cursor:default;transition:background .2s">Login</div>'
        + '<div style="display:flex;align-items:center;gap:6px;margin:8px 0 6px;width:100%"><div style="flex:1;height:1px;background:#e2e8f0"></div><div style="font-size:9px;color:#9ca3af">or</div><div style="flex:1;height:1px;background:#e2e8f0"></div></div>'
        + '<div id="prv-social" style="width:100%;border:1px solid #6c757d;border-radius:4px;padding:5px;font-size:9px;color:#6c757d;text-align:center;transition:border-color .2s,color .2s">Continue with Google</div>'
        + '<div id="prv-link" style="margin-top:7px;font-size:9px;color:#4a90d9;text-align:center">Forgot password?</div>'
        + '</div>'
        + '</div>'
        + '<div style="font-size:.6875rem;color:#9ca3af;margin-top:.375rem">Changes update live; save to persist.</div>'
        + '<div id="ui-files-panel" style="display:none;margin-top:.75rem;background:#f9fafb;border:1px solid #e5e7eb;border-radius:6px;padding:.75rem;max-height:200px;overflow-y:auto">'
        + '<div style="font-size:.75rem;font-weight:600;color:#374151;margin-bottom:.5rem">Uploaded Files</div>'
        + '<div id="ui-files-list" style="font-size:.8125rem"></div>'
        + '</div>'
        + '</div>'
        + '</div></div>';

      main.innerHTML = '<div class="card">'
        + '<div class="card-header"><h2>\u2699\uFE0F Control Panel</h2><span class="meta">Global authentication settings</span></div>'
        + '<div style="padding:1rem 1.5rem;max-width:640px">'
        + evModeHtml
        + toggleHtml('require2FA', 'Mandatory Two-Factor Authentication', 'All users must have 2FA enabled. Users without 2FA configured will be blocked at login.', !!settings.require2FA)
        + '</div></div>'
        + uiHtml
        + actionsHtml;
      setTimeout(uiPreview, 0);
    } catch (e) {
      main.innerHTML = '<div class="alert alert-error">' + esc(e.message) + '</div>';
    }
  }

  async function toggleWebhookAction(id, enabled) {
    try {
      var settings = await api('GET', '/api/settings');
      var current = settings.enabledWebhookActions || [];
      var next = enabled ? [...new Set([...current, id])] : current.filter(function (x) { return x !== id; });
      await api('PUT', '/api/settings', { enabledWebhookActions: next });
      flash('Webhook action ' + (enabled ? 'enabled' : 'disabled'));
      renderControl();
    } catch (e) {
      flash(e.message, 'error');
    }
  }

  async function updateEmailVerificationMode(mode) {
    try {
      await api('PUT', '/api/settings', { emailVerificationMode: mode });
      flash('Email verification policy updated');
      var graceRow = document.getElementById('ev-grace-row');
      if (graceRow) graceRow.style.display = mode === 'lazy' ? 'flex' : 'none';
    } catch (e) {
      flash(e.message, 'error');
    }
  }

  async function saveGracePeriod() {
    var inp = document.getElementById('ev-grace-days');
    var days = parseInt(inp ? inp.value : '7', 10);
    if (isNaN(days) || days < 1) { flash('Enter a valid number of days', 'error'); return; }
    try {
      await api('PUT', '/api/settings', { lazyEmailVerificationGracePeriodDays: days });
      flash('Grace period saved');
    } catch (e) {
      flash(e.message, 'error');
    }
  }

  async function updateSetting(key, value) {
    try {
      await api('PUT', '/api/settings', { [key]: value });
      flash('Setting updated');
      if (key === 'require2FA' && FEAT_2FA_POLICY) {
        await api('POST', '/api/2fa-policy', { required: value }).catch(function () { });
      }
    } catch (e) {
      flash(e.message, 'error');
      renderControl();
    }
  }

  async function saveUiSettings() {
    var primaryColor = document.getElementById('ui-primary-color').value;
    var secondaryColor = document.getElementById('ui-secondary-color').value;
    var logoUrl = document.getElementById('ui-logo-url').value.trim();
    var siteName = document.getElementById('ui-site-name').value.trim();
    var bgColorText = document.getElementById('ui-bg-color-text').value.trim();
    var bgColor = bgColorText || document.getElementById('ui-bg-color').value;
    var bgImage = document.getElementById('ui-bg-image').value.trim();
    var cardBgText = document.getElementById('ui-card-bg-text').value.trim();
    var cardBg = cardBgText || document.getElementById('ui-card-bg').value;
    var ui = { primaryColor: primaryColor, secondaryColor: secondaryColor, logoUrl: logoUrl, siteName: siteName, bgColor: bgColor, bgImage: bgImage, cardBg: cardBg };
    try {
      await api('PATCH', '/api/settings/ui', ui);
      flash('UI settings saved');
    } catch (e) { flash(e.message, 'error'); }
  }

  async function uploadAsset(input, type) {
    if (!input.files || !input.files[0]) return;
    var file = input.files[0];
    var formData = new FormData();
    formData.append('file', file);
    try {
      var res = await fetch(BASE + '/api/upload/' + type, {
        method: 'POST',
        headers: { 'Authorization': 'Bearer ' + _token },
        body: formData
      });
      if (!res.ok) {
        var e = await res.json().catch(function () { return { error: res.statusText }; });
        flash(e.error || res.statusText, 'error');
        return;
      }
      var data = await res.json();
      var fileUrl = data.url || data.filename;
      if (type === 'logo') {
        var urlInput = document.getElementById('ui-logo-url');
        if (urlInput) { urlInput.value = fileUrl; uiPreview(); }
      } else if (type === 'bg-image') {
        var urlInput2 = document.getElementById('ui-bg-image');
        if (urlInput2) { urlInput2.value = fileUrl; uiPreview(); }
      }
      flash('File uploaded: ' + data.filename);
      input.value = '';
    } catch (e) { flash(e.message, 'error'); }
  }

  async function listUploads() {
    var panel = document.getElementById('ui-files-panel');
    var list = document.getElementById('ui-files-list');
    if (!panel || !list) return;
    panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
    if (panel.style.display === 'none') return;
    list.textContent = 'Loading...';
    try {
      var data = await api('GET', '/api/upload/files');
      if (!data.files || data.files.length === 0) { list.textContent = 'No uploaded files.'; return; }
      list.innerHTML = data.files.map(function (f) {
        return '<div style="display:flex;align-items:center;gap:.5rem;margin-bottom:.375rem">'
          + '<span style="flex:1;word-break:break-all;font-size:.75rem">' + esc(f.name) + '</span>'
          + '<button class="btn btn-sm btn-danger" style="padding:2px 8px;font-size:.75rem" onclick="deleteUpload(' + esc(JSON.stringify(f.name)) + ')">Delete</button>'
          + '</div>';
      }).join('');
    } catch (e) { list.textContent = 'Error: ' + e.message; }
  }

  async function deleteUpload(filename) {
    try {
      await api('DELETE', '/api/upload/' + encodeURIComponent(filename));
      flash('File deleted');
      listUploads();
      ['ui-logo-url', 'ui-bg-image'].forEach(function (id) {
        var inp = document.getElementById(id);
        if (inp && inp.value.includes(filename)) { inp.value = ''; uiPreview(); }
      });
    } catch (e) { flash(e.message, 'error'); }
  }

  function syncBgColor(picker) {
    var txt = document.getElementById('ui-bg-color-text');
    if (txt) txt.value = picker.value;
    uiPreview();
  }

  function syncBgColorText(input) {
    var picker = document.getElementById('ui-bg-color');
    if (picker && input.value) picker.value = input.value;
    uiPreview();
  }

  function syncCardBg(picker) {
    var txt = document.getElementById('ui-card-bg-text');
    if (txt) txt.value = picker.value;
    uiPreview();
  }

  function syncCardBgText(input) {
    var picker = document.getElementById('ui-card-bg');
    if (picker && input.value) picker.value = input.value;
    uiPreview();
  }

  function uiPreview() {
    var primary = document.getElementById('ui-primary-color').value || '#4a90d9';
    var secondary = document.getElementById('ui-secondary-color').value || '#6c757d';
    var siteName = document.getElementById('ui-site-name').value.trim() || 'Awesome Node Auth';
    var logoUrl = document.getElementById('ui-logo-url').value.trim();
    var bgColorText = document.getElementById('ui-bg-color-text').value.trim();
    var bgColor = bgColorText || document.getElementById('ui-bg-color').value || '#f8fafc';
    var bgImage = document.getElementById('ui-bg-image').value.trim();
    var cardBgText = document.getElementById('ui-card-bg-text').value.trim();
    var cardBg = cardBgText || document.getElementById('ui-card-bg').value || '#ffffff';
    var prv = document.getElementById('ui-preview');
    if (!prv) return;
    prv.style.background = bgColor;
    if (bgImage) {
      var safeUrl = bgImage.replace(/['"\\]/g, function (m) { return encodeURIComponent(m); });
      prv.style.backgroundImage = 'url("' + safeUrl + '")';
      prv.style.backgroundSize = 'cover';
      prv.style.backgroundPosition = 'center';
    } else {
      prv.style.backgroundImage = 'none';
    }
    var card = document.getElementById('prv-card');
    if (card) card.style.background = cardBg;
    var title = document.getElementById('prv-title');
    if (title) { title.textContent = siteName; title.style.color = primary; }
    var btn = document.getElementById('prv-btn');
    if (btn) btn.style.background = primary;
    var link = document.getElementById('prv-link');
    if (link) link.style.color = primary;
    var social = document.getElementById('prv-social');
    if (social) { social.style.borderColor = secondary; social.style.color = secondary; }
    var logoWrap = document.getElementById('prv-logo');
    var logoImg = document.getElementById('prv-logo-img');
    if (logoWrap && logoImg) {
      if (logoUrl) { logoImg.src = logoUrl; logoWrap.style.display = 'block'; }
      else { logoWrap.style.display = 'none'; }
    }
  }

  // ---- API Keys ------------------------------------------------------------
  async function renderApiKeys() {
    var main = document.getElementById('main');
    main.innerHTML = '<div class="card"><div class="card-header"><h2>\uD83D\uDD11 API Keys</h2><span class="meta"><span class="spinner"></span></span></div></div>';
    try {
      var filterParam = _state.apiKeys.filter ? '&filter=' + encodeURIComponent(_state.apiKeys.filter) : '';
      var res = await api('GET', '/api/api-keys?limit=' + PAGE_SIZE + '&offset=' + (_state.apiKeys.page * PAGE_SIZE) + filterParam);
      var keys = res.keys;
      var total = res.total;
      var hasMore = (_state.apiKeys.page + 1) * PAGE_SIZE < total;
      var rawKeyBanner = '';
      if (_state.apiKeys.newRaw) {
        rawKeyBanner = '<div class="alert alert-success" style="font-family:monospace;word-break:break-all;display:flex;justify-content:space-between;align-items:flex-start;gap:1rem">'
          + '<span>\u26A0\uFE0F Copy this key now \u2014 it will not be shown again:<br><strong>' + esc(_state.apiKeys.newRaw) + '</strong></span>'
          + '<button class="btn btn-sm" style="flex-shrink:0;background:#f3f4f6;border:1px solid #e5e7eb" onclick="_state.apiKeys.newRaw=null;renderApiKeys()">Dismiss</button>'
          + '</div>';
      }
      var rows = '';
      if (keys.length === 0) {
        rows = '<tr><td colspan="7"><div class="empty">No API keys found</div></td></tr>';
      } else {
        for (var i = 0; i < keys.length; i++) {
          var k = keys[i];
          rows += '<tr>'
            + '<td style="font-family:monospace;font-size:.75rem">' + esc(k.keyPrefix) + '\u2026</td>'
            + '<td><strong>' + esc(k.name) + '</strong></td>'
            + '<td>' + (k.serviceId ? badge(k.serviceId, 'blue') : '<span style="color:#9ca3af">\u2014</span>') + '</td>'
            + '<td>' + ((k.scopes || []).length === 0 ? '<span style="color:#9ca3af">none</span>' : (k.scopes || []).map(function (s) { return badge(s, 'indigo'); }).join(' ')) + '</td>'
            + '<td>' + (k.isActive ? badge('active', 'green') : badge('revoked', 'red')) + '</td>'
            + '<td>' + ts(k.expiresAt) + '</td>'
            + '<td style="display:flex;gap:.25rem;flex-wrap:wrap">'
            + (k.isActive ? '<button class="btn btn-sm" style="background:#fef3c7;color:#92400e" onclick="revokeApiKey(' + esc(JSON.stringify(k.id)) + ')">Revoke</button>' : '')
            + '<button class="btn btn-danger" onclick="deleteApiKey(' + esc(JSON.stringify(k.id)) + ')">Delete</button>'
            + '</td>'
            + '</tr>';
        }
      }
      var createForm = '<div style="padding:1rem 1.5rem;border-top:1px solid #f3f4f6">'
        + '<strong style="font-size:.8125rem;display:block;margin-bottom:.625rem">Create new API key</strong>'
        + '<div class="form-row" style="flex-wrap:wrap;gap:.5rem">'
        + '<input type="text" id="ak-name" placeholder="Name (e.g. stripe-webhook)" style="width:200px">'
        + '<input type="text" id="ak-service" placeholder="Service ID (optional)" style="width:160px">'
        + '<input type="text" id="ak-scopes" placeholder="Scopes (comma-separated)" style="width:220px">'
        + '<input type="text" id="ak-ips" placeholder="Allowed IPs / CIDRs (optional)" style="width:220px">'
        + '<input type="date" id="ak-expires" style="width:150px" title="Expiry date (optional)">'
        + '<button class="btn btn-primary btn-sm" onclick="createApiKey()">Create Key</button>'
        + '</div></div>';
      main.innerHTML = rawKeyBanner
        + '<div class="card"><div class="card-header"><h2>\uD83D\uDD11 API Keys</h2><span class="meta">' + total + ' total</span></div>'
        + '<div class="filter-bar"><input type="text" placeholder="Filter by name or service\u2026" value="' + esc(_state.apiKeys.filter) + '" oninput="_state.apiKeys.filter=this.value;_state.apiKeys.page=0;renderApiKeys()" style="max-width:300px"></div>'
        + '<div class="table-wrap"><table><thead><tr><th>Prefix</th><th>Name</th><th>Service ID</th><th>Scopes</th><th>Status</th><th>Expires</th><th></th></tr></thead><tbody>' + rows + '</tbody></table></div>'
        + pagerHtml(_state.apiKeys.page, hasMore, '_state.apiKeys.page--;renderApiKeys()', '_state.apiKeys.page++;renderApiKeys()')
        + createForm + '</div>';
    } catch (e) {
      main.innerHTML = '<div class="alert alert-error">' + esc(e.message) + '</div>';
    }
  }

  async function revokeApiKey(id) {
    if (!confirm('Revoke this API key? It will no longer be usable.')) return;
    try {
      await api('DELETE', '/api/api-keys/' + encodeURIComponent(id) + '/revoke');
      flash('API key revoked');
      renderApiKeys();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function deleteApiKey(id) {
    if (!confirm('Permanently delete this API key record?')) return;
    try {
      await api('DELETE', '/api/api-keys/' + encodeURIComponent(id));
      flash('API key deleted');
      renderApiKeys();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function createApiKey() {
    var name = document.getElementById('ak-name').value.trim();
    if (!name) { flash('Name is required', 'error'); return; }
    var serviceId = document.getElementById('ak-service').value.trim() || undefined;
    var scopes = document.getElementById('ak-scopes').value.split(',').map(function (s) { return s.trim(); }).filter(Boolean);
    var ips = document.getElementById('ak-ips').value.split(',').map(function (s) { return s.trim(); }).filter(Boolean);
    var expInput = document.getElementById('ak-expires').value;
    var expiresAt = expInput ? new Date(expInput).toISOString() : undefined;
    try {
      var res = await api('POST', '/api/api-keys', { name: name, serviceId: serviceId, scopes: scopes.length ? scopes : undefined, allowedIps: ips.length ? ips : undefined, expiresAt: expiresAt });
      _state.apiKeys.newRaw = res.rawKey;
      flash('API key created \u2014 copy it now!');
      renderApiKeys();
    } catch (e) { flash(e.message, 'error'); }
  }

  // ---- Webhooks ------------------------------------------------------------
  async function renderWebhooks() {
    var main = document.getElementById('main');
    main.innerHTML = '<div class="card"><div class="card-header"><h2>\uD83D\uDD17 Webhooks</h2><span class="meta"><span class="spinner"></span></span></div></div>';

    function fmtEndpoint(w) {
      if (w.provider) return badge('inbound', 'purple') + ' <code style="font-size:.75rem">' + esc(w.provider) + '</code>';
      var url = w.url || '';
      return esc(url.length > 40 ? url.slice(0, 40) + '\u2026' : url);
    }

    try {
      var results = await Promise.all([
        api('GET', '/api/webhooks?limit=' + PAGE_SIZE + '&offset=' + (_state.webhooks.page * PAGE_SIZE)),
        api('GET', '/api/settings').catch(function () { return { enabledWebhookActions: [] }; }),
        api('GET', '/api/actions').catch(function () { return { actions: [] }; })
      ]);
      var webhooks = results[0].webhooks;
      var total = results[0].total;
      var hasMore = (_state.webhooks.page + 1) * PAGE_SIZE < total;
      var enabledActions = results[1].enabledWebhookActions || [];
      var allActions = results[2].actions || [];

      var rows = '';
      if (webhooks.length === 0) {
        rows = '<tr><td colspan="7"><div class="empty">No webhooks registered</div></td></tr>';
      } else {
        for (var i = 0; i < webhooks.length; i++) {
          var w = webhooks[i];
          var scriptIcon = w.jsScript ? badge('\u2699 script', 'purple') : '';
          var actionsCount = (w.allowedActions || []).length;
          var scriptCell = scriptIcon + (actionsCount > 0 ? badge(actionsCount + ' actions', 'orange') : '')
            + (!w.jsScript && actionsCount === 0 ? '<span style="color:#9ca3af">\u2014</span>' : '');
          rows += '<tr>'
            + '<td style="font-family:monospace;font-size:.75rem;max-width:220px" title="' + esc(w.url || '') + '">' + fmtEndpoint(w) + '</td>'
            + '<td>' + (w.events || []).map(function (e) { return badge(e, 'blue'); }).join(' ') + '</td>'
            + '<td>' + (w.tenantId ? badge(w.tenantId, 'indigo') : '<span style="color:#9ca3af">global</span>') + '</td>'
            + '<td>' + (w.isActive !== false ? badge('active', 'green') : badge('inactive', 'gray')) + '</td>'
            + '<td>' + scriptCell + '</td>'
            + '<td>' + (w.secret ? badge('\u2713 signed', 'green') : '<span style="color:#9ca3af">unsigned</span>') + '</td>'
            + '<td style="display:flex;gap:.25rem">'
            + '<button class="btn btn-sm" onclick="openWebhookDrawer(' + esc(JSON.stringify(w.id)) + ')">Edit</button>'
            + '<button class="btn btn-sm" style="background:' + (w.isActive !== false ? '#fee2e2' : '#dcfce7') + ';color:' + (w.isActive !== false ? '#991b1b' : '#166534') + '" onclick="toggleWebhook(' + esc(JSON.stringify(w.id)) + ',' + !(w.isActive !== false) + ')">' + (w.isActive !== false ? 'Disable' : 'Enable') + '</button>'
            + '<button class="btn btn-danger" onclick="deleteWebhook(' + esc(JSON.stringify(w.id)) + ')">Delete</button>'
            + '</td>'
            + '</tr>';
        }
      }

      var actionCheckboxes = enabledActions.length === 0
        ? '<p style="font-size:.8125rem;color:#9ca3af">No actions are globally enabled. Enable them in the Control tab first.</p>'
        : enabledActions.map(function (id) {
          var meta = allActions.find(function (a) { return a.id === id; });
          var label = meta ? esc(meta.label) : esc(id);
          return '<label style="display:flex;align-items:center;gap:.5rem;font-size:.8125rem;padding:.25rem 0;cursor:pointer">'
            + '<input type="checkbox" class="wh-action-cb" value="' + esc(id) + '">'
            + label + ' <code style="font-size:.7rem;color:#6b7280">(' + esc(id) + ')</code>'
            + '</label>';
        }).join('');

      var drawer = '<div id="wh-drawer" style="display:none;position:fixed;right:0;top:0;height:100%;width:480px;background:white;box-shadow:-4px 0 24px rgba(0,0,0,.15);z-index:100;overflow-y:auto;padding:1.5rem">'
        + '<div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1rem">'
        + '<h2 style="font-size:1rem;font-weight:700" id="wh-drawer-title">Webhook</h2>'
        + '<button onclick="closeWebhookDrawer()" style="background:none;border:none;font-size:1.25rem;cursor:pointer">\u2715</button>'
        + '</div>'
        + '<input type="hidden" id="wh-edit-id">'
        + '<div style="display:flex;flex-direction:column;gap:.75rem">'
        + '<label style="font-size:.8125rem;font-weight:500">Type</label>'
        + '<div style="display:flex;gap:1rem">'
        + '<label style="display:flex;align-items:center;gap:.35rem;font-size:.875rem;cursor:pointer"><input type="radio" name="wh-type" value="outgoing" checked onchange="toggleWebhookType(this.value)"> Outgoing</label>'
        + '<label style="display:flex;align-items:center;gap:.35rem;font-size:.875rem;cursor:pointer"><input type="radio" name="wh-type" value="inbound" onchange="toggleWebhookType(this.value)"> Inbound (dynamic)</label>'
        + '</div>'
        + '<div id="wh-url-row"><label style="font-size:.8125rem;font-weight:500">Endpoint URL</label><input type="text" id="wh-url" placeholder="https://example.com/webhook" style="width:100%;margin-top:.25rem"></div>'
        + '<div id="wh-provider-row" style="display:none"><label style="font-size:.8125rem;font-weight:500">Provider name</label><input type="text" id="wh-provider" placeholder="stripe" style="width:100%;margin-top:.25rem"></div>'
        + '<div><label style="font-size:.8125rem;font-weight:500">Events</label><input type="text" id="wh-events" placeholder="* or identity.auth.login.success,\u2026" style="width:100%;margin-top:.25rem"></div>'
        + '<div><label style="font-size:.8125rem;font-weight:500">HMAC secret <span style="font-weight:400;color:#9ca3af">(optional)</span></label><input type="text" id="wh-secret" placeholder="shared-secret" style="width:100%;margin-top:.25rem"></div>'
        + '<div><label style="font-size:.8125rem;font-weight:500">Tenant ID <span style="font-weight:400;color:#9ca3af">(optional)</span></label><input type="text" id="wh-tenant" placeholder="tenant-id" style="width:100%;margin-top:.25rem"></div>'
        + '<div id="wh-actions-row" style="display:none"><label style="font-size:.8125rem;font-weight:500">Allowed actions <span style="font-weight:400;color:#9ca3af">(from globally enabled)</span></label><div style="margin-top:.25rem;padding:.75rem;border:1px solid #e5e7eb;border-radius:8px;max-height:160px;overflow-y:auto">' + actionCheckboxes + '</div></div>'
        + '<div id="wh-script-row" style="display:none">'
        + '<label style="font-size:.8125rem;font-weight:500">JavaScript (vm sandbox)</label>'
        + '<textarea id="wh-script" rows="10" style="width:100%;margin-top:.25rem;font-family:monospace;font-size:.8125rem;padding:.5rem;border:1px solid #e5e7eb;border-radius:8px;resize:vertical" placeholder="// body: inbound request payload\n// actions: enabled action functions\n// set result = { event, data } to emit an event\n\nif (body.type === \'invoice.payment_failed\') {\n  result = { event: \'identity.tenant.user.removed\', data: body.data };\n}"></textarea>'
        + '</div>'
        + '</div>'
        + '<div style="display:flex;gap:.75rem;margin-top:1.5rem">'
        + '<button class="btn btn-primary" onclick="saveWebhook()">Save</button>'
        + '<button class="btn" onclick="closeWebhookDrawer()">Cancel</button>'
        + '</div></div>';

      main.innerHTML = drawer
        + '<div class="card"><div class="card-header"><h2>\uD83D\uDD17 Webhooks</h2><span class="meta">' + total + ' total</span></div>'
        + '<div class="table-wrap"><table><thead><tr><th>Endpoint / Provider</th><th>Events</th><th>Scope</th><th>Status</th><th>Script</th><th>Signing</th><th></th></tr></thead><tbody>' + rows + '</tbody></table></div>'
        + pagerHtml(_state.webhooks.page, hasMore, '_state.webhooks.page--;renderWebhooks()', '_state.webhooks.page++;renderWebhooks()')
        + '<div style="padding:1rem 1.5rem;border-top:1px solid #f3f4f6"><button class="btn btn-primary btn-sm" onclick="openWebhookDrawer(null)">+ Register webhook</button></div></div>';
    } catch (e) {
      main.innerHTML = '<div class="alert alert-error">' + esc(e.message) + '</div>';
    }
  }

  function toggleWebhookType(type) {
    var isInbound = type === 'inbound';
    document.getElementById('wh-url-row').style.display = isInbound ? 'none' : 'block';
    document.getElementById('wh-provider-row').style.display = isInbound ? 'block' : 'none';
    document.getElementById('wh-actions-row').style.display = isInbound ? 'block' : 'none';
    document.getElementById('wh-script-row').style.display = isInbound ? 'block' : 'none';
  }

  function openWebhookDrawer(id) {
    document.getElementById('wh-edit-id').value = id || '';
    document.getElementById('wh-url').value = '';
    document.getElementById('wh-provider').value = '';
    document.getElementById('wh-events').value = '*';
    document.getElementById('wh-secret').value = '';
    document.getElementById('wh-tenant').value = '';
    document.getElementById('wh-script').value = '';
    document.querySelectorAll('.wh-action-cb').forEach(function (cb) { cb.checked = false; });
    document.querySelectorAll('input[name="wh-type"]').forEach(function (r) { r.checked = r.value === 'outgoing'; });
    toggleWebhookType('outgoing');
    document.getElementById('wh-drawer-title').textContent = id ? 'Edit webhook' : 'Register webhook';
    document.getElementById('wh-drawer').style.display = 'block';
  }

  function closeWebhookDrawer() {
    document.getElementById('wh-drawer').style.display = 'none';
  }

  async function saveWebhook() {
    var editId = document.getElementById('wh-edit-id').value;
    var isInbound = document.querySelector('input[name="wh-type"]:checked').value === 'inbound';
    var eventsRaw = document.getElementById('wh-events').value.trim();
    var events = eventsRaw ? eventsRaw.split(',').map(function (s) { return s.trim(); }).filter(Boolean) : ['*'];
    var secret = document.getElementById('wh-secret').value.trim() || undefined;
    var tenantId = document.getElementById('wh-tenant').value.trim() || undefined;
    var body = { events: events, secret: secret, tenantId: tenantId, isActive: true };
    if (isInbound) {
      body.provider = document.getElementById('wh-provider').value.trim() || undefined;
      body.jsScript = document.getElementById('wh-script').value.trim() || undefined;
      body.allowedActions = [...document.querySelectorAll('.wh-action-cb:checked')].map(function (cb) { return cb.value; });
      body.url = '';
    } else {
      body.url = document.getElementById('wh-url').value.trim();
      if (!body.url) { flash('URL is required', 'error'); return; }
    }
    try {
      if (editId) {
        await api('PATCH', '/api/webhooks/' + encodeURIComponent(editId), body);
        flash('Webhook updated');
      } else {
        await api('POST', '/api/webhooks', body);
        flash('Webhook registered');
      }
      closeWebhookDrawer();
      renderWebhooks();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function createWebhook() { await saveWebhook(); }

  async function toggleWebhook(id, active) {
    try {
      await api('PATCH', '/api/webhooks/' + encodeURIComponent(id), { isActive: active });
      flash('Webhook ' + (active ? 'enabled' : 'disabled'));
      renderWebhooks();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function deleteWebhook(id) {
    if (!confirm('Delete this webhook registration?')) return;
    try {
      await api('DELETE', '/api/webhooks/' + encodeURIComponent(id));
      flash('Webhook deleted');
      renderWebhooks();
    } catch (e) { flash(e.message, 'error'); }
  }

  // ---- Expose functions called from inline HTML event handlers -------------
  window.doLogin = doLogin;
  window.doLogout = doLogout;
  window.showTab = showTab;
  window.renderUsers = renderUsers;
  window.toggleSelectUser = toggleSelectUser;
  window.toggleSelectAll = toggleSelectAll;
  window.clearSelection = clearSelection;
  window.deleteSelected = deleteSelected;
  window.toggleUserPanel = toggleUserPanel;
  window.addUserTenant = addUserTenant;
  window.removeUserTenant = removeUserTenant;
  window.addUserRole = addUserRole;
  window.removeUserRole = removeUserRole;
  window.saveUserMeta = saveUserMeta;
  // ---- Email & UI Templates ───────────────────────────────────────────────

  // Source-of-truth catalogue: IDs MUST match MailerService.render() call sites
  var MAIL_TEMPLATES = [
    {
      id: 'welcome',
      label: 'Welcome',
      description: 'Sent after successful registration.',
      variables: [
        { name: 'loginUrl', description: 'URL to the login page' },
        { name: 'tempPassword', description: 'Temporary password (only if admin-created)' },
      ],
      translationKeys: ['subject', 'title', 'body', 'cta'],
    },
    {
      id: 'magic-link',
      label: 'Magic Link',
      description: 'Passwordless sign-in link.',
      variables: [
        { name: 'link', description: 'One-time sign-in URL' },
        { name: 'token', description: 'Raw token (rarely needed in template)' },
      ],
      translationKeys: ['subject', 'title', 'body', 'cta', 'disclaimer'],
    },
    {
      id: 'password-reset',
      label: 'Password Reset',
      description: 'Sent when the user requests a password reset.',
      variables: [
        { name: 'link', description: 'Password-reset URL' },
        { name: 'token', description: 'Raw token' },
      ],
      translationKeys: ['subject', 'title', 'body', 'cta', 'disclaimer'],
    },
    {
      id: 'verify-email',
      label: 'Verify Email',
      description: 'Sent to verify a new email address.',
      variables: [
        { name: 'link', description: 'Email-verification URL' },
        { name: 'token', description: 'Raw token' },
      ],
      translationKeys: ['subject', 'title', 'body', 'cta', 'disclaimer'],
    },
    {
      id: 'email-changed',
      label: 'Email Changed',
      description: 'Sent to the old address when the email is updated.',
      variables: [
        { name: 'newEmail', description: 'The new email address' },
      ],
      translationKeys: ['subject', 'title', 'body', 'support'],
    },
    {
      id: 'invitation',
      label: 'Invitation',
      description: 'Sent when an admin invites a new user.',
      variables: [
        { name: 'link', description: 'Accept-invitation URL' },
      ],
      translationKeys: ['subject', 'title', 'body', 'cta'],
    },
  ];

  // UI pages catalogue derived from actual *.html files in src/ui/assets/
  var UI_PAGES = [
    { page: 'login',            label: 'Login',              keys: ['site_name','login_title','email_label','email_placeholder','password_label','password_placeholder','forgot_password_link','login_button','no_account_text','signup_link','social_divider'] },
    { page: 'register',         label: 'Register',           keys: ['site_name','register_title','email_label','email_placeholder'] },
    { page: 'forgot-password',  label: 'Forgot Password',    keys: ['site_name','forgot_password_title','forgot_password_instruction','forgot_password_success','email_label','email_placeholder','send_reset_link_button','remember_password_text','login_link','return_to_login_link'] },
    { page: 'reset-password',   label: 'Reset Password',     keys: ['site_name','reset_password_title','reset_password_success','new_password_label','new_password_placeholder','confirm_password_label','confirm_password_placeholder','save_password_button','proceed_to_login_link'] },
    { page: 'verify-email',     label: 'Verify Email',       keys: ['site_name','verify_email_title','verify_email_loading','go_to_login_link'] },
    { page: '2fa',              label: 'Two-Factor Auth',    keys: ['site_name','two_fa_title','two_fa_setup_instruction','two_fa_code_label','two_fa_code_placeholder','verify_code_button'] },
    { page: 'magic-link',       label: 'Magic Link landing', keys: ['site_name','magic_link_title','magic_link_instruction','email_label','email_placeholder','send_magic_link_button'] },
    { page: 'link-verify',      label: 'Link Verify landing',keys: ['site_name','account_linking_title','account_linking_loading','go_to_login_link'] },
    { page: 'account-conflict', label: 'Account Conflict',   keys: ['site_name','account_linking_title','account_linking_instruction','send_verification_email_button'] },
  ];

  async function renderTemplates() {
    var main = document.getElementById('main');
    main.innerHTML = '<div class="card"><div class="card-header"><h2>Email & UI Templates</h2><span class="meta"><span class="spinner"></span></span></div></div>';
    try {
      if (_state.templates.type === 'mail') {
        var res = await api('GET', '/api/templates/mail');
        _state.templates.mailTemplates = res.templates || [];
      } else {
        var resUi = await api('GET', '/api/templates/ui');
        _state.templates.uiTranslations = resUi.translations || [];
      }
      renderTemplatesUi();
    } catch (e) {
      main.innerHTML = '<div class="alert alert-error">' + esc(e.message) + '</div>';
    }
  }

  function renderTemplatesUi() {
    var main = document.getElementById('main');
    var isMail = _state.templates.type === 'mail';

    var html = '<div class="card">'
      + '<div class="card-header">'
      + '<h2>Email &amp; UI Templates</h2>'
      + '<div style="display:flex;gap:.5rem">'
      + '<button class="btn btn-sm ' + (isMail ? 'btn-primary' : '') + '" onclick="setTemplateType(\'mail\')">Email Templates</button>'
      + '<button class="btn btn-sm ' + (!isMail ? 'btn-primary' : '') + '" onclick="setTemplateType(\'ui\')">UI Translations</button>'
      + '</div>'
      + '</div>'
      + '<div style="padding:1.5rem" class="template-grid">'
      + '<div class="template-list">'
      + (isMail ? renderMailTemplateList() : renderUiTranslationList())
      + '</div>'
      + '<div class="template-editor-container" id="template-editor">'
      + '<div class="empty">Select an item to edit</div>'
      + '</div>'
      + '<div class="template-preview-pane" id="template-editor-preview"></div>'
      + '</div>'
      + '</div>';

    main.innerHTML = html;
    if (_state.templates.selectedId) {
      if (isMail) {
        editMailTemplate(_state.templates.selectedId);
      } else {
        editUiTranslation(_state.templates.selectedId);
      }
    }
  }

  function renderMailTemplateList() {
    return MAIL_TEMPLATES.map(function (t) {
      var isCustom = _state.templates.mailTemplates.some(function (x) { return x.id === t.id; });
      var active = _state.templates.selectedId === t.id ? ' active' : '';
      return '<div class="template-item' + active + '" data-tpl-id="' + esc(t.id) + '" onclick="editMailTemplate(\'' + esc(t.id) + '\')">'
        + '<strong>' + esc(t.label) + '</strong>'
        + '<small>' + (isCustom ? '\u2728 customised' : 'using default') + '</small>'
        + '</div>';
    }).join('');
  }

  function renderUiTranslationList() {
    return UI_PAGES.map(function (p) {
      var isCustom = _state.templates.uiTranslations.some(function (u) { return u.page === p.page; });
      var active = _state.templates.selectedId === p.page ? ' active' : '';
      return '<div class="template-item' + active + '" data-tpl-id="' + esc(p.page) + '" onclick="editUiTranslation(\'' + esc(p.page) + '\')">'
        + '<strong>' + esc(p.label) + '</strong>'
        + '<small>' + (isCustom ? '\u2728 customised' : 'using default') + '</small>'
        + '</div>';
    }).join('');
  }

  // Insert text at the caret position of a textarea
  function insertAtCaret(textarea, text) {
    if (!textarea) return;
    var start = textarea.selectionStart;
    var end = textarea.selectionEnd;
    var val = textarea.value;
    textarea.value = val.slice(0, start) + text + val.slice(end);
    textarea.selectionStart = textarea.selectionEnd = start + text.length;
    textarea.focus();
    textarea.dispatchEvent(new Event('input'));
  }

  function editMailTemplate(id) {
    _state.templates.selectedId = id;
    _state.templates.previewLang = _state.templates.previewLang || 'en';
    var meta = MAIL_TEMPLATES.find(function (t) { return t.id === id; });
    var existing = _state.templates.mailTemplates.find(function (x) { return x.id === id; })
      || { id: id, baseHtml: '', baseText: '', translations: {} };

    var container = document.getElementById('template-editor');

    var varHtml = meta.variables.map(function (v) {
      return '<span class="template-var-chip" data-insert="{{' + v.name + '}}" title="' + esc(v.description) + '">{{' + v.name + '}}</span>';
    }).join(' ');

    var tKeysHtml = meta.translationKeys.map(function (k) {
      return '<span class="template-var-chip" data-insert="{{T.' + k + '}}" title="Translation key">{{T.' + k + '}}</span>';
    }).join(' ');

    container.innerHTML = ''
      + '<div class="template-editor-header">'
      +   '<div><h3>' + esc(meta.label) + '</h3>'
      +     '<small style="color:#6b7280">' + esc(meta.description) + '</small></div>'
      +   '<div style="display:flex;gap:.5rem">'
      +     '<button class="btn btn-sm" onclick="resetMailTemplate(\'' + esc(id) + '\')">Reset to default</button>'
      +     '<button class="btn btn-primary btn-sm" onclick="saveMailTemplate(\'' + esc(id) + '\')">Save</button>'
      +   '</div>'
      + '</div>'
      + '<div class="template-editor-body">'
      +   '<div class="template-vars">'
      +     '<h4>Template variables</h4>' + varHtml
      +     '<h4 style="margin-top:.5rem">Translation keys</h4>' + tKeysHtml
      +     '<div style="color:#6b7280;margin-top:.25rem">Click any chip to insert into the focused textarea.</div>'
      +   '</div>'
      +   '<label><strong>HTML body</strong></label>'
      +   '<textarea id="tpl-html" class="template-editor-textarea">' + esc(existing.baseHtml || '') + '</textarea>'
      +   '<label><strong>Plain-text body</strong></label>'
      +   '<textarea id="tpl-text" class="template-editor-textarea" style="min-height:80px">' + esc(existing.baseText || '') + '</textarea>'
      +   '<label><strong>Translations</strong></label>'
      +   '<div id="tpl-translations-ui"></div>'
      + '</div>';

    _state.templates.editingTranslations = JSON.parse(JSON.stringify(existing.translations || {}));

    renderTranslationsEditor('tpl-translations-ui', existing.translations || {}, meta.translationKeys,
      function (newTranslations) {
        _state.templates.editingTranslations = newTranslations;
        schedulePreview();
      });

    _state.templates.lastFocus = document.getElementById('tpl-html');
    ['tpl-html', 'tpl-text'].forEach(function (tid) {
      var el = document.getElementById(tid);
      if (!el) return;
      el.addEventListener('focus', function () { _state.templates.lastFocus = el; });
      el.addEventListener('input', schedulePreview);
    });
    container.querySelectorAll('.template-var-chip').forEach(function (chip) {
      chip.addEventListener('click', function () {
        insertAtCaret(_state.templates.lastFocus, chip.getAttribute('data-insert'));
        schedulePreview();
      });
    });

    document.querySelectorAll('.template-list .template-item').forEach(function (el) {
      el.classList.toggle('active', el.getAttribute('data-tpl-id') === id);
    });

    mountPreviewPane(meta);
    schedulePreview();
  }

  function editUiTranslation(page) {
    _state.templates.selectedId = page;
    var pageInfo = UI_PAGES.find(function (p) { return p.page === page; });
    var u = _state.templates.uiTranslations.find(function (x) { return x.page === page; }) || { page: page, translations: {} };
    var container = document.getElementById('template-editor');
    var suggestedKeys = pageInfo ? pageInfo.keys : [];

    container.innerHTML = ''
      + '<div class="template-editor-header">'
      +   '<div><h3>' + esc(pageInfo ? pageInfo.label : page) + '</h3>'
      +     '<small style="color:#6b7280">UI translation overrides for the <code>' + esc(page) + '</code> page.</small></div>'
      +   '<button class="btn btn-primary btn-sm" onclick="saveUiTranslation(\'' + esc(page) + '\')">Save</button>'
      + '</div>'
      + '<div class="template-editor-body">'
      +   '<div style="background:#fef3c7;padding:.75rem;border-radius:6px;font-size:12px;color:#92400e;margin-bottom:.5rem">'
      +     '\u2139\uFE0F Keys are the <code>data-i18n</code> attribute values used in <strong>' + esc(page) + '.html</strong>.'
      +   '</div>'
      +   '<div id="ui-translations-editor"></div>'
      + '</div>';

    _state.templates.editingTranslations = JSON.parse(JSON.stringify(u.translations || {}));

    renderTranslationsEditor('ui-translations-editor', u.translations || {}, suggestedKeys,
      function (newTranslations) {
        _state.templates.editingTranslations = newTranslations;
      });

    document.querySelectorAll('.template-list .template-item').forEach(function (el) {
      el.classList.toggle('active', el.getAttribute('data-tpl-id') === page);
    });

    // Clear preview pane for UI translations (no preview needed)
    var prev = document.getElementById('template-editor-preview');
    if (prev) prev.innerHTML = '';
  }

  // Reusable per-language tab + key/value grid translations editor
  function renderTranslationsEditor(mountId, translations, suggestedKeys, onChange) {
    var mount = document.getElementById(mountId);
    if (!mount) return;
    var state = {
      data: JSON.parse(JSON.stringify(translations || {})),
      activeLang: Object.keys(translations || {})[0] || 'en',
    };

    function render() {
      var langs = Object.keys(state.data);
      if (langs.length === 0) { state.data[state.activeLang] = {}; langs = [state.activeLang]; }
      if (!state.data[state.activeLang]) { state.activeLang = langs[0]; }

      var tabs = langs.map(function (l) {
        return '<button class="translation-lang-tab' + (l === state.activeLang ? ' active' : '') + '" data-lang="' + esc(l) + '">'
          + esc(l.toUpperCase())
          + ' <span onclick="event.stopPropagation()" style="margin-left:.25rem;color:#9ca3af" data-rm-lang="' + esc(l) + '" title="Remove language">\u2715</span></button>';
      }).join('');

      var activeData = state.data[state.activeLang] || {};
      var knownKeys = Object.keys(activeData).slice();
      suggestedKeys.forEach(function (k) { if (knownKeys.indexOf(k) === -1) knownKeys.push(k); });

      var rows = knownKeys.map(function (k) {
        var val = activeData[k] !== undefined ? activeData[k] : '';
        return '<input type="text" value="' + esc(k) + '" data-key="' + esc(k) + '" data-role="key">'
          + '<input type="text" value="' + esc(val) + '" data-key="' + esc(k) + '" data-role="value" placeholder="(not set)">'
          + '<button class="btn btn-sm btn-danger" data-rm-key="' + esc(k) + '" title="Remove key">\u2715</button>';
      }).join('');

      mount.innerHTML = ''
        + '<div class="translation-lang-tabs">'
        +   tabs
        +   '<button class="translation-lang-tab" data-add-lang="1" title="Add language">+ Add lang</button>'
        + '</div>'
        + '<div class="translation-grid">'
        +   '<strong style="font-size:.75rem;text-transform:uppercase;color:#6b7280">Key</strong>'
        +   '<strong style="font-size:.75rem;text-transform:uppercase;color:#6b7280">Value</strong>'
        +   '<span></span>'
        +   rows
        + '</div>'
        + '<div style="display:flex;gap:.375rem;margin-top:.5rem">'
        +   '<input type="text" id="' + mountId + '-newkey" placeholder="new key" style="flex:1">'
        +   '<button class="btn btn-sm" data-add-key="1">+ Add key</button>'
        + '</div>';

      mount.querySelectorAll('.translation-lang-tab[data-lang]').forEach(function (btn) {
        btn.addEventListener('click', function () {
          state.activeLang = btn.getAttribute('data-lang');
          render();
        });
      });
      mount.querySelectorAll('[data-rm-lang]').forEach(function (x) {
        x.addEventListener('click', function () {
          var l = x.getAttribute('data-rm-lang');
          if (!confirm('Remove all "' + l + '" translations?')) return;
          delete state.data[l];
          state.activeLang = Object.keys(state.data)[0] || 'en';
          onChange(state.data);
          render();
        });
      });
      var addLangBtn = mount.querySelector('[data-add-lang]');
      if (addLangBtn) {
        addLangBtn.addEventListener('click', function () {
          var l = prompt('Language code (e.g. "fr", "de", "es"):');
          if (!l) return;
          l = l.trim().toLowerCase();
          if (!/^[a-z]{2,3}(-[a-z0-9]+)*$/.test(l)) { alert('Invalid language code'); return; }
          if (state.data[l]) { state.activeLang = l; render(); return; }
          state.data[l] = {};
          state.activeLang = l;
          onChange(state.data);
          render();
        });
      }
      mount.querySelectorAll('input[data-role="value"]').forEach(function (inp) {
        inp.addEventListener('input', function () {
          var k = inp.getAttribute('data-key');
          if (!state.data[state.activeLang]) state.data[state.activeLang] = {};
          state.data[state.activeLang][k] = inp.value;
          onChange(state.data);
        });
      });
      mount.querySelectorAll('input[data-role="key"]').forEach(function (inp) {
        inp.addEventListener('change', function () {
          var oldK = inp.getAttribute('data-key');
          var newK = inp.value.trim();
          if (!newK || newK === oldK) { inp.value = oldK; return; }
          if (state.data[state.activeLang][newK] !== undefined) { alert('Key already exists'); inp.value = oldK; return; }
          state.data[state.activeLang][newK] = state.data[state.activeLang][oldK];
          delete state.data[state.activeLang][oldK];
          onChange(state.data);
          render();
        });
      });
      mount.querySelectorAll('[data-rm-key]').forEach(function (btn) {
        btn.addEventListener('click', function () {
          var k = btn.getAttribute('data-rm-key');
          delete state.data[state.activeLang][k];
          onChange(state.data);
          render();
        });
      });
      var addKeyBtn = mount.querySelector('[data-add-key]');
      if (addKeyBtn) {
        addKeyBtn.addEventListener('click', function () {
          var ip = document.getElementById(mountId + '-newkey');
          var k = ip ? ip.value.trim() : '';
          if (!k) return;
          if (!state.data[state.activeLang]) state.data[state.activeLang] = {};
          if (state.data[state.activeLang][k] !== undefined) { alert('Key already exists'); return; }
          state.data[state.activeLang][k] = '';
          if (ip) ip.value = '';
          onChange(state.data);
          render();
        });
      }
    }

    render();
  }

  // ---- Live preview helpers -------------------------------------------------

  function schedulePreview() {
    clearTimeout(_state.templates.previewTimer);
    _state.templates.previewTimer = setTimeout(renderPreviewNow, 100);
  }

  function renderPreviewNow() {
    var id = _state.templates.selectedId;
    if (!id) return;
    var meta = MAIL_TEMPLATES.find(function (t) { return t.id === id; });
    if (!meta) return;
    var htmlEl = document.getElementById('tpl-html');
    var textEl = document.getElementById('tpl-text');
    var html = htmlEl ? htmlEl.value : '';
    var text = textEl ? textEl.value : '';
    var translations = _state.templates.editingTranslations || {};
    var lang = _state.templates.previewLang || 'en';
    var trans = translations[lang] || translations['en'] || {};

    var sample = {};
    meta.variables.forEach(function (v) { sample[v.name] = '\xAB' + v.name + '\xBB'; });
    if (sample['link'] !== undefined) sample['link'] = 'https://example.com/action?token=XXXX';
    if (sample['loginUrl'] !== undefined) sample['loginUrl'] = 'https://example.com/login';
    if (sample['tempPassword'] !== undefined) sample['tempPassword'] = 'TempPw123!';
    if (sample['newEmail'] !== undefined) sample['newEmail'] = 'new.address@example.com';
    if (sample['token'] !== undefined) sample['token'] = 'abc123\u2026';

    function interpolate(str) {
      var out = String(str || '').replace(/\{\{T\.([^}]+)\}\}/g, function (_, k) {
        return trans[k] !== undefined ? trans[k] : ('[' + k + ']');
      });
      out = out.replace(/\{\{([^}]+)\}\}/g, function (m, k) {
        if (k.indexOf('T.') === 0) return m;
        return sample[k] !== undefined ? sample[k] : ('[' + k + ']');
      });
      return out;
    }

    var subject = interpolate(trans['subject'] || '(no subject key set)');
    var rendered = interpolate(html);
    var renderedText = interpolate(text);

    var subjEl = document.getElementById('preview-subject');
    if (subjEl) subjEl.textContent = 'Subject: ' + subject;

    var iframe = document.getElementById('preview-iframe');
    if (iframe) {
      // Use srcdoc to render admin-authored HTML inside a fully sandboxed iframe.
      // sandbox="" prevents scripts, forms, top-navigation, plugins, and all other
      // active content — the admin can only see a styled preview of their own HTML.
      var previewDoc = '<!DOCTYPE html><html><head><meta charset="utf-8">'
        + '<style>body{font:14px system-ui;padding:12px;margin:0;color:#111}a{color:#3b82f6}</style>'
        + '</head><body>' + rendered + '</body></html>';
      iframe.srcdoc = previewDoc;
    }

    var textPrev = document.getElementById('preview-text');
    if (textPrev) textPrev.textContent = renderedText || '(empty)';
  }

  function mountPreviewPane(meta) {
    var main = document.getElementById('template-editor-preview');
    if (!main) return;
    var langs = Object.keys(_state.templates.editingTranslations || {});
    if (langs.length === 0) langs = ['en'];
    var langBtns = langs.map(function (l) {
      return '<button class="' + (l === (_state.templates.previewLang || 'en') ? 'active' : '') + '" data-preview-lang="' + esc(l) + '">' + esc(l.toUpperCase()) + '</button>';
    }).join('');

    main.innerHTML = ''
      + '<strong style="font-size:.75rem;text-transform:uppercase;color:#6b7280">Live preview</strong>'
      + '<div class="template-preview-lang">' + langBtns + '</div>'
      + '<div class="template-preview-subject" id="preview-subject">Subject: \u2026</div>'
      + '<iframe class="template-preview-iframe" id="preview-iframe" sandbox=""></iframe>'
      + '<details><summary style="cursor:pointer;font-size:.75rem;color:#6b7280">Plain-text</summary>'
      +   '<pre id="preview-text" style="background:white;padding:.5rem;border-radius:4px;white-space:pre-wrap;font-size:.75rem"></pre>'
      + '</details>';

    main.querySelectorAll('[data-preview-lang]').forEach(function (b) {
      b.addEventListener('click', function () {
        _state.templates.previewLang = b.getAttribute('data-preview-lang');
        mountPreviewPane(meta);
        schedulePreview();
      });
    });
  }

  async function saveMailTemplate(id) {
    var baseHtml = document.getElementById('tpl-html').value;
    var baseText = document.getElementById('tpl-text').value;
    var translations = _state.templates.editingTranslations || {};
    try {
      await api('POST', '/api/templates/mail', { id: id, baseHtml: baseHtml, baseText: baseText, translations: translations });
      flash('Template saved');
      renderTemplates();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function resetMailTemplate(id) {
    if (!confirm('Reset "' + id + '" to the built-in default? Custom content will be lost.')) return;
    try {
      await api('POST', '/api/templates/mail', { id: id, baseHtml: '', baseText: '', translations: {} });
      flash('Template reset to default');
      renderTemplates();
    } catch (e) { flash(e.message, 'error'); }
  }

  async function saveUiTranslation(page) {
    var translations = _state.templates.editingTranslations || {};
    try {
      await api('POST', '/api/templates/ui', { page: page, translations: translations });
      flash('UI translations saved');
      renderTemplates();
    } catch (e) { flash(e.message, 'error'); }
  }

  function setTemplateType(type) {
    _state.templates.type = type;
    _state.templates.selectedId = null;
    renderTemplates();
  }

  window.setTemplateType = setTemplateType;
  window.editMailTemplate = editMailTemplate;
  window.editUiTranslation = editUiTranslation;
  window.saveMailTemplate = saveMailTemplate;
  window.saveUiTranslation = saveUiTranslation;
  window.resetMailTemplate = resetMailTemplate;
  window.deleteUser = deleteUser;
  window.setBulk2FA = setBulk2FA;
  window.renderSessions = renderSessions;
  window.revokeSession = revokeSession;
  window.renderRoles = renderRoles;
  window.createRole = createRole;
  window.deleteRole = deleteRole;
  window.renderTenants = renderTenants;
  window.toggleTenantPanel = toggleTenantPanel;
  window.addTenantUser = addTenantUser;
  window.removeTenantUser = removeTenantUser;
  window.createTenant = createTenant;
  window.deleteTenant = deleteTenant;
  window.renderControl = renderControl;
  window.toggleWebhookAction = toggleWebhookAction;
  window.updateEmailVerificationMode = updateEmailVerificationMode;
  window.saveGracePeriod = saveGracePeriod;
  window.updateSetting = updateSetting;
  window.saveUiSettings = saveUiSettings;
  window.uploadAsset = uploadAsset;
  window.listUploads = listUploads;
  window.deleteUpload = deleteUpload;
  window.syncBgColor = syncBgColor;
  window.syncBgColorText = syncBgColorText;
  window.syncCardBg = syncCardBg;
  window.syncCardBgText = syncCardBgText;
  window.uiPreview = uiPreview;
  window.renderApiKeys = renderApiKeys;
  window.revokeApiKey = revokeApiKey;
  window.deleteApiKey = deleteApiKey;
  window.createApiKey = createApiKey;
  window.renderWebhooks = renderWebhooks;
  window.toggleWebhookType = toggleWebhookType;
  window.openWebhookDrawer = openWebhookDrawer;
  window.closeWebhookDrawer = closeWebhookDrawer;
  window.saveWebhook = saveWebhook;
  window.createWebhook = createWebhook;
  window.toggleWebhook = toggleWebhook;
  window.deleteWebhook = deleteWebhook;
  window._state = _state;

  // ---- Init ----------------------------------------------------------------
  buildNav();

}());
""";

const embeddedAdminCss = r"""/* awesome-node-auth admin panel stylesheet */
* { box-sizing: border-box; margin: 0; padding: 0; }
html, body { height: 100%; }
body { font-family: system-ui, -apple-system, sans-serif; background: #f0f2f5; color: #1a1a2e; }

/* Login */
#login { display: flex; align-items: center; justify-content: center; min-height: 100%; }
.login-card { background: white; padding: 2.5rem; border-radius: 12px; box-shadow: 0 4px 24px rgba(0,0,0,.12); width: 400px; }
.login-card h1 { font-size: 1.5rem; margin-bottom: .25rem; }
.login-card p { color: #666; font-size: .875rem; margin-bottom: 1.5rem; }

/* App */
#app { display: none; min-height: 100%; flex-direction: column; }
header { background: #1a1a2e; color: white; padding: 1rem 2rem; display: flex; align-items: center; justify-content: space-between; }
header h1 { font-size: 1.1rem; font-weight: 700; letter-spacing: .5px; }
header span { font-size: .75rem; opacity: .6; }
nav { background: white; border-bottom: 1px solid #e5e7eb; padding: 0 2rem; display: flex; gap: .25rem; }
nav button { padding: .75rem 1.25rem; border: none; background: none; cursor: pointer; border-bottom: 3px solid transparent; color: #6b7280; font-size: .875rem; font-weight: 500; transition: all .15s; }
nav button:hover { color: #1a1a2e; }
nav button.active { color: #1a1a2e; border-color: #1a1a2e; }
main { padding: 2rem; flex: 1; }

/* Cards */
.card { background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,.08); overflow: hidden; margin-bottom: 1.5rem; }
.card-header { padding: 1rem 1.5rem; border-bottom: 1px solid #f3f4f6; display: flex; align-items: center; justify-content: space-between; }
.card-header h2 { font-size: .9375rem; font-weight: 600; }
.card-header .meta { font-size: .75rem; color: #9ca3af; }

/* Tables */
.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
th { padding: .625rem 1rem; text-align: left; font-size: .6875rem; font-weight: 600; text-transform: uppercase; letter-spacing: .05em; color: #9ca3af; background: #fafafa; border-bottom: 1px solid #f3f4f6; white-space: nowrap; }
td { padding: .75rem 1rem; border-bottom: 1px solid #f9fafb; font-size: .8125rem; max-width: 240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #fafafa; }

/* Badges */
.badge { display: inline-flex; align-items: center; gap: .25rem; padding: .125rem .5rem; border-radius: 999px; font-size: .6875rem; font-weight: 600; }
.badge-green { background: #dcfce7; color: #166534; }
.badge-gray { background: #f3f4f6; color: #4b5563; }
.badge-red { background: #fee2e2; color: #991b1b; }
.badge-blue { background: #dbeafe; color: #1d4ed8; }
.badge-indigo { background: #e0e7ff; color: #3730a3; }

/* Forms */
.form-row { display: flex; gap: .5rem; align-items: center; }
input[type=text], input[type=password], input[type=email] { padding: .5rem .75rem; border: 1px solid #d1d5db; border-radius: 6px; font-size: .875rem; width: 100%; outline: none; transition: border .15s; }
input:focus { border-color: #1a1a2e; }
.btn { padding: .5rem 1rem; border: none; border-radius: 6px; font-size: .875rem; font-weight: 500; cursor: pointer; transition: opacity .15s; }
.btn:hover { opacity: .88; }
.btn-primary { background: #1a1a2e; color: white; }
.btn-danger { background: #dc2626; color: white; font-size: .75rem; padding: .25rem .6rem; }
.btn-sm { font-size: .75rem; padding: .25rem .6rem; }

/* Misc */
.empty { text-align: center; color: #9ca3af; padding: 3rem 1rem; }
.empty svg { display: block; margin: 0 auto 1rem; opacity: .4; }
.pager { display: flex; align-items: center; gap: .5rem; padding: .75rem 1rem; border-top: 1px solid #f3f4f6; font-size: .8125rem; color: #6b7280; }
.pager button { padding: .25rem .625rem; border: 1px solid #d1d5db; border-radius: 4px; background: white; cursor: pointer; font-size: .8125rem; }
.pager button:disabled { opacity: .4; cursor: default; }
.alert { padding: .75rem 1rem; border-radius: 6px; font-size: .8125rem; margin-bottom: 1rem; }
.alert-error { background: #fee2e2; color: #991b1b; }
.alert-success { background: #dcfce7; color: #166534; }
.spinner { display: inline-block; width: 16px; height: 16px; border: 2px solid #e5e7eb; border-top-color: #1a1a2e; border-radius: 50%; animation: spin .6s linear infinite; vertical-align: middle; }
@keyframes spin { to { transform: rotate(360deg); } }
#flash { position: fixed; top: 1rem; right: 1rem; z-index: 999; max-width: 320px; }
tr.tr-open > td { background: #eff6ff; }
.manage-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(600px, 800px)); gap: 1.25rem; }
.manage-section { background: #f8fafc; border: 1px solid #e5e7eb; border-radius: 8px; padding: 1rem 1.25rem; }
.manage-section-title { font-size: .8125rem; font-weight: 600; color: #374151; margin-bottom: .625rem; }
.roles-list { display: flex; flex-wrap: wrap; gap: .375rem; min-height: 26px; align-items: flex-start; }
.role-chip { cursor: pointer; user-select: none; transition: opacity .1s; }
.role-chip:hover { opacity: .75; }
.form-select { padding: .375rem .625rem; border: 1px solid #d1d5db; border-radius: 6px; font-size: .8125rem; outline: none; flex-shrink: 0; }
.form-select:focus { border-color: #1a1a2e; }
.meta-editor { width: 100%; height: 130px; margin-top: .25rem; padding: .5rem; font-family: monospace; font-size: .8125rem; border: 1px solid #d1d5db; border-radius: 6px; resize: vertical; outline: none; color: #1a1a2e; }
.meta-editor:focus { border-color: #1a1a2e; }

/* Toggle switches */
.toggle-row { display: flex; align-items: center; justify-content: space-between; padding: .75rem 0; border-bottom: 1px solid #f3f4f6; }
.toggle-row:last-child { border-bottom: none; }
.toggle-label { font-size: .875rem; color: #1a1a2e; flex: 1; }
.toggle-label small { display: block; font-size: .75rem; color: #9ca3af; margin-top: .125rem; }
.toggle { position: relative; display: inline-block; width: 44px; height: 24px; flex-shrink: 0; }
.toggle input { opacity: 0; width: 0; height: 0; }
.toggle-slider { position: absolute; cursor: pointer; inset: 0; background: #d1d5db; border-radius: 24px; transition: .2s; }
.toggle-slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px; background: white; border-radius: 50%; transition: .2s; }
input:checked + .toggle-slider { background: #1a1a2e; }
input:checked + .toggle-slider:before { transform: translateX(20px); }

/* Filter bar */
.filter-bar { display: flex; gap: .5rem; align-items: center; padding: .75rem 1rem; border-bottom: 1px solid #f3f4f6; }
.filter-bar input { max-width: 260px; flex: 1; }

/* Batch bar */
.batch-bar { display: none; align-items: center; gap: .75rem; padding: .5rem 1rem; background: #fffbeb; border-bottom: 1px solid #fde68a; font-size: .8125rem; }
.batch-bar.visible { display: flex; }

/* Row checkbox */
.cb-col { width: 36px; text-align: center; }

/* ── Email & UI Templates tab ──────────────────────────────────────────────── */
.template-grid {
  display: grid;
  grid-template-columns: 240px 1fr 320px;
  gap: 1rem;
  min-height: 500px;
}
.template-list {
  border-right: 1px solid #e5e7eb;
  padding-right: 0.75rem;
}
.template-item {
  padding: 0.5rem 0.75rem;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.875rem;
  margin-bottom: 0.25rem;
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
}
.template-item:hover { background: #f3f4f6; }
.template-item.active {
  background: #e0e7ff;
  color: #3730a3;
  font-weight: 600;
}
.template-item small { color: #9ca3af; font-size: 0.7rem; }
.template-item.active small { color: #6366f1; }

.template-editor-container { display: flex; flex-direction: column; gap: 0.75rem; }
.template-editor-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e5e7eb;
}
.template-editor-header h3 { font-size: 0.9375rem; margin: 0; }
.template-editor-body { display: flex; flex-direction: column; gap: 0.5rem; }
.template-editor-textarea {
  width: 100%;
  min-height: 140px;
  padding: 0.5rem;
  font-family: ui-monospace, SFMono-Regular, monospace;
  font-size: 0.8125rem;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  resize: vertical;
}

.template-preview-pane {
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #f9fafb;
  padding: 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  position: sticky;
  top: 1rem;
  height: fit-content;
  max-height: calc(100vh - 120px);
  overflow-y: auto;
}
.template-preview-lang {
  display: flex;
  gap: 0.25rem;
  flex-wrap: wrap;
  margin-bottom: 0.25rem;
}
.template-preview-lang button {
  padding: 0.125rem 0.5rem;
  font-size: 0.75rem;
  border-radius: 4px;
  border: 1px solid #d1d5db;
  background: white;
  cursor: pointer;
}
.template-preview-lang button.active {
  background: #1a1a2e;
  color: white;
  border-color: #1a1a2e;
}
.template-preview-iframe {
  width: 100%;
  min-height: 320px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  background: white;
}
.template-preview-subject {
  padding: 0.375rem 0.5rem;
  background: white;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  font-size: 0.75rem;
  font-family: ui-monospace, SFMono-Regular, monospace;
}

.template-vars {
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  border-radius: 6px;
  padding: 0.5rem 0.75rem;
  font-size: 0.75rem;
}
.template-vars h4 {
  margin: 0 0 0.375rem 0;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #065f46;
}
.template-var-chip {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.125rem 0.375rem;
  margin: 0.125rem;
  font-family: ui-monospace, SFMono-Regular, monospace;
  font-size: 0.6875rem;
  background: white;
  border: 1px solid #bbf7d0;
  border-radius: 4px;
  cursor: pointer;
}
.template-var-chip:hover { background: #dcfce7; }

.translation-grid {
  display: grid;
  grid-template-columns: 180px 1fr auto;
  gap: 0.375rem;
  align-items: center;
}
.translation-grid input {
  padding: 0.25rem 0.5rem;
  font-size: 0.8125rem;
  border: 1px solid #d1d5db;
  border-radius: 4px;
}
.translation-lang-tabs {
  display: flex;
  gap: 0.25rem;
  border-bottom: 1px solid #e5e7eb;
  margin-bottom: 0.5rem;
  flex-wrap: wrap;
}
.translation-lang-tab {
  padding: 0.375rem 0.75rem;
  font-size: 0.8125rem;
  background: transparent;
  border: none;
  border-bottom: 2px solid transparent;
  cursor: pointer;
  color: #6b7280;
}
.translation-lang-tab.active {
  color: #1a1a2e;
  border-bottom-color: #1a1a2e;
  font-weight: 600;
}
""";

const embeddedAdminUi = r"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>awesome-node-auth Admin</title>
  <link rel="stylesheet" href="/auth/admin/assets/admin.css">
</head>
<body>
<div id="login">
  <div class="login-card">
    <h1>&#128272; awesome-node-auth</h1>
    <p>Administration panel</p>
    <div id="login-error" class="alert alert-error" style="display:none"></div>
    <div style="display:flex;flex-direction:column;gap:.75rem">
      <input type="password" id="secret-input" placeholder="Admin secret" autofocus>
      <button class="btn btn-primary" onclick="doLogin()">Sign in</button>
    </div>
  </div>
</div>
<div id="app">
  <div id="flash"></div>
  <header>
    <h1>&#128272; awesome-node-auth Admin</h1>
    <span id="header-meta"></span>
  </header>
  <nav id="nav">
    <button class="btn logout-btn" style="margin-left:auto;margin-top:.4rem;margin-bottom:.4rem;font-size:.75rem;padding:.25rem .75rem;background:#f3f4f6;border:1px solid #e5e7eb;border-radius:6px" onclick="doLogout()">Logout</button>
  </nav>
  <main id="main"></main>
</div>
<script>window.__ADMIN_CONFIG__ = {"base":"/auth/admin","featSessions":false,"featRoles":false,"featTenants":false,"featMetadata":false,"feat2faPolicy":false,"featControl":false,"featLinkedAccounts":false,"featApiKeys":false,"featWebhooks":false,"featTemplates":false,"featUpload":false,"uploadBaseUrl":"","sessionBased":false,"authApiPrefix":"/auth"};</script>
<script src="/auth/admin/assets/admin.js"></script>
</body>
</html>
""";
