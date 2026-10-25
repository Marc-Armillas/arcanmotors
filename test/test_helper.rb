ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Fixture blobs (test/fixtures/active_storage) read their files from test/fixtures/files
    ActiveStorage::FixtureSet.file_fixture_path = File.expand_path("fixtures/files", __dir__)
  end
end
