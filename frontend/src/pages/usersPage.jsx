import React from "react";
import { useUsers } from "../hooks/useUsers";

export default function UsersPage() {
  const { users, loadUsers } = useUsers();

  return (
    <div>
      <h2>Users</h2>
      <button onClick={loadUsers}>Get Users</button>

      {users.map(user => (
        <div key={user.id}>
          <strong>{user.name}</strong>
          <p>{user.email}</p>
        </div>
      ))}
    </div>
  );
}
