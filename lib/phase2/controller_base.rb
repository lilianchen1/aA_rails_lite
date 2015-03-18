module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res) # http request and response as input
      @req = req
      @res = res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      return false if @already_built_response.nil?
      true
    end

    # Set the response status code and header
    def redirect_to(url)
      raise "Already built response" if already_built_response?
      res.status = 302
      res['location'] = url
      @already_built_response = url
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      raise "Already built response" if already_built_response?
      res.body = content
      res.content_type = content_type
      @already_built_response = content
    end
  end
end
