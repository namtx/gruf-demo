# frozen_string_literal: true

require 'gruf'
require 'app/proto/Products_services_pb'

Gruf.configure do |c|
  c.default_client_host = 'localhost:9003'
end
