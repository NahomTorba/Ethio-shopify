import React, { useEffect, useState } from 'react';
import StatCard from '../components/dashboard/StatCard';
import { fetchOrders, fetchProducts, fetchSeller, fetchShops, getErrorMessage, hasAuthToken } from '../lib/api';
import { formatCurrency } from '../lib/formatters';

function DashboardPage() {
  const [state, setState] = useState({
    loading: true,
    error: '',
    seller: null,
    shops: [],
    products: [],
    orders: []
  });

  useEffect(() => {
    if (!hasAuthToken()) {
      setState((current) => ({ ...current, loading: false }));
      return;
    }

    async function loadData() {
      try {
        const [seller, shops, products, orders] = await Promise.all([
          fetchSeller(),
          fetchShops(),
          fetchProducts(),
          fetchOrders()
        ]);

        setState({
          loading: false,
          error: '',
          seller,
          shops,
          products,
          orders
        });
      } catch (error) {
        setState((current) => ({
          ...current,
          loading: false,
          error: getErrorMessage(error, 'Failed to load seller dashboard.')
        }));
      }
    }

    loadData();
  }, []);

  if (!hasAuthToken()) {
    return (
      <section className="page">
        <div className="page-header">
          <div>
            <p className="eyebrow">Dashboard</p>
            <h2>Connect your seller token</h2>
          </div>
        </div>
        <p className="panel">
          Save the JWT from the Rails `/auth/sign_in` response in Settings to unlock shop, inventory, and order data.
        </p>
      </section>
    );
  }

  if (state.loading) {
    return <p className="panel">Loading dashboard...</p>;
  }

  if (state.error) {
    return <p className="panel error">{state.error}</p>;
  }

  const totalSales = state.orders.reduce((sum, order) => sum + Number(order.total_price || 0), 0);

  return (
    <section className="page">
      <div className="page-header">
        <div>
          <p className="eyebrow">Dashboard</p>
          <h2>{state.seller?.name || 'Seller overview'}</h2>
        </div>
      </div>

      <div className="stats-grid">
        <StatCard label="Shops" value={state.shops.length} hint="Stores tied to your account" />
        <StatCard label="Products" value={state.products.length} hint="Active catalog entries" />
        <StatCard label="Orders" value={state.orders.length} hint="Orders from your shops" />
        <StatCard label="Revenue" value={formatCurrency(totalSales)} hint="Based on order totals" />
      </div>

      <section className="panel">
        <div className="panel-header">
          <div>
            <p className="eyebrow">Shops</p>
            <h3>Your current storefronts</h3>
          </div>
        </div>
        <div className="list-grid">
          {state.shops.map((shop) => (
            <article key={shop.id} className="list-card">
              <h4>{shop.name}</h4>
              <p className="muted">@{shop.username || 'pending-username'}</p>
            </article>
          ))}
        </div>
      </section>
    </section>
  );
}

export default DashboardPage;
