const BASE_URL = import.meta.env.VITE_API_URL;

async function apiFetch(path, options = {}) {
    const url = `${BASE_URL}${path}`;
    
    //the ngrok skip header
    const headers = {
      ...options.headers,
      "ngrok-skip-browser-warning": "true", 
      "Accept": "application/json",
    };
  
    return fetch(url, { ...options, headers });
  }

export async function fetchUsers() {
  const res = await apiFetch("/users");
  if (!res.ok) throw new Error("Failed to fetch users");
  return res.json();
}