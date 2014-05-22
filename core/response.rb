class Response
    attr_accessor :status_code, :headers, :body

    def initialize
        @headers = {'Content-Type'  => 'text/html'}
        @status_code = 200
        @body = ""
    end

    def rack_response
        [status_code, headers, Array(body)]
    end
end