require File.join(File.dirname(__FILE__), 'route')
require 'yaml'

class Router
    attr_reader :routes

    @plurals

    def initialize
        @routes =   [
                        ["/",            {:klass => "Dashboard", :method => "index",        :directory => "dashboard/dashboard"}],
                        [/favicon.ico$/,  {:klass => "Global",    :method => "favicon"}],
                        [/style\.css$/,   {:klass => "Global",    :method => "style_css"}],
                        [/.*\/fonts\/.*/, {:klass => "Global",    :method => "fonts"}],
                        [/scripts\.js$/,  {:klass => "Global",    :method => "scripts_js"}]
                    ]
    end


    def route_for env
        @@path      = env["PATH_INFO"]

        route_array = _get_route_array @@path

        return Route.new(route_array) if route_array
        return nil
    end


    private
    def _get_route_array path
        if @plurals.nil?
            @plurals = YAML.load(File.read(@@APP_FOLDER + 'config/controller_plurals.yml'))
        end

        #Check if the path correspond to one of the default
        parse = routes.detect do |route|
            if route.last != ""
                case route.first
                when String
                    path == route.first
                when Regexp
                    path =~ route.first
                end
            end
        end

        if parse == nil
            arr_path = path.split('/')
            controller = ''
            directory  = ''
            method     = '  '

            arr_path.each do |p|
                next if p == '' || p == nil
                if p != arr_path.last
                    #todo check if number
                    controller += "_" + @plurals[p].capitalize
                    directory  += "/" + @plurals[p]
                else
                    if p == 'index' || p == 'show' || p == 'newr' || p == 'delete'
                        method    = p
                        directory = directory
                    else
                        if( @plurals.has_key?(p) )
                            controller = controller + '_' + @plurals[p].capitalize
                            directory  = directory  + "/" + @plurals[p]
                            method     = 'index'
                        else
                            method     = p
                        end
                    end
                end
            end

            raise("No Controller Found!") unless controller != ""
            directory = directory + "/" + controller.split(/_/).last.downcase
            controller[0] = ''
            parse = [/.*/, {:klass => controller, :method => method, :directory => directory}]
        end

        return parse
    end


    private
    def log message = ""
        logger = Logger.new('log/app.log')
        logger.info("router") { message }
    end
end