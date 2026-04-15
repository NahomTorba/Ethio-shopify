import axios from 'axios';

export const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || 'http://localhost:3000';
const TOKEN_KEY = 'ethio_shopify_jwt';

const client = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
});

export function getAuthToken() {
  return window.localStorage.getItem(TOKEN_KEY) || '';
}

export function setAuthToken(token) {
  window.localStorage.setItem(TOKEN_KEY, token.trim());
}

export function clearAuthToken() {
  window.localStorage.removeItem(TOKEN_KEY);
}

export function hasAuthToken() {
  return getAuthToken().length > 0;
}

export function getAuthHeaders() {
  const token = getAuthToken();
  return token ? { Authorization: `Bearer ${token}` } : {};
}

export async function fetchSeller() {
  const response = await client.get('/api/v1/seller', { headers: getAuthHeaders() });
  return response.data.seller;
}

export async function fetchShops() {
  const response = await client.get('/api/v1/shops', { headers: getAuthHeaders() });
  return response.data.shops || [];
}

export async function fetchProducts() {
  const response = await client.get('/api/v1/products', { headers: getAuthHeaders() });
  return response.data.products || [];
}

export async function createProduct(payload) {
  const response = await client.post(
    '/api/v1/products',
    { product: payload },
    { headers: getAuthHeaders() }
  );

  return response.data.product;
}

export async function fetchOrders() {
  const response = await client.get('/api/v1/orders', { headers: getAuthHeaders() });
  return response.data.orders || [];
}

export async function fetchPublicShop(username) {
  const response = await client.get(`/api/v1/public/shops/${username}`);
  return response.data;
}

export async function createShopSetup(payload) {
  const response = await client.post('/api/v1/public/shop_setups', payload);
  return response.data;
}

export function getErrorMessage(error, fallback = 'Something went wrong.') {
  return (
    error?.response?.data?.error ||
    error?.response?.data?.errors?.join(', ') ||
    error?.message ||
    fallback
  );
}
