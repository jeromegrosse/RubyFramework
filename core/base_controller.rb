require File.join(File.dirname(__FILE__), 'response')
require File.join(File.dirname(__FILE__), 'renderer')
require File.join(File.dirname(__FILE__), 'model')

module JFW
    class BaseController
        def initialize env
            @env     = env
            @request = Rack::Request.new(@env)
            @logger  = Logger.new('log/app.log')
        end


        def log(tag = "info", message = "")
            @logger.info(tag) { message }
        end
    end
end
