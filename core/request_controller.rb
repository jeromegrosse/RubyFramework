class RequestController
    def call(env)

        begin
            route = BrainRackApplication.router.route_for(env)
            raise "No route found!" unless !route.nil?
        rescue Exception
            return [404, {}, ["404 not found"]]
        end

        response = route.execute(env)
        return response.rack_response
    end
end

