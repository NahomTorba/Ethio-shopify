import { useState } from "react";
import { createShop } from "../api/shops";
export function useCreateShop() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [shop, setShop] = useState(null);
  const create = async (data) => {
    setLoading(true);
    setError(null);
    try {
      const result = await createShop(data);
      setShop(result);
      return result;
    } catch (err) {
      setError(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  };
  return { create, loading, error, shop };
}