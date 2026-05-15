import { useEffect } from "react";
import UsersPage from "./pages/usersPage";
import CreateBotPage from "./pages/createBotPage";

function App() {
  useEffect(() => {
    if (window.Telegram?.WebApp) {
      const tg = window.Telegram.WebApp;
      tg.ready();
      tg.expand();

      console.log("Telegram user:", tg.initDataUnsafe?.user);
    }
  }, []);

  return <CreateBotPage />
}

export default App;