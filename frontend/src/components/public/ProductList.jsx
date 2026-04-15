import React from 'react';
import { formatCurrency } from '../../lib/formatters';

function ProductList({ products }) {
  if (!products.length) {
    return <p className="empty-state">No products have been published yet.</p>;
  }

  return (
    <div className="product-grid">
      {products.map((product) => (
        <article key={product.id} className="product-card">
          <div>
            <h3>{product.name}</h3>
            <p className="muted">{product.description || 'No description yet.'}</p>
          </div>
          <div className="product-meta">
            <strong>{formatCurrency(product.price)}</strong>
            <span>Stock: {product.stock_quantity}</span>
          </div>
        </article>
      ))}
    </div>
  );
}

export default ProductList;
