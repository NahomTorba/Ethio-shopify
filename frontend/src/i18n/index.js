import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import LanguageDetector from "i18next-browser-languagedetector";

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      en: {
        translation: {
          welcome: "Welcome to EthioShopify Admin",
          sidebar: {
            dashboard: "Dashboard",
            products: "Products",
            orders: "Orders",
            settings: "Settings"
          },
          stats: {
            total_sales: "Total Sales",
            active_shops: "Active Shops"
          }
        }
      },
      am: {
        translation: {
          welcome: "Welcome to EthioShopify Admin",
          sidebar: {
            dashboard: "Dashboard",
            products: "Products",
            orders: "Orders",
            settings: "Settings"
          },
          stats: {
            total_sales: "Total Sales",
            active_shops: "Active Shops"
          }
        }
      }
    },
    fallbackLng: "en",
    interpolation: {
      escapeValue: false
    }
  });

export default i18n;
