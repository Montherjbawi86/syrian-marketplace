source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 7.0.10'
# Remove pg from here - it should only be in production!
# gem 'pg', '~> 1.1'  ← DELETE THIS LINE
gem 'puma', '~> 5.0'
gem 'sassc-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false

# Authentication
gem 'devise', '~> 4.9'

# Frontend
gem 'bootstrap', '~> 5.3.2'
gem 'font-awesome-rails'
gem 'jquery-rails'

# I18n
gem 'rails-i18n', '~> 7.0.0'

# Pagination
gem 'kaminari'

# Search
gem 'ransack'

# File Upload
gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'debug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3', '~> 1.4'  # SQLite for development and testing
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :production do
  gem 'pg', '~> 1.5'        # PostgreSQL for production (Render/Neon)
  gem 'rails_12factor'      # Helps with asset serving and logging
end
