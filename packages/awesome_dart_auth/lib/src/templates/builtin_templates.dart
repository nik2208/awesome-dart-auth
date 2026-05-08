const builtInTemplates = <String, Map<String, String>>{
  'en': {
    'password_reset':
        '<p>You requested a password reset.</p><p>Click this link (valid for 1 hour): <a href="{{link}}">{{link}}</a></p><p>If you did not request this, ignore this email.</p>',
    'magic_link':
        '<p>Hello {{name}}, use this magic link: <a href="{{link}}">{{link}}</a></p>',
    'welcome':
        '<p>Welcome {{name}} to awesome-dart-auth.</p><p>Sign in here: <a href="{{loginUrl}}">{{loginUrl}}</a></p>',
    'verify_email':
        '<p>Thank you for signing up.</p><p>Verify your email with this link (valid for 24 hours): <a href="{{link}}">{{link}}</a></p>',
    'email_changed':
        '<p>Your email address has been updated to <strong>{{newEmail}}</strong>.</p><p>If this was not you, contact support immediately.</p>',
    'invitation':
        '<p>You have been invited.</p><p>Open this link to continue: <a href="{{link}}">{{link}}</a></p>',
  },
  'it': {
    'password_reset':
        '<p>Hai richiesto di reimpostare la password.</p><p>Clicca su questo link (valido 1 ora): <a href="{{link}}">{{link}}</a></p><p>Se non hai richiesto questa operazione, ignora questa email.</p>',
    'magic_link':
        '<p>Ciao {{name}}, usa questo magic link: <a href="{{link}}">{{link}}</a></p>',
    'welcome':
        '<p>Benvenuto {{name}} in awesome-dart-auth.</p><p>Accedi qui: <a href="{{loginUrl}}">{{loginUrl}}</a></p>',
    'verify_email':
        '<p>Grazie per esserti registrato.</p><p>Verifica la tua email con questo link (valido 24 ore): <a href="{{link}}">{{link}}</a></p>',
    'email_changed':
        '<p>Il tuo indirizzo email è stato aggiornato a <strong>{{newEmail}}</strong>.</p><p>Se non hai richiesto questa modifica, contatta subito il supporto.</p>',
    'invitation':
        '<p>Sei stato invitato.</p><p>Apri questo link per continuare: <a href="{{link}}">{{link}}</a></p>',
  },
};
