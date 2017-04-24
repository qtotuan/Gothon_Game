require 'sinatra'
require './lib/Gothon_Game/map.rb'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"
enable :sessions
set :session_secret, 'BADSECRET'

get '/' do
    cache_control :public
    session[:guess] = 0
    session[:room] = 'START'
    redirect to('/game')
end

get '/game' do
    room = Map::load_room(session)

    if room
        erb :show_room, :locals => {:room => room}
    else
        erb :you_died
    end
end


post '/game' do
    room = Map::load_room(session)
    action = params[:action]

    if room == Map::LASER_WEAPON_ARMORY || room == Map::WRONG_GUESS
      if action != '5' && session[:guess] < 2
        session[:guess] += 1
        session[:room] = 'WRONG_GUESS'
        redirect to('/game')
      end
    end

    if room
        next_room = room.go(action) || room.go("*")

        if next_room
            Map::save_room(session, next_room)
        end

        redirect to('/game')
    # else
    #     erb :you_died
    end

end

get '/inspect' do
  "#{session.inspect}"
end
