require "sinatra/activerecord/rake"

# Rakefile
APP_FILE  = './app.rb'
APP_CLASS = 'SmWorkflowLims'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :spec => %w[db:create db:test:prepare]
rescue LoadError
end

require 'sinatra/assetpack/rake'

task :default => :test

task :test => :spec

namespace :db do
  task :load_config do
    require "./app"
  end
end

namespace :build do
  task :manifest do
    puts "Building manifest!"
    File.open('./app/manifest.rb','w') do |file|
      `git ls-files app | grep -e [\.]rb`.split.each do |req|
        next if req == 'app/manifest.rb'
        file.puts "require './#{req.gsub(/\.rb$/,'')}'"
        print '.'
      end
    end
    puts '.'
    puts 'Manifest Built:'
    puts `cat ./app/manifest.rb`
  end

  task :assets => ['assetpack:build'] do
    `cp -r $(bundle show bootstrap-sass)/vendor/assets/fonts/bootstrap public/assets/stylesheets/`
  end
end

require './lib/tasks/update_old_assets'