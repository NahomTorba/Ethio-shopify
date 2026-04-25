const BASE_URL = "https://nam-labradoritic-tawanna.ngrok-free.dev";

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