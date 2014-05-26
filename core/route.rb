require File.join(File.dirname(__FILE__), 'base_controller')

module JFW
    class Route
        attr_accessor :klass_name, :path, :instance_method
        def initialize route_array
            @klass_name      = route_array.last[:klass]
            @instance_method = route_array.last[:method]
            @path            = route_array.last[:directory] != nil ? route_array.last[:directory] : klass_name.downcase.gsub(/#/, '/')
            handle_requires
        end

        def klass
            Module.const_get(klass_name)
        end

        def execute(env)
            klass.new(env).send(instance_method.to_sym)
        end

        def handle_requires
            require_relative File.join(File.dirname(__FILE__), @path + ".rb")
        end
    end
end
