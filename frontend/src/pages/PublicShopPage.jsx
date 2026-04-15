import React, { useEffect, useState } from 'react';
import { useParams, useSearchParams } from 'react-router-dom';
import ProductList from '../components/public/ProductList';
import { fetchPublicShop, getErrorMessage } from '../lib/api';

function PublicShopPage() {
  const { username } = useParams();
  const [searchParams] = useSearchParams();
  const [state, setState] = useState({
    loading: true,
    error: '',
    shop: null,
    products: []
  });

  useEffect(() => {
    async function loadShop() {
      try {
        const response = await fetchPublicShop(username);
        setState({
          loading: false,
          error: '',
          shop: response.shop,
          products: response.products || []
        });
      } catch (error) {
        setState({
          loading: false,
          error: getErrorMessage(error, 'Failed to load this shop.'),
          shop: null,
          products: []
        });
      }
    }

    loadShop();
  }, [username]);

  const mode = searchParams.get('mode') || 'customer';

  if (state.loading) {
    return <p className="public-shell">Loading shop...</p>;
  }

  if (state.error) {
    return <p className="public-shell error">{state.error}</p>;
  }

  return (
    <main className="public-shell">
      <section className="hero-card">
        <p className="eyebrow">{mode === 'owner' ? 'Owner view' : 'Customer view'}</p>
        <h1>{state.shop.name}</h1>
        <p className="muted">{state.shop.welcome_message || 'Welcome to the shop.'}</p>
      </section>

      <section className="panel">
        <div className="panel-header">
          <div>
            <p className="eyebrow">Catalog</p>
            <h2>Available products</h2>
          </div>
        </div>
        <ProductList products={state.products} />
      </section>
    </main>
  );
}

export default PublicShopPage;
