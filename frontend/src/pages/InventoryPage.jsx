import React, { useEffect, useState } from 'react';
import {
  createProduct,
  fetchProducts,
  fetchShops,
  getErrorMessage,
  hasAuthToken
} from '../lib/api';
import { formatCurrency } from '../lib/formatters';

const initialForm = {
  shop_id: '',
  name: '',
  description: '',
  price: '',
  stock_quantity: ''
};

function InventoryPage() {
  const [shops, setShops] = useState([]);
  const [products, setProducts] = useState([]);
  const [form, setForm] = useState(initialForm);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [feedback, setFeedback] = useState('');

  useEffect(() => {
    if (!hasAuthToken()) {
      setLoading(false);
      return;
    }

    async function loadData() {
      try {
        const [shopsResponse, productsResponse] = await Promise.all([fetchShops(), fetchProducts()]);
        setShops(shopsResponse);
        setProducts(productsResponse);
        setForm((current) => ({
          ...current,
          shop_id: current.shop_id || shopsResponse[0]?.id?.toString() || ''
        }));
      } catch (error) {
        setFeedback(getErrorMessage(error, 'Failed to load inventory.'));
      } finally {
        setLoading(false);
      }
    }

    loadData();
  }, []);

  async function handleSubmit(event) {
    event.preventDefault();
    setSaving(true);
    setFeedback('');

    try {
      const product = await createProduct({
        ...form,
        shop_id: Number(form.shop_id),
        price: Number(form.price),
        stock_quantity: Number(form.stock_quantity)
      });

      setProducts((current) => [product, ...current]);
      setForm((current) => ({
        ...initialForm,
        shop_id: current.shop_id
      }));
      setFeedback('Product created successfully.');
    } catch (error) {
      setFeedback(getErrorMessage(error, 'Failed to create product.'));
    } finally {
      setSaving(false);
    }
  }

  if (!hasAuthToken()) {
    return <p className="panel">Add your seller JWT in Settings before managing inventory.</p>;
  }

  if (loading) {
    return <p className="panel">Loading inventory...</p>;
  }

  if (!shops.length) {
    return <p className="panel">No shops are connected to this seller yet. Create one first from the setup flow.</p>;
  }

  return (
    <section className="page">
      <div className="page-header">
        <div>
          <p className="eyebrow">Inventory</p>
          <h2>Manage products from the React app</h2>
        </div>
      </div>

      <div className="two-column-grid">
        <form className="panel form-panel" onSubmit={handleSubmit}>
          <h3>Add a product</h3>
          <label>
            Shop
            <select
              value={form.shop_id}
              onChange={(event) => setForm({ ...form, shop_id: event.target.value })}
              required
            >
              {shops.map((shop) => (
                <option key={shop.id} value={shop.id}>
                  {shop.name}
                </option>
              ))}
            </select>
          </label>
          <label>
            Name
            <input
              value={form.name}
              onChange={(event) => setForm({ ...form, name: event.target.value })}
              required
            />
          </label>
          <label>
            Description
            <textarea
              rows="3"
              value={form.description}
              onChange={(event) => setForm({ ...form, description: event.target.value })}
            />
          </label>
          <label>
            Price
            <input
              type="number"
              min="0"
              step="0.01"
              value={form.price}
              onChange={(event) => setForm({ ...form, price: event.target.value })}
              required
            />
          </label>
          <label>
            Stock quantity
            <input
              type="number"
              min="0"
              step="1"
              value={form.stock_quantity}
              onChange={(event) => setForm({ ...form, stock_quantity: event.target.value })}
              required
            />
          </label>

          <button className="primary-button" type="submit" disabled={saving}>
            {saving ? 'Saving...' : 'Create product'}
          </button>
          {feedback ? <p className={feedback.includes('successfully') ? 'success' : 'error'}>{feedback}</p> : null}
        </form>

        <section className="panel">
          <h3>Current catalog</h3>
          <div className="list-grid">
            {products.map((product) => (
              <article key={product.id} className="list-card">
                <div className="spread">
                  <h4>{product.name}</h4>
                  <strong>{formatCurrency(product.price)}</strong>
                </div>
                <p className="muted">{product.description || 'No description yet.'}</p>
                <p className="muted">Stock: {product.stock_quantity}</p>
              </article>
            ))}
          </div>
        </section>
      </div>
    </section>
  );
}

export default InventoryPage;
