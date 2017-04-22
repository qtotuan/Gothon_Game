ENV['RACK_ENV'] = 'env'

require_relative './../bin/app.rb'
require 'test/unit'
require 'rack/test'

class HelloWorldTest < Test::Unit::TestCase

  def test_it_says_hello_world
    browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    browser.get '/'
    browser.follow_redirect!
    assert browser.last_response.ok?
    assert browser.last_response.body.include?('The Gothons of Planet Percal #25')
  end

  def test_central_corridor
    browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    browser.get '/game', {}, [:room] => "CENTRAL_CORRIDOR"
    browser.request('/game', env = { :room => 'CENTRAL CORRIDOR' })
    assert browser.last_response.ok?
    assert browser.last_response.body.include?('You died')
  end
end



# ENV['RACK_ENV'] = 'test'
#
# require_relative './../bin/app.rb'
# require 'test/unit'
# require 'rack/test'
#
# class MyAppTest < Test::Unit::TestCase
#   include Rack::Test::Methods
#
#   def app
#     Sinatra::Application
#   end
#
#   def test_default
#     get '/'
#     follow_redirect!
#
#     assert last_response.ok?
#     assert_equal last_request.session[:room], "START"
#   end
#
#   def test_death
#     get '/game'
#     room = nil
#     assert last_response.ok?
#     assert last_response.body.include?('You died')
#   end
#
#   def test_central_corridor
#
#     get '/game', {}, env['rack.session'][]="Hello Rack"
#
#     assert last_response.ok?
#     assert last_response.body.include?('You died')
#   end
# end
