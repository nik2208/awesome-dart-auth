const builtInTemplates = <String, Map<String, String>>{
  'en': {
    'password-reset':
        '<p>You requested a password reset.</p>\n'
            '<p>Click the link below to proceed (valid for 1 hour):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>If you did not request this, please ignore this email.</p>',
    'password_reset':
        '<p>You requested a password reset.</p>\n'
            '<p>Click the link below to proceed (valid for 1 hour):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>If you did not request this, please ignore this email.</p>',
    'magic-link':
        '<p>You requested a sign-in link.</p>\n'
            '<p>Click the link below to sign in (valid for 15 minutes):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>If you did not request this, please ignore this email.</p>',
    'magic_link':
        '<p>You requested a sign-in link.</p>\n'
            '<p>Click the link below to sign in (valid for 15 minutes):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>If you did not request this, please ignore this email.</p>',
    'welcome':
        '<p>Your account has been created successfully.</p>\n'
            '<p>Sign in here: <a href="{{loginUrl}}">{{loginUrl}}</a></p>',
    'verify-email':
        '<p>Thank you for signing up.</p>\n'
            '<p>Click the link below to verify your email address (valid for 24 hours):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>If you did not create an account, please ignore this email.</p>',
    'verify_email':
        '<p>Thank you for signing up.</p>\n'
            '<p>Click the link below to verify your email address (valid for 24 hours):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>If you did not create an account, please ignore this email.</p>',
    'email-changed':
        '<p>This is a notice that your email address has been updated to '
            '<strong>{{newEmail}}</strong>.</p>\n'
            '<p>If you did not request this change, please contact support '
            'immediately.</p>',
    'email_changed':
        '<p>This is a notice that your email address has been updated to '
            '<strong>{{newEmail}}</strong>.</p>\n'
            '<p>If you did not request this change, please contact support '
            'immediately.</p>',
    'invitation':
        '<p>You have been invited.</p><p><a href="{{link}}">{{link}}</a></p>',
  },
  'it': {
    'password-reset':
        '<p>Hai richiesto di reimpostare la tua password.</p>\n'
            '<p>Clicca sul link seguente per procedere (valido 1 ora):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>Se non hai richiesto questo, ignora questa email.</p>',
    'password_reset':
        '<p>Hai richiesto di reimpostare la tua password.</p>\n'
            '<p>Clicca sul link seguente per procedere (valido 1 ora):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>Se non hai richiesto questo, ignora questa email.</p>',
    'magic-link':
        '<p>Hai richiesto un link di accesso.</p>\n'
            '<p>Clicca sul link seguente per accedere (valido 15 minuti):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>Se non hai richiesto questo, ignora questa email.</p>',
    'magic_link':
        '<p>Hai richiesto un link di accesso.</p>\n'
            '<p>Clicca sul link seguente per accedere (valido 15 minuti):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>Se non hai richiesto questo, ignora questa email.</p>',
    'welcome':
        '<p>Il tuo account è stato creato con successo.</p>\n'
            '<p>Accedi qui: <a href="{{loginUrl}}">{{loginUrl}}</a></p>',
    'verify-email':
        '<p>Grazie per esserti registrato.</p>\n'
            '<p>Clicca sul link seguente per verificare il tuo indirizzo email '
            '(valido 24 ore):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>Se non hai creato un account, ignora questa email.</p>',
    'verify_email':
        '<p>Grazie per esserti registrato.</p>\n'
            '<p>Clicca sul link seguente per verificare il tuo indirizzo email '
            '(valido 24 ore):</p>\n'
            '<p><a href="{{link}}">{{link}}</a></p>\n'
            '<p>Se non hai creato un account, ignora questa email.</p>',
    'email-changed':
        '<p>Questo è un avviso che il tuo indirizzo email è stato aggiornato a '
            '<strong>{{newEmail}}</strong>.</p>\n'
            '<p>Se non hai richiesto questa modifica, contatta immediatamente il '
            'supporto.</p>',
    'email_changed':
        '<p>Questo è un avviso che il tuo indirizzo email è stato aggiornato a '
            '<strong>{{newEmail}}</strong>.</p>\n'
            '<p>Se non hai richiesto questa modifica, contatta immediatamente il '
            'supporto.</p>',
    'invitation':
        '<p>Sei stato invitato.</p><p><a href="{{link}}">{{link}}</a></p>',
  },
};
