ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "simplecov"

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    setup do
      Mongoid.purge!
    end

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
    SimpleCov.start
  end
end
