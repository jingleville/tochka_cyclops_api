module TochkaCyclopsApi
  class Response
    def initialize(response)
      @response = response
      @body = response.body
    end
  end
end