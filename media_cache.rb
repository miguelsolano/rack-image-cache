require 'rack'
require 'mime-types'
require 'fileutils'

class RackMediaCache
  MEDIA_PROC = proc do |env|
    path = Rack::Utils.unescape(env['PATH_INFO'])
    puts path
    mime_set = MIME::Types.type_for(path).first
    unless mime_set.nil?
      mime_set.content_type
    end
  end

  def initialize(app)
    @app = app
    @path_proc = MEDIA_PROC
  end

  def call(env)
    headers = @app.call(env)
    type = @path_proc.call(env)
    if type.include? 'image'
      puts "imaage"
    end
    @app.call(env)
  end
end
