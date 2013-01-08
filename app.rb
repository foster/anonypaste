require 'sinatra'
require 'securerandom'
require 'haml'
require 'sass'
require 'pygmentize'
require './lib/sinatra/redis/redis.rb'

enable :static

configure :development do 
  # set :redis, 'redis://localhost:6379/0'
  set :redis, 'redis://redistogo:4982d20bd9f828092dc60952e45247d4@bluegill.redistogo.com:9107/0'
end

configure :production do
  set :redis, 'redis://redistogo:4982d20bd9f828092dc60952e45247d4@bluegill.redistogo.com:9107/0'
end

configure do
  mime_type :less, 'text/css'
end

@title = 'Anonypaste: Get pasted.'
AVAILABLE_LANGUAGES = {
  :text       => 'Text',
  :csharp     => 'C#',
  :javascript => 'Javascript',
  :ruby       => 'Ruby',
  :python     => 'Python',
  :php        => 'PHP',
  :sql        => 'SQL'
}


get '/' do
  haml :index
end

get '/guess/:paste_id' do |paste_id|
  paste = redis.get paste_id
  
  Pygmentize.guess paste
end

get '/site.css' do
  scss :site
end

get '/pygments.css' do
  content_type 'text/css'
  Pygmentize.css
end

# get /:pasteid;:lang
get %r{^/([0-9a-f]{6});?(.*)} do |paste_id, lang|
  @paste_id = paste_id
  @lang = lang.empty? ? redis.get("#{paste_id}:lang") : lang
  @ttl = redis.ttl paste_id
  @paste = redis.get paste_id

  @paste_formatted = Pygmentize.process @paste, @lang.to_sym, ["-O", "style=colorful,linenos=1"]
  
  haml :view_paste
end

get '/raw/:paste_id' do |paste_id|
  content_type 'text/plain'
  redis.get paste_id
end

post '/' do
  key = SecureRandom.hex(3)
  redis.pipelined do
    redis.set key, params[:pasteBody]
    redis.set "#{key}:lang", params[:language]
    redis.expire key, 60*60*24
    redis.expire "#{key}:lang", 60*60*24
  end
  redirect "/#{key}"
end
