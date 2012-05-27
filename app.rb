require 'sinatra'
require 'securerandom'
require 'haml'
require './lib/sinatra/redis/redis.rb'

enable :static

configure :development do 
	set :redis, 'redis://localhost:6379/0'
end

configure :production do
	set :redis, 'redis://redistogo:4982d20bd9f828092dc60952e45247d4@bluegill.redistogo.com:9107/0'
end

configure do
	mime_type :less, 'text/css'
end

@title = 'Anonypaste: Get pasted.'
	
get '/' do
	haml :index
end

get '/:paste_id;:lang' do |paste_id,lang|
		@ttl = redis.ttl paste_id
		@paste = redis.get paste_id
		@paste_id = paste_id
		@lang = lang
		#haml "%p This paste will expire in \#{@ttl} seconds.\n%pre= @paste"
		haml :view_paste
end

get '/:paste_id' do |paste_id|
		@ttl = redis.ttl paste_id
		@paste = redis.get paste_id
		@paste_id = paste_id
		haml :view_paste
end

post '/' do
	key = SecureRandom.hex(3)
	redis.pipelined do
		redis.set key, params[:pasteBody]
		redis.expire key, 60*60*24
	end
	redirect "/#{key}"
end
