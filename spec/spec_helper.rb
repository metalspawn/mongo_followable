ENV["RACK_ENV"] = 'test' # Forcing test environment needed before loading mongoid.yml

require "rubygems"
require "bundler/setup"

require "database_cleaner"
require "rspec"

CONFIG = { :authorization => true, :history => true }

if rand > 0.5
  puts 'Mongoid'
  require 'mongoid'
  require File.expand_path("../../lib/mongo_followable", __FILE__)
  require File.expand_path("../mongoid/user", __FILE__)
  require File.expand_path("../mongoid/group", __FILE__)
  require File.expand_path("../mongoid/childuser", __FILE__)
  if MongoFollowable.mongoid2?
    Mongoid.load!(File.expand_path("../mongoid2.yml", __FILE__))
  else
    Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))
  end
else
  puts 'MongoMapper'
  require 'mongo_mapper'
  require File.expand_path("../../lib/mongo_followable", __FILE__)
  require File.expand_path("../mongo_mapper/user", __FILE__)
  require File.expand_path("../mongo_mapper/group", __FILE__)
  require File.expand_path("../mongo_mapper/childuser", __FILE__)
  MongoMapper.database = 'mongo_followable_test'
end

RSpec.configure do |c|
  c.before(:all)  { DatabaseCleaner.strategy = :truncation }
  c.before(:each) { DatabaseCleaner.clean }
end
