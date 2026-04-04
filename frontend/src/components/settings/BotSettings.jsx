import React from 'react';
import { useTranslation } from 'react-i18next';
import axios from 'axios';

const BotSettings = () => {
  const { t, i18n } = useTranslation();

  const languages = [
    { code: 'en', name: 'English', flag: 'US' },
    { code: 'am', name: 'Amharic', flag: 'ET' }
  ];

  const changeLanguage = async (lng) => {
    i18n.changeLanguage(lng);

    try {
      await axios.patch('http://localhost:3000/api/v1/shop/settings', {
        locale: lng
      });
      alert(t('settings.success_message'));
    } catch (error) {
      console.error('Failed to update language on server', error);
    }
  };

  return (
    <div className="p-6 bg-white rounded-lg shadow-md">
      <h2 className="text-2xl font-bold mb-4">{t('sidebar.settings')}</h2>

      <div className="space-y-4">
        <label className="block text-sm font-medium text-gray-700">
          {t('settings.select_language')}
        </label>

        <div className="grid grid-cols-2 gap-4">
          {languages.map((lang) => (
            <button
              key={lang.code}
              onClick={() => changeLanguage(lang.code)}
              className={`flex items-center justify-center p-4 border rounded-lg hover:bg-blue-50 transition-colors ${
                i18n.language === lang.code ? 'border-blue-500 bg-blue-50' : 'border-gray-200'
              }`}
            >
              <span className="mr-2 text-xl">{lang.flag}</span>
              <span className="font-semibold">{lang.name}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default BotSettings;
