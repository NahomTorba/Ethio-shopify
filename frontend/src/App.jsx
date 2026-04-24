import { useEffect } from "react";
import UsersPage from "./pages/usersPage";

function App() {
  useEffect(() => {
    if (window.Telegram?.WebApp) {
      const tg = window.Telegram.WebApp;
      tg.ready();
      tg.expand();

      console.log("Telegram user:", tg.initDataUnsafe?.user);
    }
  }, []);

  return <UsersPage />;
}

export default App;