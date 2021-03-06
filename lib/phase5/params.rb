require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      if !req.query_string.nil?
        @params = parse_www_encoded_form(req.query_string)
      elsif !req.body.nil?
        @params = parse_www_encoded_form(req.body)
      elsif
        !route_params.nil?
        @params = route_params
      end
    end

    def [](key)
      # key.to_sym
      @params
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      arr = URI::decode_www_form(www_encoded_form)
      # return array of key/val [[k1, v1],[k2,v2]]
      @params = {}
      arr.each do |pair|
        key_arr = parse_key(pair[0])
        val = pair[1]
        @params[key_arr.pop] = val
        while key_arr.length > 0
          @params[key_arr.pop] = @params
        end
      end
      @params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
