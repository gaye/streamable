source 'http://rubygems.org'

gem 'aws-s3'
gem 'aws-sdk'
gem 'capybara'
gem 'ci_reporter'
gem 'hirefireapp'
gem 'json'
gem 'jquery-rails'
gem 'omniauth-facebook'
gem 'paperclip', '~> 2.7'
gem 'pg'
gem 'rails', '3.2.3'
gem 'rspec'
gem 'rspec-rails'
gem 'thin'

# allows us to move data from the db to a yaml file and back
# rake db:data:dump   ->   Dump contents of Rails database to db/data.yml
# rake db:data:load   ->   Load contents of db/data.yml into the database
gem 'yaml_db', :git => 'git://github.com/lostapathy/yaml_db.git'

group :test do
  gem 'therubyracer'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end
