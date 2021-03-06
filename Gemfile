# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap-sass'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'dotenv-rails'
gem 'jbuilder', '~> 2.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.4'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# jquery
gem 'jquery-rails'
# jquery ui
gem 'jquery-ui-rails'
# サンプルユーザー
gem 'faker'
# 画像投稿
gem 'carrierwave'
# 画像リサイズ
gem 'mini_magick'
# ページネーション
gem 'kaminari'
# 動的な入力フォーム
gem 'nested_form_fields'
# fontawesome
gem 'font-awesome-sass'
# 国選択
gem 'countries'
gem 'country_select', require: 'country_select_without_sort_alphabetical'
# PDF書きだし
gem 'wkhtmltopdf-binary'
gem 'wicked_pdf'
# 検索
gem 'ransack'
# N+1検出
gem 'bullet'

group :development, :test do
  gem 'byebug', platforms: %i(mri mingw x64_mingw)
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop-airbnb'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'webdriver'
end

group :production, :staging do
  gem 'unicorn'
end

group :production do
  gem 'fog-aws'
end

gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
