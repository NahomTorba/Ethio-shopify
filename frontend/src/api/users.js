export async function fetchUsers() {
  const res = await fetch("http://127.0.0.1:3000/users");
  if (!res.ok) throw new Error("Failed to fetch users");
  return res.json();
}