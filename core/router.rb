require File.join(File.dirname(__FILE__), 'route')
require 'yaml'

module JFW
    class Router
        attr_reader :routes

        @plurals

        def initialize
            @routes =   [
                            ["/",             {:klass => "Dashboard_Controller", :method => "index",        :directory => "../../../app/controllers/dashboard/dashboard"}],
                            [/favicon.ico$/,  {:klass => "Global_Controller",    :method => "favicon",      :directory => "../../../app/controllers/global_controller"}],
                            [/style\.css$/,   {:klass => "Global_Controller",    :method => "style_css",    :directory => "../../../app/controllers/global_controller"}],
                            [/.*\/fonts\/.*/, {:klass => "Global_Controller",    :method => "fonts",        :directory => "../../../app/controllers/global_controller"}],
                            [/scripts\.js$/,  {:klass => "Global_Controller",    :method => "scripts_js",   :directory => "../../../app/controllers/global_controller"}]
                        ]
        end


        def route_for env
            @@path      = env["PATH_INFO"]

            route_array = _get_route_array @@path

            return JFW::Route.new(route_array) if route_array
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
                method     = ''

                arr_path.each do |p|
                    next if p == '' || p == nil
                    if p != arr_path.last
                        #todo check if number
                        controller += '_' + @plurals[p].capitalize
                        directory  += '/' + @plurals[p]
                    else
                        if p == 'index' || p == 'show' || p == 'new' || p == 'delete'
                            method    = p
                            directory = directory
                        else
                            if( @plurals.has_key?(p) )
                                controller = controller + '_' + @plurals[p].capitalize
                                directory  = directory  + '/' + @plurals[p]
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
                parse = [/.*/, {:klass => controller + "_Controller", :method => method, :directory => '../../../app/controllers' + directory}]
            end

            return parse
        end


        private
        def log message = ""
            logger = Logger.new('log/app.log')
            logger.info("router") { message }
        end
    end
end
