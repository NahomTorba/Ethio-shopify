import React from 'react';
import { Link } from 'react-router-dom';

function NotFoundPage() {
  return (
    <main className="public-shell">
      <section className="hero-card">
        <p className="eyebrow">404</p>
        <h1>Page not found</h1>
        <p className="muted">The route exists nowhere in the restructured frontend.</p>
        <Link className="primary-button inline-button" to="/dashboard">
          Back to dashboard
        </Link>
      </section>
    </main>
  );
}

export default NotFoundPage;
