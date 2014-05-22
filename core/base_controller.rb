require File.join(File.dirname(__FILE__), 'response')
require File.join(File.dirname(__FILE__), 'renderer')

class BaseController
    def initialize env
        @env = env
        @logger = Logger.new('log/app.log')
    end


    def log(tag = "info", message = "")
        @logger.info(tag) { message }
    end
end