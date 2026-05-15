import React, { useState } from "react";
import { useCreateShop } from "../hooks/useCreateShop";
export default function CreateBotPage() {
  const [name, setName] = useState("");
  const [token, setToken] = useState("");
  const { create, loading, error, shop } = useCreateShop();
  const handleCreate = async () => {
    if (!name.trim() || !token.trim()) return;
    await create({
      name: name.trim(),
      telegram_bot_token: token.trim(),
    });
    setName("");
    setToken("");
  };
  return (
    <div>
      <h2>Create Bot</h2>
      <input
        type="text"
        placeholder="Enter Shop Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
      <br />
      <input
        type="text"
        placeholder="Enter Telegram Bot Token"
        value={token}
        onChange={(e) => setToken(e.target.value)}
      />
      <br />
      <button onClick={handleCreate} disabled={loading || !name.trim() || !token.trim()}>
        {loading ? "Creating..." : "Create Bot"}
      </button>
      {error && <p style={{ color: "red" }}>{error}</p>}
      {shop && <p style={{ color: "green" }}>Bot created! Token saved.</p>}
    </div>
  );
}