require 'rack'
require 'mime-types'
require 'fileutils'
require 'active_support/core_ext' 

# RackMediaCache
class RackMediaCache
  MEDIA_PROC = proc do |env|
    path = Rack::Utils.unescape(env['PATH_INFO'])
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
    status, headers, body = @app.call(env)
    type = @path_proc.call(env)
    if type.include? 'image'
      headers['Cache-Control'] = "max-age=#{Time.now.to_i}, public"
      headers['Expires'] = Time.now.utc.end_of_month.to_s
    end
    [status, headers, body]
  end
end
