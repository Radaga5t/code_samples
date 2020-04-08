require 'rubygems'
require 'sitemap_generator'

# TODO: обновление сайтмепа сразу после деплоя

SitemapGenerator::Sitemap.default_host = "#{ENV['PROTOCOL']}://#{ENV['HOST']}"
SitemapGenerator::Sitemap.create do
  # Список всех категорий
  add '/tasks/new', :changefreq => 'monthly', :priority => 0.5

  # Все формы создания заданий
  Category.where(depth_level: 0).pluck(:id).each do |root_category_id|
    Category.where(parent_id: root_category_id).pluck(:id).each do |child_category_id|
      add "/tasks/new/#{root_category_id}/#{child_category_id}", :changefreq => 'monthly', :priority => 0.5
    end
  end

  # Список всех заданий
  add '/tasks', :changefreq => 'daily', :priority => 1

  # Страницы заданий (только звершенные)
  Task.closed.pluck(:id).each do |task_id|
    add "/tasks/#{task_id}", :changefreq => 'daily', :priority => 0.8
  end

  # Все исполнители
  add '/executors', :changefreq => 'daily', :priority => 0.9

  # Все исполнители постранично (кроме тех, кто скрыл свои профили)
  User
    .includes(:translations)
    .executors
    .where('users.hidden_until is null OR users.hidden_until < ?', Time.current)
    .where('user_translations.about is not null AND length(user_translations.about) > 270')
    .pluck('users.id')
    .each do |user_id|
    add "/user/#{user_id}", :changefreq => 'daily', :priority => 0.8
  end

  # Все страницы фака
  ::Faq::Page.all.each do |page|
    add "/faq/#{page.path}", :changefreq => 'monthly', :priority => 0.25
  end

  # Список всех статей
  add '/blog/articles/', changefreq: 'daily', priority: 0.5

  # Все статьи постранично
  Blog::Article.where(published: true).pluck(:slug).each do |article_slug|
    add "/blog/articles/#{article_slug}", changefreq: 'daily', priority: 0.5
  end

  add '/info/contacts', :changefreq => 'monthly', :priority => 0.3
  add '/info/executor', :changefreq => 'monthly', :priority => 0.3
  add '/info/guarantees', :changefreq => 'monthly', :priority => 0.3
  add '/info/how-it-works', :changefreq => 'monthly', :priority => 0.3
  add '/info/privacy', :changefreq => 'monthly', :priority => 0.3
  add '/info/safety-deal', :changefreq => 'monthly', :priority => 0.3
  add '/info/subscriptions', :changefreq => 'monthly', :priority => 0.3
  add '/info/terms', :changefreq => 'monthly', :priority => 0.3
end
