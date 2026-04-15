import React from 'react';

function StatCard({ label, value, hint }) {
  return (
    <section className="stat-card">
      <p className="stat-label">{label}</p>
      <strong className="stat-value">{value}</strong>
      {hint ? <p className="muted">{hint}</p> : null}
    </section>
  );
}

export default StatCard;
