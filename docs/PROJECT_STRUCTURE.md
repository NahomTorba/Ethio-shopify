# Production-Level Project Structure

This repository is already split in a good direction:

- `backend/` contains the Ruby on Rails API and server-side logic.
- `frontend/` contains the React application.

What needs improvement is not the high-level split. The main gaps are:

- there is a duplicate app folder at `Ethio-shopify/`
- the frontend still has starter Create React App structure
- some backend route logic is written inline inside `config/routes.rb`
- secrets and deployment-local files are too easy to commit

## Recommended top-level structure

```text
ethio-shopify/
  backend/              # Rails API, webhooks, domain logic
  frontend/             # React admin or seller dashboard
  docs/                 # architecture and setup notes
  .gitignore
  README.md
  render.yaml           # keep only if Render is used
  railway.json          # keep only if Railway is used
  docker-compose.yml    # keep only if Docker is really used
```

## Recommended Rails backend structure

```text
backend/
  app/
    controllers/
      api/
        v1/
          base_controller.rb
          products_controller.rb
          orders_controller.rb
          shops_controller.rb
          sellers_controller.rb
      auth/
        sessions_controller.rb
        registrations_controller.rb
      webhooks/
        telegram_controller.rb
        shop_bot_controller.rb
        chapa_controller.rb
      public/
        shops_controller.rb
        products_controller.rb
        setups_controller.rb
    models/
      application_record.rb
      user.rb
      shop.rb
      product.rb
      order.rb
      cart.rb
      category.rb
    services/
      telegram/
        bot_handler.rb
        keyboard_builder.rb
        message_sender.rb
        shop_bot_handler.rb
        telegram_service.rb
      inventory/
        stock_alert_service.rb
    serializers/        # add when API responses grow
    policies/           # add when authorization becomes more complex
  config/
    routes.rb
    environments/
    initializers/
  db/
    migrate/
    schema.rb
    seeds.rb
  lib/
    json_web_token.rb
    authenticate_bot_request.rb
  test/
```

## Recommended React frontend structure

```text
frontend/
  public/
  src/
    app/
      App.jsx
      router.jsx
      providers.jsx
    api/
      client.js
      products.js
      orders.js
      shops.js
      auth.js
    components/
      layout/
      ui/
      forms/
      settings/
    features/
      dashboard/
      inventory/
      orders/
      bot-settings/
      auth/
    hooks/
    store/
    i18n/
      config.js
      locales/
    styles/
      globals.css
  package.json
```

## How to explain the structure simply

Use this explanation when presenting the project:

- `backend/app/controllers` receives requests and decides what action to run.
- `backend/app/models` stores business data and model relationships.
- `backend/app/services` holds reusable business workflows, especially logic that is too big for models or controllers.
- `backend/config/routes.rb` maps URLs to controllers.
- `backend/db/migrate` contains database history.
- `frontend/src/app` is the frontend entry point.
- `frontend/src/features` groups code by business feature, not by file type alone.
- `frontend/src/components` holds shared UI pieces.
- `frontend/src/api` is where React talks to Rails.
- `frontend/src/store` keeps shared client state.

## Current repo cleanup suggestions

### Safe to remove soon

- `Ethio-shopify/`
  - It looks like a duplicate copy of the project inside the project.
- `frontend/src/App.js`
  - It is still the default starter file and does not match the current app.
- `frontend/src/App.css`
  - Remove if the real UI uses `index.css` or feature-based styling instead.
- empty page files in `frontend/src/pages/`
  - `Dashboard.js`, `Inventory.js`, `Orders.js`, and `BotSettings.js` are currently empty placeholders.
- `docker-compose.yml`
  - It is empty right now, so it should either be implemented or removed.

### Keep, but refactor

- `backend/config/routes.rb`
  - Move the large inline HTML lambdas into controllers and views.
  - Production routes should mostly map paths to controllers, not contain page-building logic.
- `backend/app/services/telegram/*`
  - Good direction. Keep this pattern and continue moving bot logic here.
- `backend/app/controllers/api/v1/*`
  - Good namespace. Keep building the API under versioned routes.

### Keep only if actually used

- `render.yaml`
- `railway.json`
- `backend/.kamal/`

If you deploy on only one platform, keep only that platform's config. Extra deployment files make the project harder to explain.

## Files that should not be tracked in Git

These are now included in `.gitignore`:

- `backend/config/master.key`
- `backend/.kamal/secrets`
- `backend/secret_key.txt`
- `frontend/node_modules/`
- `frontend/build/`
- `backend/log/`
- `backend/tmp/`
- `backend/storage/`
- local `.env` files
- duplicate local backup folder `Ethio-shopify/`

## Best next refactor

If we want the project to feel production-level and easy to explain, the next cleanup should be:

1. Remove the duplicate `Ethio-shopify/` folder after confirming it is not needed.
2. Replace the React starter app with a real router-based app shell.
3. Move inline route HTML from Rails routes into dedicated controllers and views.
4. Decide on one deployment target and delete the unused deployment config files.
5. Add a better root `README.md` that explains backend, frontend, setup, and deployment.
