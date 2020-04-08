unless Faq::Category.exists?
  categories = [
    {
      title_ru: 'Безопасность',
      title_hu: 'БезопасностьHU',
      title_en: 'Safety',
      personal_color: '#f5acac',
      children: [
        {
          title_ru: 'Сделка без риска',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Проверки на сервисе',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Советы исполнителям',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Советы заказчикам',
          title_hu: '',
          title_en: '',
        }
      ]
    },
    {
      title_ru: 'Общие вопросы',
      title_hu: 'Общие вопросыHU',
      title_en: 'Common questions',
      personal_color: '#f5acac',
      children: [
        {
          title_ru: 'Мой аккаунт',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Общение на сайте',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Спорные ситуации',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Приложение YouDo',
          title_hu: '',
          title_en: '',
        }
      ]
    },
    {
      title_ru: 'Для исполнителей',
      title_hu: 'Для исполнителейHU',
      title_en: 'For executors',
      personal_color: '#7ed0b8',
      children: [
        {
          title_ru: 'Начало работы',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Профиль',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Предложения',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Счет',
          title_hu: '',
          title_en: '',
        }
      ]
    },
    {
      title_ru: 'Для заказчиков',
      title_hu: 'Для заказчиковHU',
      title_en: 'For customers',
      personal_color: '#7ed0b8',
      children: [
        {
          title_ru: 'Задания',
          title_hu: '',
          title_en: '',
        },
        {
          title_ru: 'Исполнители',
          title_hu: '',
          title_en: '',
        }
      ]
    }
  ]

  categories.each do |category|
    cat = Faq::Category.create(category.without(:children))
    if category[:children].present? && cat.valid?
      category[:children].each do |child|
        cat.children.create(child)
      end
    end
  end
end