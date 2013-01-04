require 'sinatra'
require 'securerandom'
require 'haml'
require 'rbconfig'
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

  # fix up the Pygmentize executable path for use on windows
  class << Pygmentize
    alias_method :old_bin, :bin
  end
  
  class Pygmentize
    def self.bin
      if (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
        old_bin.sub(/\/usr\/bin\/env /, "")
      else
        old_bin
      end
    end
    
    def self.css
      args = [
        "-S", "default",
        "-f", "html"
      ]
      IO.popen("#{bin} #{Shellwords.shelljoin args}", "r") do |io|
        io.read
      end
    end
#    def self.process(source, lexer, args = [])
#      args += [
#        "-l", lexer.to_s,
#        "-f", "html",
#        "-O", "encoding=#{source.encoding}"
#      ]
#    
#      IO.popen("#{bin} #{Shellwords.shelljoin args}", "r+") do |io|
#        io.write(source)
#        io.close_write
#        io.read
#      end
#    end
  end
end

@title = 'Anonypaste: Get pasted.'

get '/' do
  haml :index
end

get '/:paste_id;:lang' do |paste_id,lang|
  @paste_id = paste_id
  @lang = lang
  @ttl = redis.ttl @paste_id
  @paste = redis.get @paste_id
  
  @paste_formatted = Pygmentize.process(@paste, @lang.to_sym)
  
  # haml "%p This paste will expire in \#{@ttl} seconds.\n%pre= @paste"
  haml :view_paste2
end

get '/pygments.css' do
  content_type 'text/css'
  Pygmentize.css
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
