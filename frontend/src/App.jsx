import { useEffect } from "react";

function App() {
  useEffect(() => {
    if (window.Telegram?.WebApp) {
      const tg = window.Telegram.WebApp;
      tg.ready();
      tg.expand();

      console.log("Telegram user:", tg.initDataUnsafe?.user);
    }
  }, []);

  return <h1>Users App</h1>;
}

export default App;