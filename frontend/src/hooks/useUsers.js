import { useState } from "react";
import { fetchUsers } from "../api/users";

export function useUsers() {
  const [users, setUsers] = useState([]);

  const loadUsers = async () => {
    const data = await fetchUsers();
    setUsers(data);
  };

  return { users, loadUsers };
}
