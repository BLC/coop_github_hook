# little class that turns on http request logging
# just require 'lib/vendor/active_resource_debug' to activate this
class ActiveResource::Connection
  def http_with_debug(*args)
    http = http_without_debug(*args)
    http.set_debug_output $stderr
    http
  end

  alias :http_without_debug :http
  alias :http :http_with_debug
end
