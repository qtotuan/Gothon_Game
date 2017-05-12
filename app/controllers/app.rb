require 'sinatra'
require './lib/Gothon_Game/map.rb'
require 'sinatra/activerecord'


class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }



    set :port, 8080
    set :static, true
    set :public_folder, "static"
    set :views, "views"
    enable :sessions
    set :session_secret, 'BADSECRET'


  get '/' do
    erb :welcome
  end

  get '/start' do
    session[:guess] = 0
    session[:room] = 'START'
    redirect to('/game')
  end

  get '/game' do
      room = Map::load_room(session)
      session[:check] = room.to_s

      if room == Map::THE_END_WINNER
        erb :you_won
      elsif room
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

  get '/registrations/signup' do

    erb :signup
  end

  post '/registrations' do
    puts params
    @user = User.create(name: params["name"], email: params["email"], password: params["password"])
    # puts "Let's see if the user was stored in the databse! =>" + @user.inspect
    erb :welcome_user
  end

  get '/sessions/login' do

    erb :login
  end


  post '/sessions' do
    # puts params
    @user = User.find_by(email: params["email"], password: params["password"])
    if @user
      session[:id] = @user.id
      erb :welcome_user
    else
      @error_message = "Login credentials are incorrect. Please try again."
      erb :login
    end
  end

  get '/sessions/logout' do
    session.clear
    erb :logout
  end

  get '/admin' do
    @users = User.all
    puts @users.inspect
    erb :admin
  end

  get '/edit/:id' do
    id = params[:id]
    @user = User.find(id)
    erb :edit
  end

  post '/edit/:id' do
    id = params['id']
    @user = User.find(id)
    @user.update(name: params['name'], email: params['email'], password: params['password'])
    redirect to '/admin'
  end

  get '/all' do
    puts User.all.inspect
  end

  get '/delete/:id' do
    id = params[:id]
    @user = User.find(id)
    @user.destroy
    redirect to '/admin'
  end

  get '/new' do
    erb :new
  end

  post '/new' do
    puts params
    User.create(name: params['name'], email: params['email'], password: params['password'])
    redirect to '/admin'
  end

end
