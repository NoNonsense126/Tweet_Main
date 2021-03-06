# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'

require 'uri'
require 'pathname'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?

require 'erb'
require 'omniauth-twitter'
require 'twitter'
require 'yaml'
require 'sidekiq'
require 'sidekiq/api'
require 'redis'
require 'byebug'


# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')
TWITTER  = Dir[APP_ROOT.join('config','twitter_oauth.yml')][0]
APP_KEY = YAML.load_file(TWITTER)
# APP_KEY = {}
# APP_KEY["consumer_key"] = ENV['CONSUMER_KEY']
# APP_KEY["consumer_secret"] = ENV['CONSUMER_SECRET']


use OmniAuth::Builder do
  provider :twitter, APP_KEY["consumer_key"], APP_KEY["consumer_secret"]
end