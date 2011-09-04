require 'rubygems'
require 'sinatra'
require 'twitter'
require 'haml'
require 'model'

configure do
  use Rack::Session::Cookie, :secret => Model::Twitter::CONSUMER_KEY
  set :haml, {:format => :html5 }
  set :show_exception, true
  set :logging, true
end

helpers do
  alias_method :h, :escape_html
end

def auth?
  return true if session[:access_token] and session[:access_token_secret]
  return false
end

before do
  if session[:access_token]
    
  else
    @twitter = nil
  end
end

get '/' do
  haml :index
end

get '/auth/request_token' do
  request_token = Model::Twitter.get_request_token
  session[:request_token] = request_token.token
  session[:request_token_secret] = request_token.secret
  redirect request_token.authorize_url
end

get '/auth/access_token' do
  if params[:denied]
    p 'access denied'
  end

  request_token = Model::Twitter.request_token(
    session[:request_token], session[:request_token_secret])

  begin
    access_token = request_token.get_access_token(
      {},
      :oauth_token => params[:oauth_token],
      :oauth_verifier => params[:oauth_verifier]
      )
  rescue OAuth::Unauthorized => @e
    halt 400
  end

  session.delete(:request_token)
  session.delete(:request_token_secret)

  Model::User.register(access_token)

  redirect '/timeline'
end

get '/timeline' do
  p auth?
  redirect '/' unless @twitter
  erb %{
    <dl>
    <% @twitter.friends_timeline.each do |twit| %>
      <dt><%= twit.user.name %></dt>
      <dd><%= twit.text %></dd>
    <% end %>
    </dl>
  }
end

get '/logout' do
  session[:access_token] = nil
  session[:access_token_secret] = nil
  redirect app_root
end
