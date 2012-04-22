source 'http://rubygems.org'

gem 'aws-s3'
gem 'aws-sdk'
gem 'ci_reporter'
gem 'json'
gem 'jquery-rails'
gem 'omniauth-facebook'
gem 'paperclip', '~> 2.7'
gem 'rails', '3.2.3'

# allows us to move data from the db to a yaml file and back
# rake db:data:dump   ->   Dump contents of Rails database to db/data.yml
# rake db:data:load   ->   Load contents of db/data.yml into the database
gem 'yaml_db'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'thin'
end

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end
