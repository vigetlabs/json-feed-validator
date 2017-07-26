ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require File.expand_path '../../app.rb', __FILE__

class JsonFeedValidatorTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_valid_feed
    post "/validate", data: File.read("test/files/valid.json")

    assert last_response.body.include?("This is a valid feed.")
  end

  def test_malformed_json
    post "/validate", data: File.read("test/files/malformed.json")

    assert last_response.body.include?("Errors:")
    assert last_response.body.include?("unexpected token")
  end

  def test_invalid_feed
    post "/validate", data: File.read("test/files/invalid.json")

    assert last_response.body.include?("Errors:")
    assert last_response.body.include?("did not contain a required property")
  end
end
