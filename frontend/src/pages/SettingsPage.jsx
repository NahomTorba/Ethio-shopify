import React, { useState } from 'react';
import LanguageSwitcher from '../features/settings/components/LanguageSwitcher';
import {
  API_BASE_URL,
  clearAuthToken,
  getAuthToken,
  setAuthToken
} from '../lib/api';

function SettingsPage() {
  const [token, setToken] = useState(getAuthToken());
  const [message, setMessage] = useState('');

  function saveToken(event) {
    event.preventDefault();
    setAuthToken(token);
    setMessage('JWT saved locally for authenticated API calls.');
  }

  function removeToken() {
    clearAuthToken();
    setToken('');
    setMessage('JWT removed.');
  }

  return (
    <section className="page">
      <div className="page-header">
        <div>
          <p className="eyebrow">Settings</p>
          <h2>Local app configuration</h2>
        </div>
      </div>

      <LanguageSwitcher />

      <form className="panel form-panel" onSubmit={saveToken}>
        <div className="panel-header">
          <div>
            <p className="eyebrow">Authentication</p>
            <h3>Seller JWT</h3>
          </div>
        </div>
        <label>
          JWT token
          <textarea
            rows="4"
            value={token}
            onChange={(event) => setToken(event.target.value)}
            placeholder="Paste the JWT returned from /auth/sign_in"
          />
        </label>

        <div className="button-row">
          <button className="primary-button" type="submit">
            Save token
          </button>
          <button className="ghost-button" type="button" onClick={removeToken}>
            Clear token
          </button>
        </div>
        {message ? <p className="success">{message}</p> : null}
      </form>

      <section className="panel">
        <p className="eyebrow">Environment</p>
        <h3>Current API base URL</h3>
        <p className="muted">{API_BASE_URL}</p>
      </section>
    </section>
  );
}

export default SettingsPage;
