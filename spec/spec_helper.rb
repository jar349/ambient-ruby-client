# frozen_string_literal: true

require "rspec"
require "simplecov"
require "simplecov-erb"
require "simplecov-html"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Note: If SimpleCov starts after your application code is already loaded (via require), it won't be able to track your
# files and their coverage! The SimpleCov.start must be issued before any of your application code is required!
SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::ERBFormatter
]

SimpleCov.start do
  # don't show specs as missing coverage for themselves
  add_filter "/spec/"

  # don't analyze coverage for gems
  add_filter "/vendor/gems/"
end

# with SimpleCov configured and started, we can require the gem code
require "ambient"
