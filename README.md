# Ethio Shopify

Monorepo for a Rails backend and React frontend.

## Project layout

- `backend/` Ruby on Rails API, webhooks, business logic, and database layer
- `frontend/` React dashboard or admin client
- `docs/PROJECT_STRUCTURE.md` recommended production structure and cleanup notes

## Cleaned structure

```text
ethio-shopify/
  backend/
    app/
    bin/
    config/
    db/
    lib/
    log/
    public/
    storage/
    test/
    tmp/
    Dockerfile
    Gemfile
    Gemfile.lock
    Rakefile
  frontend/
    public/
    src/
      App.css
      App.js
      index.css
      index.js
      i18n/
        index.js
    package.json
    package-lock.json
    tailwind.config.js
  docs/
    PROJECT_STRUCTURE.md
  .gitignore
  README.md
  railway.json
  render.yaml
```

## Notes

- Removed the duplicate nested project folder and empty placeholder files.
- Kept runtime Rails files and deployment files untouched.
- Moved i18n setup into `frontend/src/i18n/index.js` so it matches the app import path.
