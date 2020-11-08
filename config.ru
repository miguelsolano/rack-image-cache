# config.ru
require 'rack'

require_relative 'app'
require_relative 'media_cache'

use RackMediaCache

run Rack::Sinatra::Example

