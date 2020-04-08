unless Language.exists?
  languages = [
    {
      native_name: 'Magyar',
      name_ru: 'Венгерский',
      name_en: 'Hungarian',
      name_hu: 'Magyar',
      code: 'hu'
    },
    {
      native_name: 'English',
      name_ru: 'Английский',
      name_en: 'English',
      name_hu: 'Angol',
      code: 'en'
    },
    {
      native_name: 'Azərbaycan',
      name_ru: 'Азербайджанский',
      name_en: 'Azerbaijani',
      name_hu: 'Azerbajdzsáni',
      code: 'az'
    },
    {
      native_name: 'Български',
      name_ru: 'Болгарский',
      name_en: 'Bulgarian',
      name_hu: 'Bolgár',
      code: 'bg'
    },
    {
      native_name: 'Čeština',
      name_ru: 'Чешский',
      name_en: 'Czech',
      name_hu: 'Cseh',
      code: 'cs'
    },
    {
      native_name: 'Dansk',
      name_ru: 'Датский',
      name_en: 'Danish',
      name_hu: 'Dán',
      code: 'da'
    },
    {
      native_name: 'Eesti',
      name_ru: 'Эстонский',
      name_en: 'Estonian',
      name_hu: 'Észt',
      code: 'et'
    },
    {
      native_name: 'Suomi',
      name_ru: 'Финский',
      name_en: 'Finnish',
      name_hu: 'Finn',
      code: 'fi'
    },
    {
      native_name: 'Français',
      name_ru: 'Французский',
      name_en: 'French',
      name_hu: 'Francia',
      code: 'fr'
    },
    {
      native_name: 'Eλληνικά',
      name_ru: 'Греческий',
      name_en: 'Greek',
      name_hu: 'Görög',
      code: 'el'
    },
    {
      native_name: 'हिन्दी',
      name_ru: 'Хинди',
      name_en: 'Hindi',
      name_hu: 'Hindi',
      code: 'hi'
    },
    {
      native_name: 'Nederlands',
      name_ru: 'Нидерландский',
      name_en: 'Dutch',
      name_hu: 'Holland',
      code: 'nl'
    },
    {
      native_name: 'Hrvatski',
      name_ru: 'Хорватский',
      name_en: 'Croatian',
      name_hu: 'Horvát',
      code: 'hr'
    },
    {
      native_name: 'Gaeilge',
      name_ru: 'Ирландский',
      name_en: 'Irish',
      name_hu: 'Ír',
      code: 'ga'
    },
    {
      native_name: 'ქართული',
      name_ru: 'Грузинский',
      name_en: 'Georgian',
      name_hu: 'Grúz',
      code: 'ka'
    },
    {
      native_name: '日本語',
      name_ru: 'Японский',
      name_en: 'Japanese',
      name_hu: 'Japán',
      code: 'ja'
    },
    {
      native_name: '中文',
      name_ru: 'Китайский',
      name_en: 'Chinese',
      name_hu: 'Kínai',
      code: 'zh'
    },
    {
      native_name: '한국어 [韓國語]',
      name_ru: 'Корейский',
      name_en: 'Chinese',
      name_hu: 'Koreai',
      code: 'ko'
    },
    {
      native_name: 'Polski',
      name_ru: 'Польский',
      name_en: 'Polish',
      name_hu: 'Lengyel',
      code: 'ko'
    },
    {
      native_name: 'Latviešu',
      name_ru: 'Латышский',
      name_en: 'Latvian',
      name_hu: 'Lett',
      code: 'lv'
    },
    {
      native_name: 'Lietuvių',
      name_ru: 'Литовский',
      name_en: 'Lithuanian',
      name_hu: 'Litván',
      code: 'lt'
    },
    {
      native_name: 'Malti',
      name_ru: 'Мальтийский',
      name_en: 'Maltese',
      name_hu: 'Máltai',
      code: 'lt'
    },
    {
      native_name: 'Deutsch',
      name_ru: 'Немецкий',
      name_en: 'German',
      name_hu: 'Német',
      code: 'de'
    },
    {
      native_name: 'Norsk',
      name_ru: 'Норвежский',
      name_en: 'Norwegian',
      name_hu: 'Norvég',
      code: 'nn'
    },
    {
      native_name: 'Italiano',
      name_ru: 'Итальянский',
      name_en: 'Italian',
      name_hu: 'Olasz',
      code: 'it'
    },
    {
      native_name: 'Русский',
      name_ru: 'Русский',
      name_en: 'Russian',
      name_hu: 'Orosz',
      code: 'ru'
    },
    {
      native_name: 'Português',
      name_ru: 'Португальский',
      name_en: 'Portuguese',
      name_hu: 'Portugál',
      code: 'pt'
    },
    {
      native_name: 'Română',
      name_ru: 'Румынский',
      name_en: 'Portuguese',
      name_hu: 'Román',
      code: 'ro'
    },
    {
      native_name: 'Español',
      name_ru: 'Испанский',
      name_en: 'Spanish',
      name_hu: 'Spanyol',
      code: 'es'
    },
    {
      native_name: 'Svenska',
      name_ru: 'Шведский',
      name_en: 'Swedish',
      name_hu: 'Svéd',
      code: 'sv'
    },
    {
      native_name: 'Српски',
      name_ru: 'Сербский',
      name_en: 'Swedish',
      name_hu: 'Serbian',
      code: 'sr'
    },
    {
      native_name: 'Slovak',
      name_ru: 'Словацкий',
      name_en: 'Slovak',
      name_hu: 'Szlovák',
      code: 'sk'
    },
    {
      native_name: 'Slovenščina',
      name_ru: 'Словенский',
      name_en: 'Slovenian',
      name_hu: 'Szlovén',
      code: 'sl'
    },
    {
      native_name: 'Türkçe',
      name_ru: 'Tурецкий',
      name_en: 'Turkish',
      name_hu: 'Török',
      code: 'tr'
    },
    {
      native_name: 'Українська',
      name_ru: 'Украинский',
      name_en: 'Ukrainian',
      name_hu: 'Ukrán',
      code: 'uk'
    }
  ]

  languages.each do |language|
    Language.create(language)
  end
end
