require File.join(@@APP_FOLDER + "/app/models/"     + "test")
require File.join(@@APP_FOLDER + "/app/factories/"  + "test")

class Dashboard < BaseController
    def index

        time = Time.now

        test_factory = Factory_Test.new
        conditions = {'value' => 95}
        test         = test_factory.find_all conditions, {}

        log "dashboard", test

        render = Renderer.new
        render.set("date", time.inspect)
        render.content = 'index.liquid'

        Response.new.tap do |response|
            response.body = render.render
            response.status_code = 200
        end
    end
end