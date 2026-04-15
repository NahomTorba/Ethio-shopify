import React from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

const navigation = [
  { to: '/dashboard', labelKey: 'nav.dashboard' },
  { to: '/inventory', labelKey: 'nav.inventory' },
  { to: '/orders', labelKey: 'nav.orders' },
  { to: '/settings', labelKey: 'nav.settings' }
];

function AppShell() {
  const { t } = useTranslation();

  return (
    <div className="app-shell">
      <aside className="app-sidebar">
        <div>
          <p className="eyebrow">Ethio Shopify</p>
          <h1>Seller workspace</h1>
          <p className="muted">Rails handles the API, React handles the web UI.</p>
        </div>

        <nav className="app-nav" aria-label="Primary">
          {navigation.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) => `app-nav-link${isActive ? ' active' : ''}`}
            >
              {t(item.labelKey)}
            </NavLink>
          ))}
        </nav>
      </aside>

      <main className="app-main">
        <Outlet />
      </main>
    </div>
  );
}

export default AppShell;
