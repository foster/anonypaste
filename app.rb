require 'sinatra'
require 'securerandom'
require 'haml'
require './lib/sinatra/redis/redis.rb'

enable :static
set :redis, 'redis://localhost:6379/0'

@title = 'Anonypaste: Get pasted.'
	
get '/' do
	haml :index
end

get '/:paste_id' do |paste_id|
		@ttl = redis.ttl paste_id
		@paste = redis.get paste_id
		haml "%p This paste will expire in \#{@ttl} seconds.\n%pre= @paste"
end

post '/' do
	key = SecureRandom.hex(3)
	redis.pipelined do
		redis.set key, params[:pasteBody]
		redis.expire key, 60#*60*24
	end
	redirect "/#{key}"
end