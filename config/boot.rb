ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
# Ensure stdlib logger is loaded before Rails or gems
require 'rubygems'
require 'logger'

require 'bundler/setup' # Set up gems listed in the Gemfile.
