import React, { useEffect, useState } from 'react';
import { fetchOrders, getErrorMessage, hasAuthToken } from '../lib/api';
import { formatCurrency, formatDate } from '../lib/formatters';

function OrdersPage() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!hasAuthToken()) {
      setLoading(false);
      return;
    }

    async function loadOrders() {
      try {
        setOrders(await fetchOrders());
      } catch (loadError) {
        setError(getErrorMessage(loadError, 'Failed to load orders.'));
      } finally {
        setLoading(false);
      }
    }

    loadOrders();
  }, []);

  if (!hasAuthToken()) {
    return <p className="panel">Add your seller JWT in Settings before viewing orders.</p>;
  }

  if (loading) {
    return <p className="panel">Loading orders...</p>;
  }

  if (error) {
    return <p className="panel error">{error}</p>;
  }

  return (
    <section className="page">
      <div className="page-header">
        <div>
          <p className="eyebrow">Orders</p>
          <h2>Recent sales</h2>
        </div>
      </div>

      <section className="panel">
        <div className="list-grid">
          {orders.map((order) => (
            <article key={order.id} className="list-card">
              <div className="spread">
                <h3>{order.status || 'Pending'}</h3>
                <strong>{formatCurrency(order.total_price)}</strong>
              </div>
              <p className="muted">Telegram user: {order.telegram_user_id || 'Unknown'}</p>
              <p className="muted">Placed: {formatDate(order.created_at)}</p>
              <p className="muted">Reference: {order.payment_reference || 'Not recorded'}</p>
            </article>
          ))}
        </div>
      </section>
    </section>
  );
}

export default OrdersPage;
