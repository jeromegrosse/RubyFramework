class RequestController
    def call(env)

        begin
            route = BrainRackApplication.router.route_for(env)
            raise "No route found!" unless !route.nil?
        rescue Exception => e
            log e.message
            log e.backtrace
            return [404, {}, ["404 not found"]]
        end

        response = route.execute(env)
        return response.rack_response
    end


    def log(message = "")
        logger = Logger.new('log/app.log')
        logger.info("RequestController") { message }
    end
end

