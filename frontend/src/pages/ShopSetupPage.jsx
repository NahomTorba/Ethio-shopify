import React, { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { createShopSetup, getErrorMessage } from '../lib/api';

const initialForm = {
  shop_name: '',
  shop_username: '',
  description: '',
  bot_token: ''
};

function ShopSetupPage() {
  const [searchParams] = useSearchParams();
  const [form, setForm] = useState(initialForm);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState('');
  const userId = useMemo(() => searchParams.get('user_id') || '', [searchParams]);

  async function handleSubmit(event) {
    event.preventDefault();
    setSaving(true);
    setMessage('');

    try {
      const response = await createShopSetup({
        ...form,
        user_id: userId
      });

      setMessage(response.message || 'Shop created successfully.');
      setForm(initialForm);
    } catch (error) {
      setMessage(getErrorMessage(error, 'Failed to create shop.'));
    } finally {
      setSaving(false);
    }
  }

  return (
    <main className="public-shell">
      <section className="hero-card">
        <p className="eyebrow">Shop setup</p>
        <h1>Launch a storefront from the React app</h1>
        <p className="muted">
          This page replaces the old backend-served setup form and posts directly to the Rails public API.
        </p>
      </section>

      <form className="panel form-panel" onSubmit={handleSubmit}>
        <label>
          Shop name
          <input
            value={form.shop_name}
            onChange={(event) => setForm({ ...form, shop_name: event.target.value })}
            required
          />
        </label>
        <label>
          Shop username
          <input
            value={form.shop_username}
            onChange={(event) => setForm({ ...form, shop_username: event.target.value })}
            placeholder="myshop_bot"
            required
          />
        </label>
        <label>
          Welcome message
          <textarea
            rows="3"
            value={form.description}
            onChange={(event) => setForm({ ...form, description: event.target.value })}
          />
        </label>
        <label>
          Bot token
          <input
            value={form.bot_token}
            onChange={(event) => setForm({ ...form, bot_token: event.target.value })}
            required
          />
        </label>
        <button className="primary-button" type="submit" disabled={saving}>
          {saving ? 'Creating...' : 'Create shop'}
        </button>
        {message ? <p className={message.includes('successfully') ? 'success' : 'error'}>{message}</p> : null}
      </form>
    </main>
  );
}

export default ShopSetupPage;
