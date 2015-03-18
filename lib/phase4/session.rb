require 'json'
require 'webrick'
require 'byebug'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req) # req is WEBrick::HTTPRequest
      @req = req
      if req.cookies.empty?
        @cookie_hash = {}
      end
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @cookie_hash = JSON.parse(cookie.value)
          # cookie is an object and value is a hash
        else
          @cookie_hash = {}
        end
      end
    end

    def [](key)
      @cookie_hash[key]
    end

    def []=(key, val)
      @cookie_hash[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = @cookie_hash.to_json
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', cookie)
    end
  end
end
