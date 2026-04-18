import React, { useState } from 'react';

// Simple setup form component
function SetupShop() {
  const [shopName, setShopName] = useState('');
  const [shopUsername, setShopUsername] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    
    const params = new URLSearchParams(window.location.search);
    const userId = params.get('user_id');
    
    try {
      const response = await fetch('/api/v1/shops/setup', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          shop: { name: shopName, username: shopUsername },
          user_id: userId
        })
      });
      
      if (response.ok) {
        alert('Shop created successfully!');
      }
    } catch (error) {
      console.error(error);
    }
    setLoading(false);
  };

  return (
    <div style={{ padding: '20px', maxWidth: '400px', margin: '0 auto' }}>
      <h1>Create Your Shop</h1>
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: '15px' }}>
          <label>Shop Name</label><br/>
          <input
            type="text"
            value={shopName}
            onChange={(e) => setShopName(e.target.value)}
            required
            style={{ width: '100%', padding: '8px', marginTop: '5px' }}
          />
        </div>
        <div style={{ marginBottom: '15px' }}>
          <label>Username (for bot)</label><br/>
          <input
            type="text"
            value={shopUsername}
            onChange={(e) => setShopUsername(e.target.value)}
            placeholder="my_shop_bot"
            required
            style={{ width: '100%', padding: '8px', marginTop: '5px' }}
          />
        </div>
        <button type="submit" disabled={loading} style={{ padding: '10px 20px', background: '#007bff', color: 'white', border: 'none', cursor: 'pointer' }}>
          {loading ? 'Creating...' : 'Create Shop'}
        </button>
      </form>
    </div>
  );
}

function App() {
  const [page, setPage] = useState('dashboard');
  
  if (window.location.pathname.includes('setup-shop')) {
    return <SetupShop />;
  }

  return (
    <div style={{ display: 'flex', minHeight: '100vh' }}>
      <div style={{ width: '200px', background: '#333', color: 'white', padding: '20px' }}>
        <h2>Ethio Shopify</h2>
        <ul style={{ listStyle: 'none', padding: 0 }}>
          <li style={{ padding: '10px', cursor: 'pointer' }} onClick={() => setPage('dashboard')}>Dashboard</li>
          <li style={{ padding: '10px', cursor: 'pointer' }} onClick={() => setPage('products')}>Products</li>
          <li style={{ padding: '10px', cursor: 'pointer' }} onClick={() => setPage('orders')}>Orders</li>
          <li style={{ padding: '10px', cursor: 'pointer' }} onClick={() => setPage('settings')}>Settings</li>
        </ul>
      </div>
      
      <div style={{ flex: 1, padding: '20px' }}>
        {page === 'dashboard' && <h1>Dashboard</h1>}
        {page === 'products' && <h1>Products</h1>}
        {page === 'orders' && <h1>Orders</h1>}
        {page === 'settings' && <h1>Settings</h1>}
      </div>
    </div>
  );
}

export default App;