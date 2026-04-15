import React from 'react';
import { useTranslation } from 'react-i18next';

const languages = [
  { code: 'en', label: 'English' },
  { code: 'am', label: 'አማርኛ' }
];

function LanguageSwitcher() {
  const { i18n, t } = useTranslation();

  return (
    <section className="panel">
      <div className="panel-header">
        <div>
          <p className="eyebrow">{t('settings.languageLabel')}</p>
          <h2>{t('settings.languageTitle')}</h2>
        </div>
      </div>

      <div className="button-row">
        {languages.map((language) => (
          <button
            key={language.code}
            type="button"
            className={`ghost-button${i18n.language === language.code ? ' active' : ''}`}
            onClick={() => i18n.changeLanguage(language.code)}
          >
            {language.label}
          </button>
        ))}
      </div>
    </section>
  );
}

export default LanguageSwitcher;
