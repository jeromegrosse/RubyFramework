require File.join(@@APP_FOLDER + "/app/models/" + "test")

class Dashboard < BaseController
    def index

        time = Time.now

        test = Test.new.tap do |test|
            test.value = rand(0..100)
            test.date  = time.to_i
        end

        test.save

        render = Renderer.new
        render.set("date", time.inspect)
        render.content = 'index.liquid'

        Response.new.tap do |response|
            response.body = render.render
            response.status_code = 200
        end
    end
end