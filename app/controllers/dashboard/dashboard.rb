class Dashboard < BaseController
    def index


        time = Time.now

        render = Renderer.new
        render.set("date", time.inspect)
        render.content = 'index.liquid'

        Response.new.tap do |response|
            response.body = render.render
            response.status_code = 200
        end
    end
end