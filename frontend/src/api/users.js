const BASE_URL = "https://nam-labradoritic-tawanna.ngrok-free.dev";

async function apiFetch(path, options = {}) {
  const url = `${BASE_URL}${path}`;
  const finalUrl = url.includes("?")
    ? `${url}&ngrok-skip-browser-warning=true`
    : `${url}?ngrok-skip-browser-warning=true`;

  return fetch(finalUrl, options);
}

export async function fetchUsers() {
  const res = await apiFetch("/users");
  if (!res.ok) throw new Error("Failed to fetch users");
  return res.json();
}