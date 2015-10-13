require 'rubygems'
require 'bundler/setup'

require 'pry'
require "lemonway"
require 'webmock/rspec'


module Helpers
  def fixture_file(name, dir_name="responses")
    File.read File.join(File.expand_path(File.dirname(__FILE__)), "fixtures", dir_name, name)
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.include Helpers
end